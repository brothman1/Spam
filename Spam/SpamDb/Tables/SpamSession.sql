CREATE TABLE dbo.SpamSession
	(
	ID uniqueidentifier NOT NULL default newid() PRIMARY KEY CLUSTERED
	,UserDomain nvarchar(32) NOT NULL
	,UserId nvarchar(32) NOT NULL
	,HostName varchar(128) NOT NULL
	,RecordAppend datetime2(7) default sysdatetime() NOT NULL
	)
GO
CREATE NONCLUSTERED INDEX Nci_dbo_SpamSession_UserDomain on dbo.SpamSession
	(
	UserDomain
	)
	INCLUDE	(
			ID
			,UserId
			,HostName
			)
GO
CREATE NONCLUSTERED INDEX Nci_dbo_SpamSession_UserId on dbo.SpamSession
	(
	UserId
	)
	INCLUDE	(
			ID
			,UserDomain
			,HostName
			)
GO
CREATE NONCLUSTERED INDEX Nci_dbo_SpamSession_HostName on dbo.SpamSession
	(
	HostName
	)
	INCLUDE	(
			ID
			,UserDomain
			,UserId
			)