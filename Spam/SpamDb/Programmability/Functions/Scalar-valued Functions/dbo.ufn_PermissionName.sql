CREATE FUNCTION dbo.ufn_PermissionName
	(
	@PermissionId tinyint
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@PermissionName nvarchar(32)
		SELECT		@PermissionName = a.Name
		FROM		ref.tbl_Permission as a with (nolock)
		WHERE		a.Id = @PermissionId
		RETURN		@PermissionName
	END