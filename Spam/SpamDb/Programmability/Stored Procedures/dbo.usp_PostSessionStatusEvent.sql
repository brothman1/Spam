CREATE PROCEDURE dbo.usp_PostSessionStatusEvent
	@TypeId tinyint
	,@Timestamp datetime2(7)
	,@UserId nvarchar(32) = null
	,@DomainId nvarchar(32)
	,@HostName nvarchar(128) = null
	,@SessionId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		DECLARE @TypeName nvarchar(32) = dbo.ufn_SessionStatusEventTypeName(@TypeId)
		IF @TypeName = N'Start'
			BEGIN
				exec dbo.usp_PostSessionStatusEvent_Start @TypeId, @Timestamp, @UserId, @DomainId, @HostName, @SessionId OUTPUT, @ErrorMessage OUTPUT
			END
		IF @TypeName = N'End'
			BEGIN
				exec dbo.usp_PostSessionStatusEvent_End @TypeId, @Timestamp, @SessionId, @ErrorMessage OUTPUT
			END
	END
GO