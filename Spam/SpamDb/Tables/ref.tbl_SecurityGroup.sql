CREATE TABLE ref.tbl_SecurityGroup
(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,Name nvarchar(128) not null
	,DomainId tinyint not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_SecurityGroup_DomainId
		FOREIGN KEY (DomainId)
		REFERENCES ref.tbl_Domain (Id)
	,CONSTRAINT fk_tbl_SecurityGroup_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_SecurityGroup_Name_DomainId on ref.tbl_SecurityGroup
	(
	Name
	,DomainId
	)
	INCLUDE	(
			Id
			)
GO
CREATE NONCLUSTERED INDEX nci_tbl_SecurityGroup_Name on ref.tbl_SecurityGroup
	(
	Name
	)
	INCLUDE	(
			Id
			,DomainId
			)
GO
CREATE NONCLUSTERED INDEX nci_tbl_SecurityGroup_DomainId on ref.tbl_SecurityGroup
	(
	DomainId
	)
	INCLUDE	(
			Id
			,Name
			)
GO