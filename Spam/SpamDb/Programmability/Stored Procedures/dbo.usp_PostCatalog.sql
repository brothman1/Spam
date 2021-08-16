CREATE PROCEDURE dbo.usp_PostCatalog
	@ConnectionGroupName nvarchar(32)
	,@CatalogName nvarchar(32)
	,@SessionId uniqueidentifier
	,@CatalogId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate ConnectionGroupName
		DECLARE @ConnectionGroupId uniqueidentifier = dbo.ufn_ConnectionGroupId(@ConnectionGroupName)
		--Validate new Catalog
		IF dbo.ufn_CatalogId(@CatalogName) is not null
			BEGIN
				SET @ErrorMessage = N'Catalog already exists!'
				RETURN
			END
		BEGIN TRANSACTION
			DECLARE @tbl_CatalogId table (Id uniqueidentifier)
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@ConnectionGroupId,@CatalogName))
				--Create new Catalog
				INSERT INTO dbo.tbl_Catalog
					(
					ConnectionGroupId
					,Name
					,RecordHash
					,AppendSessionId
					,UpdateSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_CatalogId
				VALUES	(
						@ConnectionGroupId
						,@CatalogName
						,@RecordHash
						,@SessionId
						,@SessionId
						)
				--Capture new CatalogId
				SELECT	@CatalogId = a.Id
				FROM	@tbl_CatalogId as a
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