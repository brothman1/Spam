CREATE FUNCTION dbo.ufn_ConnectionGroupName
	(
	@ConnectionGroupId uniqueidentifier
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@ConnectionGroupName nvarchar(32)
		SELECT		@ConnectionGroupName = a.Name
		FROM		ref.tbl_ConnectionGroup as a with (nolock)
		WHERE		a.Id = @ConnectionGroupId
		RETURN		@ConnectionGroupName
	END
GO