CREATE PROCEDURE dbo.usp_GetSessionInformation
	@SessionId uniqueidentifier
	,@UserId nvarchar(32) = null OUTPUT
	,@DomainName nvarchar(32) = null OUTPUT
	,@DomainContainer nvarchar(128) = null OUTPUT
	,@HostName nvarchar(128) = null OUTPUT
	,@IsActive bit = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		BEGIN TRY
			--Get latest status
			SELECT		a.SessionId
						,case	when dbo.ufn_SessionStatusEventTypeName(a.EventTypeId) = 'Start' then cast(1 as bit)
								else cast(0 as bit)
								end as IsActive
						,row_number() over	(
											partition by	a.SessionId
											order by		a.EventTimestamp desc
											) as SessionStatusIndex
			INTO		#SESSION_STATUS
			FROM		dbo.tbl_SessionStatus as a with (nolock)
			WHERE		a.SessionId = @SessionId
			--Return Session
			SELECT		@UserId = a.UserId
						,@DomainName = dbo.ufn_DomainName(a.DomainId)
						,@DomainContainer = dbo.ufn_DomainContainer(a.DomainId)
						,@HostName = a.HostName
						,@IsActive = b.IsActive
			FROM		dbo.tbl_Session as a
						INNER JOIN #SESSION_STATUS as b with (nolock)
							on a.Id = b.SessionId
							and b.SessionStatusIndex = 1
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = error_message()
		END CATCH
	END
