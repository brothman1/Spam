CREATE FUNCTION dbo.ufn_SecurityGroupDomainId
	(
	@SecurityGroupId uniqueidentifier
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@SecurityGroupDomainId tinyint
		SELECT		@SecurityGroupDomainId = a.DomainId
		FROM		ref.tbl_SecurityGroup as a with (nolock)
		WHERE		a.Id = @SecurityGroupId
		RETURN		@SecurityGroupDomainId
	END