CREATE TABLE dbo.tbl_CatalogProcedure
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,CatalogId uniqueidentifier not null
	,TypeId tinyint not null
	,Name nvarchar(256) not null
	,RecordHash varbinary(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,UpdateSessionId uniqueidentifier not null
	,RecordUpdate datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_CatalogProcedure_CatalogId
		FOREIGN KEY (CatalogId)
		REFERENCES dbo.tbl_Catalog (Id)
	,CONSTRAINT fk_tbl_CatalogProcedure_TypeId
		FOREIGN KEY (TypeId)
		REFERENCES ref.tbl_CatalogProcedureType (Id)
	,CONSTRAINT fk_tbl_CatalogProcedure_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_tbl_CatalogProcedure_UpdateSessionId
		FOREIGN KEY (UpdateSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_CatalogProcedure_CatalogIdTypeId on dbo.tbl_CatalogProcedure
	(
	CatalogId
	,TypeId
	)
	INCLUDE	(
			Id
			,Name
			)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_CatalogProcedure_CatalogIdName on dbo.tbl_CatalogProcedure
	(
	CatalogId
	,Name
	)
	INCLUDE	(
			Id
			,TypeId
			)
GO