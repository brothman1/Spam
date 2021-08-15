CREATE FUNCTION dbo.ufn_SecurityGroupId
	(
	@SecurityGroupName nvarchar(128)
	,@SecurityGroupDomainId tinyint
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@SecurityGroupId uniqueidentifier
		SELECT		@SecurityGroupId = a.Id
		FROM		ref.tbl_SecurityGroup as a with (nolock)
		WHERE		a.Name = @SecurityGroupName
					and a.DomainId = @SecurityGroupDomainId
		RETURN		@SecurityGroupId
	END
GO