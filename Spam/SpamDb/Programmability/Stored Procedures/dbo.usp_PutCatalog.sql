CREATE PROCEDURE dbo.usp_PutCatalog
	@ConnectionGroupName nvarchar(32)
	,@CatalogName nvarchar(32)
	,@SessionId uniqueidentifier
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate ConnectionGroupName and CatalogName
		DECLARE	@ConnectionGroupId uniqueidentifier = dbo.ufn_ConnectionGroupId(@ConnectionGroupName)
		DECLARE @CatalogId uniqueidentifier = dbo.ufn_CatalogId(@CatalogName)
		--Validate Catalog Exists
		IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Catalog as a with (nolock) WHERE a.Id = @CatalogId)
			BEGIN
				SET @ErrorMessage = N'Catalog does not exist!'
			END
		BEGIN TRANSACTION
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@ConnectionGroupId,@CatalogName))
				--Updaste Catalog
				UPDATE	a
				SET		a.ConnectionGroupId = @ConnectionGroupId
						,a.Name = @CatalogName
						,a.RecordHash = @RecordHash
						,a.UpdateSessionId = @SessionId
						,a.RecordUpdate = default
				FROM	dbo.tbl_Catalog as a
				WHERE	a.Id = @CatalogId
						and a.RecordHash <> @RecordHash
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