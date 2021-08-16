CREATE FUNCTION dbo.ufn_CatalogProcedureId
	(
	@CatalogId uniqueidentifier
	,@CatalogProcedureName nvarchar(256)
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@CatalogProcedureId uniqueidentifier
		SELECT		@CatalogProcedureId = a.CatalogId
		FROM		dbo.tbl_CatalogProcedure as a with (nolock)
		WHERE		a.CatalogId = @CatalogId
					and a.Name = @CatalogProcedureName
		RETURN		@CatalogProcedureId
	END
GO