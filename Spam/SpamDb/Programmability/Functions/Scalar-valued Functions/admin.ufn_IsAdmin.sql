CREATE FUNCTION admin.ufn_IsAdmin
	(
	@UserHash varbinary(64)
	)
	RETURNS bit
as
	BEGIN
		DECLARE		@IsAdmin bit = case	when EXISTS (SELECT 1 FROM admin.tbl_User as a with (nolock) WHERE a.Hash = @UserHash) then 1 else 0 end
		RETURN		@IsAdmin
	END
GO