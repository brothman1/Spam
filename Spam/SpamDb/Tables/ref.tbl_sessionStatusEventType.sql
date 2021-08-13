CREATE TABLE ref.tbl_SessionStatusEventType
(
	Id tinyint not null PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null 
	,AppendTimestamp datetime2(7) not null default sysdatetime()
	,UpdateTimestamp datetime2(7) not null default sysdatetime()
)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_ref_SessionStatusEventType on ref.tbl_SessionStatusEventType 
	(
	Name
	)
	INCLUDE	(
			Id
			)
GO