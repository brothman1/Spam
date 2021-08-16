CREATE FUNCTION dbo.ufn_CatalogPermissionCatalogId
	(
	@CatalogPermissionId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@CatalogId uniqueidentifier
		SELECT		@CatalogId = a.CatalogId
		FROM		dbo.tbl_CatalogPermission as a with (nolock)
		WHERE		a.Id = @CatalogPermissionId
		RETURN		@CatalogId
	END
GO