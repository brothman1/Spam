CREATE FUNCTION dbo.ufn_ConnectionEnvironmentId
	(
	@ConnectionId uniqueidentifier
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@ConnectionEnvironmentId uniqueidentifier
		SELECT		@ConnectionEnvironmentId = a.EnvironmentId
		FROM		ref.tbl_Connection as a with (nolock)
		WHERE		a.Id = @ConnectionId
		RETURN		@ConnectionEnvironmentId
	END