CREATE FUNCTION dbo.ufn_EnvironmentName
	(
	@EnvironmentId uniqueidentifier
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@EnvironmentName nvarchar(32)
		SELECT		@EnvironmentName = a.Name
		FROM		ref.tbl_Environment as a with (nolock)
		WHERE		a.Id = @EnvironmentId
		RETURN		@EnvironmentName
	END
GO