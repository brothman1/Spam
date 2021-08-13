CREATE TABLE dbo.tbl_Session
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,UserId nvarchar(32) not null
	,DomainName nvarchar(32) not null
	,DomainContainer nvarchar(128) not null
	,HostName nvarchar(128) not null
	,RecordAppend datetime2(7) default sysdatetime() not null
	)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_Session_UserId on dbo.tbl_Session
	(
	UserId
	)
	INCLUDE	(
			Id
			,DomainName
			,DomainContainer
			,HostName
			)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_Session_DomainName on dbo.tbl_Session
	(
	DomainName
	)
	INCLUDE	(
			Id
			,UserId
			,DomainContainer
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
			,DomainName
			,DomainContainer
			)
GO