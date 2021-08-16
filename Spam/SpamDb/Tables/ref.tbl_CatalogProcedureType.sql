CREATE TABLE ref.tbl_CatalogProcedureType
	(
	Id tinyint not null PRIMARY KEY CLUSTERED
	,Name nvarchar(32)
	,RecordAppend datetime2(7) not null default sysdatetime()
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_CatalogProcedureType_Name on ref.tbl_CatalogProcedureType
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO