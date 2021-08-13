CREATE PROCEDURE dbo.usp_SessionStatusEvent_End
	@TypeId tinyint
	,@Timestamp datetime2(7)
	,@SessionId uniqueidentifier
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Validate TypeId
		IF @TypeId <> dbo.ufn_SessionStatusEventTypeId(N'End')
			BEGIN
				SET @ErrorMessage = N'Can only run usp_SessionStatusEvent_End when ending a session!'
				RETURN
			END
		BEGIN TRANSACTION
			BEGIN TRY
				--Record Session End Event
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
