CREATE PROCEDURE dbo.usp_PostConnection
	@ConnectionGroupName nvarchar(32)
	,@EnvironmentName nvarchar(128)
	,@ConnectionString nvarchar(256)
	,@SessionId uniqueidentifier
	,@ConnectionId uniqueidentifier = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate ConnectionGroupName and EnvironmentName
		DECLARE	@ConnectionGroupId uniqueidentifier = dbo.ufn_ConnectionGroupId(@ConnectionGroupName)
		DECLARE	@EnvironmentId uniqueidentifier = dbo.ufn_EnvironmentId(@EnvironmentName)
		--Validate new Connection
		IF dbo.ufn_ConnectionId(@ConnectionGroupId,@EnvironmentId) is not null
			BEGIN
				SET @ErrorMessage = N'Connection already exists!'
				RETURN
			END
		BEGIN TRANSACTION
			DECLARE @tbl_ConnectionId table (Id uniqueidentifier)
			BEGIN TRY
				--Encrypt ConnectionString
				OPEN SYMMETRIC KEY ConnectionStringSymmetricKey DECRYPTION BY CERTIFICATE ConnectionStringCertificate
					DECLARE	@EncryptedConnectionString varbinary(8000) = encryptbykey(key_guid(N'ConnectionStringSymmetricKey'),@ConnectionString)
				CLOSE SYMMETRIC KEY ConnectionStringSymmetricKey
				--Create RecordHash
				DECLARE @RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@ConnectionGroupId,@EnvironmentId,@EncryptedConnectionString))
				--Create new Connection
				INSERT INTO ref.tbl_Connection
					(
					GroupId
					,EnvironmentId
					,EncryptedConnectionString
					,RecordHash
					,AppendSessionId
					,UpdateSessionId
					)
				OUTPUT	inserted.Id
				INTO	@tbl_ConnectionId
				VALUES	(
						@ConnectionGroupId
						,@EnvironmentId
						,@EncryptedConnectionString
						,@RecordHash
						,@SessionId
						,@SessionId
						)
				--Capture new ConnectionId
				SELECT	@ConnectionId = a.Id
				FROM	@tbl_ConnectionId as a
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