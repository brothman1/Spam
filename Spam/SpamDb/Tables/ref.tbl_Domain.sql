CREATE TABLE ref.tbl_Domain
(
	Id tinyint not null PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null
	,Container nvarchar(128) not null
	,RecordAppend datetime2(7) not null default sysdatetime()
)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_ref_tbl_Domain_Name_Container on ref.tbl_Domain
	(
	Name
	,Container
	)
	INCLUDE	(
			Id
			)
GO