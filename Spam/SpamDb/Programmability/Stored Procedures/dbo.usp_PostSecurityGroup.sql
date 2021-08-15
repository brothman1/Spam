CREATE PROCEDURE dbo.usp_PostSecurityGroup
	@SecurityGroupName nvarchar(128)
	,@SecuirityGroupDomainId tinyint
	,@SessionId uniqueidentifier
	,@SecurityGroupId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Validate new SecurityGroup
		IF dbo.ufn_SecurityGroupId(@SecurityGroupName,@SecuirityGroupDomainId) is null
			BEGIN
				SET @ErrorMessage = N'Security group already exists!'
				RETURN
			END
		BEGIN TRANSACTION
		DECLARE @tbl_SecurityGroupId table (Id uniqueidentifier)
			BEGIN TRY
				--Create new SecurityGroup
				INSERT INTO ref.tbl_SecurityGroup
					(
					Name
					,DomainId
					,AppendSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_SecurityGroupId
				VALUES	(
						@SecurityGroupName
						,@SecuirityGroupDomainId
						,@SessionId
						)
				--Capture new SecurityGroupId
				SELECT	@SecurityGroupId = a.Id
				FROM	@tbl_SecurityGroupId as a
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
GO