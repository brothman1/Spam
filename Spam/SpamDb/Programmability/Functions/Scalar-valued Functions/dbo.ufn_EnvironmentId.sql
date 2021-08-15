CREATE FUNCTION dbo.ufn_EnvironmentId
	(
	@EnvironmentName nvarchar(32)
	)
	RETURNS uniqueidentifier
as
	BEGIN
		DECLARE		@EnvironmentId uniqueidentifier
		SELECT		@EnvironmentId = a.Id
		FROM		ref.tbl_Environment as a with (nolock)
		WHERE		a.Name = @EnvironmentName
		RETURN		@EnvironmentId
	END