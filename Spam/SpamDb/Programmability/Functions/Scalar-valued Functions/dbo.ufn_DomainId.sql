CREATE FUNCTION dbo.ufn_DomainId
	(
	@DomainName as nvarchar(32)
	,@DomainContainer as nvarchar(128)
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@DomainId tinyint
		SELECT		@DomainId = a.Id
		FROM		ref.tbl_Domain as a with (nolock)
		WHERE		a.Name = @DomainName
					and a.Container = @DomainContainer
		RETURN		@DomainId
	END