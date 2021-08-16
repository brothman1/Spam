CREATE FUNCTION dbo.ufn_CatalogName
	(
	@CatalogId uniqueidentifier
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@CatalogName nvarchar(32)
		SELECT		@CatalogName = a.Name
		FROM		dbo.tbl_Catalog as a with (nolock)
		WHERE		a.Id = @CatalogId
		RETURN		@CatalogId
	END
GO