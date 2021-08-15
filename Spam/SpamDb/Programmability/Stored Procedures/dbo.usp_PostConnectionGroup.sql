CREATE PROCEDURE dbo.usp_PostConnectionGroup
	@ConnectionGroupName nvarchar(32)
	,@SessionId uniqueidentifier
	,@ConnectionGroupId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Validate new ConnectionGroup
		IF dbo.ufn_ConnectionGroupId(@ConnectionGroupName) is null
			BEGIN
				SET @ErrorMessage = N'ConnectionGroup already exists'
				RETURN
			END
		BEGIN TRANSACTION
		DECLARE	@tbl_ConnectionGroupId table (Id uniqueidentifier)
			BEGIN TRY
				--Create new ConnectionGroup
				INSERT INTO ref.tbl_ConnectionGroup
					(
					Name
					,AppendSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_ConnectionGroupId
				VALUES	(
						@ConnectionGroupName
						,@SessionId
						)
				--Capture new ConnectionGroupId
				SELECT	@ConnectionGroupId = a.Id
				FROM	@tbl_ConnectionGroupId as a
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