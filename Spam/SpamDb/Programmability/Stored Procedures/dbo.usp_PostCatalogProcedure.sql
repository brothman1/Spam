CREATE PROCEDURE dbo.usp_PostCatalogProcedure
	@CatalogName nvarchar(32)
	,@CatalogProcedureTypeId tinyint
	,@CatalogProcedureName nvarchar(256)
	,@SessionId uniqueidentifier
	,@CatalogProcedureId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate CatalogName
		DECLARE @CatalogId uniqueidentifier = dbo.ufn_CatalogId(@CatalogName)
		--Validate new CatalogProcedure
		IF dbo.ufn_CatalogProcedureId(@CatalogId,@CatalogProcedureName) is not null
			BEGIN
				SET @ErrorMessage = N'CatalogProcedure already exists!'
				RETURN
			END
		BEGIN TRANSACTION
			DECLARE @tbl_CatalogProcedureId table (Id uniqueidentifier)
			BEGIN TRY
				--Create RecordHash
				DECLARE	@RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@CatalogId,@CatalogProcedureTypeId,@CatalogProcedureName))
				--Create new CatalogProcedure
				INSERT INTO dbo.tbl_CatalogProcedure
					(
					CatalogId
					,TypeId
					,Name
					,RecordHash
					,AppendSessionId
					,UpdateSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_CatalogProcedureId
				VALUES	(
						@CatalogId
						,@CatalogProcedureTypeId
						,@CatalogProcedureName
						,@RecordHash
						,@SessionId
						,@SessionId
						)
				--Capture new CatalogProcedureId
				SELECT	@CatalogProcedureId = a.Id
				FROM	@tbl_CatalogProcedureId as a
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