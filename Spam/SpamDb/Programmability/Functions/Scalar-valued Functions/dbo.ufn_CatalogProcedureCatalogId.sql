CREATE FUNCTION dbo.ufn_CatalogProcedureCatalogId
	(
	@CatalogProcedureId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@CatalogId uniqueidentifier
		SELECT		@CatalogId = a.CatalogId
		FROM		dbo.tbl_CatalogProcedure as a with (nolock)
		WHERE		a.Id = @CatalogProcedureId
		RETURN		@CatalogId
	END
GO