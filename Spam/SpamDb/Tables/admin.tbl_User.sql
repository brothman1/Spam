CREATE TABLE admin.tbl_User
(
	Id tinyint IDENTITY (1,1) PRIMARY KEY CLUSTERED
	,Hash varbinary(64)
)
GO
CREATE NONCLUSTERED INDEX nci_tbl_User_Hash on admin.tbl_User
	(
	Hash
	)
	INCLUDE	(
			Id
			)
GO