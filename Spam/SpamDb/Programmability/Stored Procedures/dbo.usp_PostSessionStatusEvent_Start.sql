CREATE PROCEDURE dbo.usp_PostSessionStatusEvent_Start
	@TypeId tinyint
	,@Timestamp datetime2(7)
	,@UserId nvarchar(32)
	,@DomainId tinyint
	,@HostName nvarchar(128)
	,@SessionId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Validate TypeId
		IF @TypeId <> dbo.ufn_SessionStatusEventTypeId(N'Start')
			BEGIN
				SET @ErrorMessage = N'Can only run usp_SessionStatusEvent_Start when starting a session!'
				RETURN
			END
		BEGIN TRANSACTION
		DECLARE @tbl_SessionId table (Id uniqueidentifier)
			BEGIN TRY
				--Start new Session
				INSERT INTO dbo.tbl_Session
					(
					UserId
					,DomainId
					,HostName
					)
				OUTPUT	inserted.Id
				INTO	@tbl_SessionId
				VALUES	(
						@UserId
						,@DomainId
						,@HostName
						)
				--Capture new SessionId
				SELECT	@SessionId = a.Id
				FROM	@tbl_SessionId as a
				--Record Session Start Event
				INSERT INTO dbo.tbl_SessionStatus
					(
					SessionId
					,EventTypeId
					,EventTimestamp
					)
				VALUES	(
						@SessionId
						,@TypeId
						,@Timestamp
						)
			END TRY
			BEGIN CATCH
				SET @ErrorMessage = error_message()
				IF @@TRANCOUNT > 0 
					BEGIN 
						ROLLBACK TRANSACTION 
					END
				RETURN
			END CATCH
		COMMIT TRANSACTION
	END
