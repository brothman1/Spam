CREATE FUNCTION dbo.ufn_DomainName
	(
	@DomainId tinyint
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@DomainName nvarchar(32)
		SELECT		@DomainName = a.Name
		FROM		ref.tbl_Domain as a with (nolock)
		WHERE		a.Id = @DomainId
		RETURN		@DomainName
	END