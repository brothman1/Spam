CREATE PROCEDURE admin.usp_AddUser
	@DomainId tinyint
	,@UserId nvarchar(32)
as
	BEGIN
		SET NOCOUNT ON
		DECLARE		@DomainName nvarchar(32) = dbo.ufn_DomainName(@DomainId)
		DECLARE		@DomainContainer nvarchar(128) = dbo.ufn_DomainContainer(@DomainId)
		DECLARE		@Hash varbinary(64) = hashbytes('SHA2_512',concat(@DomainName,@DomainContainer,@UserId))
		IF admin.ufn_IsAdmin(@Hash) = 0
			BEGIN
				INSERT INTO admin.tbl_User
					(
					Hash
					)
				VALUES (@Hash)
			END
		ELSE
			BEGIN
				PRINT 'User is already an admin!'
			END
	END