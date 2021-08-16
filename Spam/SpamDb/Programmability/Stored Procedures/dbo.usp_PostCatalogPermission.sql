CREATE PROCEDURE dbo.usp_PostCatalogPermission
	@CatalogName nvarchar(32)
	,@SecurityGroupName nvarchar(128)
	,@DomainId tinyint
	,@PermissionName nvarchar(32)
	,@PermissionValue bit
	,@SessionId uniqueidentifier
	,@CatalogPermissionId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate CatalogName, SecurituGroupName, PermissionId
		DECLARE @CatalogId uniqueidentifier = dbo.ufn_CatalogId(@CatalogName)
		DECLARE	@SecurityGroupId uniqueidentifier = dbo.ufn_SecurityGroupId(@SecurityGroupName,@DomainId)
		DECLARE @PermissionId tinyint = dbo.ufn_PermissionId(@PermissionName)
		--Validate new CatalogPermission
		IF dbo.ufn_CatalogPermissionId(@CatalogId,@SecurityGroupId,@PermissionId) is not null
			BEGIN
				SET @ErrorMessage = N'CatalogPermission already exists!'
				RETURN
			END
		BEGIN TRANSACTION
			DECLARE @tbl_CatalogPermissionId table (Id uniqueidentifier)
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@CatalogId,@SecurityGroupId,@PermissionId,@PermissionValue))
				--Create new CatalogPermission
				INSERT INTO dbo.tbl_CatalogPermission
					(
					CatalogId
					,SecurityGroupId
					,PermissionId
					,PermissionValue
					,RecordHash
					,AppendSessionId
					,UpdateSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_CatalogPermissionId
				VALUES	(
						@CatalogId
						,@SecurityGroupId
						,@PermissionId
						,@PermissionValue
						,@RecordHash
						,@SessionId
						,@SessionId
						)
				--Capture new CatalogPermissionId
				SELECT	@CatalogPermissionId = a.Id
				FROM	@tbl_CatalogPermissionId as a
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