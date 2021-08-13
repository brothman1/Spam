CREATE PROCEDURE dbo.usp_SessionStatusEvent
	@TypeId tinyint
	,@Timestamp datetime2(7)
	,@UserId nvarchar(32) = null
	,@DomainName nvarchar(32) = null
	,@DomainContainer nvarchar(128) = null
	,@HostName nvarchar(128) = null
	,@SessionId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		DECLARE @TypeName nvarchar(32) = dbo.ufn_SessionStatusEventTypeName(@TypeId)
		DECLARE @DomainId tinyint = dbo.ufn_DomainId(@DomainName,@DomainContainer)
		IF @TypeName = N'Start'
			BEGIN
				exec dbo.usp_SessionStatusEvent_Start @TypeId, @Timestamp, @UserId, @DomainId, @HostName, @SessionId OUTPUT, @ErrorMessage OUTPUT
			END
		IF @TypeName = N'End'
			BEGIN
				exec dbo.usp_SessionStatusEvent_End @TypeId, @Timestamp, @SessionId, @ErrorMessage OUTPUT
			END
	END
