CREATE PROCEDURE dbo.usp_PutConnection
	@ConnectionGroupName nvarchar(32)
	,@EnvironmentName nvarchar(32)
	,@ConnectionString nvarchar(256)
	,@SessionId uniqueidentifier
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		--Translate ConnectionGroup and ConnectionEnvironment
		DECLARE	@ConnectionGroupId uniqueidentifier = dbo.ufn_ConnectionGroupId(@ConnectionGroupName)
		DECLARE	@EnvironmentId uniqueidentifier = dbo.ufn_ConnectionEnvironmentId(@EnvironmentName)
		DECLARE @ConnectionId uniqueidentifier = dbo.ufn_ConnectionId(@ConnectionGroupId,@EnvironmentId)
		--Validate Connection Exists
		IF NOT EXISTS (SELECT 1 FROM ref.tbl_Connection as a with (nolock) WHERE a.Id = @ConnectionId)
			BEGIN
				SET @ErrorMessage = N'Connection does not exist!'
				RETURN
			END
		BEGIN TRANSACTION
			BEGIN TRY
				--Encrypt ConnectionString
				OPEN SYMMETRIC KEY ConnectionStringSymmetricKey DECRYPTION BY CERTIFICATE ConnectionStringCertificate
					DECLARE	@EncryptedConnectionString varbinary(8000) = encryptbykey(key_guid(N'ConnectionStringSymmetricKey'),@ConnectionString)
				CLOSE SYMMETRIC KEY ConnectionStringSymmetricKey
				--Create RecordHash
				DECLARE @RecordHash varbinary(32) = hashbytes('SHA2_256',concat(@ConnectionGroupId,@EnvironmentId,@EncryptedConnectionString))
				--Update Connection
				UPDATE	a
				SET		a.EncryptedConnectionString = @EncryptedConnectionString
						,a.RecordHash = @RecordHash
						,a.UpdateSessionId = @SessionId
						,a.RecordUpdate = default
				FROM	ref.tbl_Connection as a
				WHERE	a.Id = @ConnectionId
						and a.RecordHash <> @RecordHash
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