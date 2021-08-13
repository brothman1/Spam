CREATE TABLE dbo.tbl_SessionStatus
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,SessionId uniqueidentifier not null
	,EventTypeId tinyint not null
	,EventTimestamp datetime2(7) not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_dbo_tbl_SessionStatus_SessionId
		FOREIGN KEY (SessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_ref_tbl_SessionStatusEventType
		FOREIGN KEY (EventTypeId)
		REFERENCES ref.tbl_SessionStatusEventType (Id)
	)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_SessionStatus_SessionId on dbo.tbl_SessionStatus
	(
	SessionId
	)
	INCLUDE	(
			Id
			,EventTypeId
			,EventTimestamp
			)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_SessionStatus_SessionId_EventTypeId on dbo.tbl_SessionStatus
	(
	SessionId
	,EventTypeId
	)
	INCLUDE	(
			Id
			,EventTimestamp
			)
GO
CREATE NONCLUSTERED INDEX nci_dbo_tbl_SessionStatus_EventTimestamp on dbo.tbl_SessionStatus
	(
	EventTimestamp
	)
	INCLUDE	(
			Id
			,SessionId
			,EventTypeId
			)
GO