CREATE TABLE dbo.tbl_Catalog
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,ConnectionGroupId uniqueidentifier not null
	,Name nvarchar(32) not null
	,RecordHash varbinary(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,UpdateSessionId uniqueidentifier not null
	,RecordUpdate datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_Catalog_ConnectionGroupId
		FOREIGN KEY (ConnectionGroupId)
		REFERENCES ref.tbl_ConnectionGroup (Id)
	,CONSTRAINT fk_tbl_Catalog_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_tbl_Catalog_UpdateSessionId
		FOREIGN KEY (UpdateSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_Catalog_Name on dbo.tbl_Catalog
	(
	Name
	)
	INCLUDE	(
			Id
			,ConnectionGroupId
			)
GO