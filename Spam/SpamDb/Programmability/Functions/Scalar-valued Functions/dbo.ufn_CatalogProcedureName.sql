CREATE FUNCTION dbo.ufn_CatalogProcedureName
	(
	@CatalogProcedureId uniqueidentifier
	)
	RETURNS nvarchar(256)
as
	BEGIN
		DECLARE		@CatalogProcedureName nvarchar(256)
		SELECT		@CatalogProcedureName = a.Name
		FROM		dbo.tbl_CatalogProcedure as a with (nolock)
		WHERE		a.Id = @CatalogProcedureId
		RETURN		@CatalogProcedureName
	END
GO