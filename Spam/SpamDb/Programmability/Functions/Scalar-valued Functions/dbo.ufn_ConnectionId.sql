CREATE FUNCTION dbo.ufn_ConnectionId
	(
	@ConnectionConnectionGroupId uniqueidentifier
	,@ConnectionEnvironmentId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@ConnectionId uniqueidentifier
		SELECT		@ConnectionId = a.Id
		FROM		ref.tbl_Connection as a with (nolock)
		WHERE		a.GroupId = @ConnectionConnectionGroupId
					and a.EnvironmentId = @ConnectionEnvironmentId
		RETURN		@ConnectionId
	END
GO