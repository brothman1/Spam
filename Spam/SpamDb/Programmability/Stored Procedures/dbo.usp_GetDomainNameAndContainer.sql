CREATE PROCEDURE dbo.usp_GetDomainNameAndContainer
	@DomainId tinyint
	,@DomainName nvarchar(32) = null OUTPUT
	,@DomainContainer nvarchar(128) = null OUTPUT
	,@ErrorMessage nvarchar(4000) = null OUTPUT
as
	BEGIN
		SET NOCOUNT ON
		IF NOT EXISTS (SELECT 1 FROM ref.tbl_Domain as a with (nolock) WHERE a.Id = @DomainId)
			BEGIN
				SET @ErrorMessage = N'Specified domain does not exist!'
				RETURN
			END
		BEGIN TRANSACTION
			BEGIN TRY
				SELECT		@DomainName = dbo.ufn_DomainName(@DomainId)
							,@DomainContainer = dbo.ufn_DomainContainer(@DomainId)
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