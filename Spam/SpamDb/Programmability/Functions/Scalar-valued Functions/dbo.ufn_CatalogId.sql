CREATE FUNCTION dbo.ufn_CatalogId
	(
	@CatalogName nvarchar(32)
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@CatalogId uniqueidentifier
		SELECT		@CatalogId = a.Id
		FROM		dbo.tbl_Catalog as a with (nolock)
		WHERE		a.Name = @CatalogName
		RETURN		@CatalogName
	END
GO