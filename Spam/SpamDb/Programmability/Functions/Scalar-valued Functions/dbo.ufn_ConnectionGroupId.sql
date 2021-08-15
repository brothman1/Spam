CREATE FUNCTION dbo.ufn_ConnectionGroupId
	(
	@ConnectionGroupName nvarchar(32)
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@ConnectionGroupId uniqueidentifier
		SELECT		@ConnectionGroupId = a.Id
		FROM		ref.tbl_ConnectionGroup as a with (nolock)
		WHERE		a.Name = @ConnectionGroupName
		RETURN		@ConnectionGroupId
	END