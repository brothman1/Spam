CREATE PROCEDURE dbo.usp_PutCatalogProcedure
	@CatalogName nvarchar(32)
	,@CatalogProcedureTypeId tinyint
	,@CatalogProcedureName nvarchar(256)
	,@SessionId uniqueidentifier
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate CatalogName
		DECLARE @CatalogId uniqueidentifier = dbo.ufn_CatalogId(@CatalogName)
		DECLARE	@CatalogProcedureId uniqueidentifier = dbo.ufn_CatalogProcedureId(@CatalogId,@CatalogProcedureName)
		--Validate CatalogProcedure Exists
		IF NOT EXISTS (SELECT 1 FROM dbo.tbl_CatalogProcedure as a with (nolock) WHERE a.Id = @CatalogProcedureId)
			BEGIN
				SET @ErrorMessage = N'CatalogProcedure does not exist!'
			END
		BEGIN TRANSACTION
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@CatalogId,@CatalogProcedureTypeId,@CatalogProcedureName))
				--Update CatalogProcedure
				UPDATE	a
				SET		a.CatalogId = @CatalogId
						,a.TypeId = @CatalogProcedureTypeId
						,a.Name = @CatalogProcedureName
						,a.RecordHash = @RecordHash
						,a.UpdateSessionId = @SessionId
						,a.RecordUpdate = default
				FROM	dbo.tbl_CatalogProcedure as a
				WHERE	a.Id = @CatalogProcedureId
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
