CREATE TABLE ref.tbl_ConnectionGroup
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_ConnectionGroup_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_ConnectionGroup_Name on ref.tbl_ConnectionGroup
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO