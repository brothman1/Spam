CREATE FUNCTION dbo.ufn_DomainContainer
	(
	@DomainId tinyint
	)
	RETURNS nvarchar(128)
as
	BEGIN
		DECLARE		@DomainContainer nvarchar(128)
		SELECT		@DomainContainer = a.Container
		FROM		ref.tbl_Domain as a with (nolock)
		WHERE		a.Id = @DomainId
		RETURN		@DomainContainer
	END
GO