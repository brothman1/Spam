CREATE FUNCTION dbo.ufn_CatalogPermissionPermissionId
	(
	@CatalogPermissionId uniqueidentifier
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@PermissionId tinyint
		SELECT		@PermissionId = a.PermissionId
		FROM		dbo.tbl_CatalogPermission as a with (nolock)
		WHERE		a.Id = @CatalogPermissionId
		RETURN		@PermissionId
	END
GO