CREATE FUNCTION dbo.ufn_ConnectionConnectionGroupId
	(
	@ConnectionId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@ConnectionGroupId uniqueidentifier
		SELECT		@ConnectionGroupId = a.GroupId
		FROM		ref.tbl_Connection as a with (nolock)
		WHERE		a.Id = @ConnectionId
		RETURN		@ConnectionGroupId
	END
GO