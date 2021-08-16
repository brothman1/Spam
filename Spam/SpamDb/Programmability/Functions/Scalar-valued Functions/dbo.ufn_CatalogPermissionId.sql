CREATE FUNCTION dbo.ufn_CatalogPermissionId
	(
	@CatalogId uniqueidentifier
	,@SecurityGroupId uniqueidentifier
	,@PermissionId tinyint
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@CatalogPermissionId uniqueidentifier
		SELECT		@CatalogPermissionId = a.Id
		FROM		dbo.tbl_CatalogPermission as a with (nolock)
		WHERE		a.CatalogId = @CatalogId
					and a.SecurityGroupId = @SecurityGroupId
					and a.PermissionId = @PermissionId
		RETURN		@CatalogPermissionId
	END
GO