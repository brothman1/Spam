CREATE FUNCTION dbo.ufn_SessionStatusEventTypeId
	(
	@SessionEventTypeName as nvarchar(32)
	)
	RETURNS tinyint
as
	BEGIN
		DECLARE		@SessionEventTypeId tinyint
		SELECT		@SessionEventTypeId = a.Id
		FROM		ref.tbl_SessionStatusEventType as a with (nolock)
		WHERE		a.Name = @SessionEventTypeName
		RETURN		@SessionEventTypeId
	END
GO