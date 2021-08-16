CREATE FUNCTION dbo.ufn_CatalogPermissionSecurityGroupId
	(
	@CatalogPermissionId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@SecurityGroupId uniqueidentifier
		SELECT		@SecurityGroupId = a.SecurityGroupId
		FROM		dbo.tbl_CatalogPermission as a with (nolock)
		WHERE		a.Id = @CatalogPermissionId
		RETURN		@SecurityGroupId
	END
GO