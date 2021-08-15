CREATE TABLE ref.tbl_Environment
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_Environment_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_Environment_Name on ref.tbl_Environment
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO