CREATE PROCEDURE dbo.usp_GetSecurityGroups
	@DomainName nvarchar(32) = null
	,@DomainContainer nvarchar(128) = null
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		BEGIN TRY
			DECLARE		@DomainId tinyint = dbo.ufn_DomainId(@DomainName,@DomainContainer)
			SELECT		a.Name
			FROM		ref.tbl_SecurityGroup as a with (nolock)
			WHERE		a.DomainId = @DomainId
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = error_message()
		END CATCH
	END