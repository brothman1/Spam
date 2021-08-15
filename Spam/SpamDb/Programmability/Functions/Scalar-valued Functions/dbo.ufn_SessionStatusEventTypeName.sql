CREATE FUNCTION dbo.ufn_SessionStatusEventTypeName
	(
	@SessionEventTypeId as tinyint
	)
	RETURNS nvarchar(32)
as
	BEGIN
		DECLARE		@SessionEventTypeName nvarchar(32)
		SELECT		@SessionEventTypeName = a.Name
		FROM		ref.tbl_SessionStatusEventType as a with (nolock)
		WHERE		a.Id = @SessionEventTypeId
		RETURN		@SessionEventTypeName
	END
GO