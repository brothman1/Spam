CREATE FUNCTION dbo.ufn_SecurityGroupName
	(
	@SecurityGroupId uniqueidentifier
	)
	RETURNS nvarchar(128)
as
	BEGIN
		DECLARE		@SecurityGroupName nvarchar(128)
		SELECT		@SecurityGroupName = a.Name
		FROM		ref.tbl_SecurityGroup as a with (nolock)
		WHERE		a.Id = @SecurityGroupId
		RETURN		@SecurityGroupName
	END
GO