CREATE TABLE dbo.tbl_Session
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,UserId nvarchar(32) not null
	,DomainId tinyint not null
	,HostName nvarchar(128) not null
	,RecordAppend datetime2(7) default sysdatetime() not null
	,CONSTRAINT fk_dbo_tbl_Session_DomainId
		FOREIGN KEY (DomainId)
		REFERENCES ref.tbl_Domain (Id)
	)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_Session_UserId on dbo.tbl_Session
	(
	UserId
	)
	INCLUDE	(
			Id
			,DomainId
			,HostName
			)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_Session_DomainId on dbo.tbl_Session
	(
	DomainId
	)
	INCLUDE	(
			Id
			,UserId
			,HostName
			)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_Session_HostName on dbo.tbl_Session
	(
	HostName
	)
	INCLUDE	(
			Id
			,UserId
			,DomainId
			)
GO