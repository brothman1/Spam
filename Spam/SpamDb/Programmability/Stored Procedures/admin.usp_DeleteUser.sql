CREATE PROCEDURE admin.usp_DeleteUser
	@DomainId tinyint
	,@UserId nvarchar(32)
as
	BEGIN
		SET NOCOUNT ON
		DECLARE		@DomainName nvarchar(32) = dbo.ufn_DomainName(@DomainId)
		DECLARE		@DomainContainer nvarchar(128) = dbo.ufn_DomainContainer(@DomainId)
		DECLARE		@Hash varbinary(64) = hashbytes('SHA2_512',concat(@DomainName,@DomainContainer,@UserId))
		DELETE FROM admin.tbl_User
		WHERE		Hash = @Hash
	END
GO