CREATE FUNCTION dbo.ufn_CatalogProcedureTypeName
	(
	@CatalogProcedureTypeId tinyint
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@CatalogProcedureTypeName nvarchar(32)
		SELECT		@CatalogProcedureTypeName = a.Name
		FROM		ref.tbl_CatalogProcedureType as a with (nolock)
		WHERE		a.Id = @CatalogProcedureTypeId
		RETURN		@CatalogProcedureTypeName
	END
GO