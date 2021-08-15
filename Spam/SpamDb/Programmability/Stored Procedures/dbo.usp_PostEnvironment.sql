CREATE PROCEDURE dbo.usp_PostEnvironment
	@EnvironmentName nvarchar(32)
	,@SessionId uniqueidentifier
	,@EnvironmentId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Validate new Environment
		IF dbo.ufn_EnvironmentId(@EnvironmentName) is not null
			BEGIN
				SET @ErrorMessage = N'Environment already exists!'
				RETURN
			END
		BEGIN TRANSACTION
			DECLARE	@tbl_EnvironmentId table (Id uniqueidentifier)
			BEGIN TRY
				--Create new Environment
				INSERT INTO ref.tbl_Environment
					(
					Name
					,AppendSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_EnvironmentId
				VALUES	(
						@EnvironmentName
						,@SessionId
						)
				--Capture new EnvironmentId
				SELECT	@EnvironmentId = a.Id
				FROM	@tbl_EnvironmentId as a
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