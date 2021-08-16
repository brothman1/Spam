CREATE FUNCTION dbo.ufn_CatalogProcedureTypeId
	(
	@CatalogProcedureTypeName nvarchar(32)
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@CatalogProcedureTypeId tinyint
		SELECT		@CatalogProcedureTypeId = a.Id
		FROM		ref.tbl_CatalogProcedureType as a with (nolock)
		WHERE		a.Name = @CatalogProcedureTypeName
		RETURN		@CatalogProcedureTypeId
	END
GO