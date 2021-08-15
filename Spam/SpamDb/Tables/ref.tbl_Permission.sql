CREATE TABLE ref.tbl_Permission
	(
	Id tinyint not null PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_Permission_Name on ref.tbl_Permission
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO