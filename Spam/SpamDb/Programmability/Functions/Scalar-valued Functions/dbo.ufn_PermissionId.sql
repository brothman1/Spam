CREATE FUNCTION dbo.ufn_PermissionId
	(
	@PermissionName nvarchar(32)
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@PermissionId tinyint
		SELECT		@PermissionId = a.Id
		FROM		ref.tbl_Permission as a with (nolock)
		WHERE		a.Name = @PermissionName
		RETURN		@PermissionId
	END
GO