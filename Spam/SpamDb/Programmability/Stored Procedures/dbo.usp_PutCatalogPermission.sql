CREATE PROCEDURE dbo.usp_PutCatalogPermission
	@CatalogName nvarchar(32)
	,@SecurityGroupName nvarchar(128)
	,@DomainId tinyint
	,@PermissionName nvarchar(32)
	,@PermissionValue bit
	,@SessionId uniqueidentifier
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate CatalogName, SecurituGroupName, PermissionId
		DECLARE @CatalogId uniqueidentifier = dbo.ufn_CatalogId(@CatalogName)
		DECLARE	@SecurityGroupId uniqueidentifier = dbo.ufn_SecurityGroupId(@SecurityGroupName,@DomainId)
		DECLARE @PermissionId tinyint = dbo.ufn_PermissionId(@PermissionName)
		DECLARE	@CatalogPermissionId uniqueidentifier = dbo.ufn_CatalogPermissionId(@CatalogId,@SecurityGroupId,@PermissionId)
		--Validate CatalogPermission Exists
		IF NOT EXISTS (SELECT 1 FROM dbo.tbl_CatalogPermission as a with (nolock) WHERE a.Id = @CatalogPermissionId)
			BEGIN
				SET @ErrorMessage = N'CatalogPermission does not exist!'
			END
		BEGIN TRANSACTION
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@CatalogId,@SecurityGroupId,@PermissionId,@PermissionValue))
				--Update Catalog
				UPDATE	a
				SET		a.CatalogId = @CatalogId
						,a.SecurityGroupId = @SecurityGroupId
						,a.PermissionId = @PermissionId
						,a.PermissionValue = @PermissionValue
						,a.RecordHash = @RecordHash
						,a.UpdateSessionId = @SessionId
						,a.RecordUpdate = default
				FROM	dbo.tbl_CatalogPermission as a
				WHERE	a.Id = @CatalogPermissionId
			END TRY
			BEGIN CATCH
				SET @ErrorMessage = error_message()
				IF @@TRANCOUNT > 0 
					BEGIN 
						ROLLBACK TRANSACTION 
					END
				RETURN
			END CATCH
		COMMIT TRANSACTION
	END
GO