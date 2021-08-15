CREATE TABLE ref.tbl_Database
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,Name nvarchar(128) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null
	,CONSTRAINT fk_tbl_Database_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_Database_Name on ref.tbl_Database
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO