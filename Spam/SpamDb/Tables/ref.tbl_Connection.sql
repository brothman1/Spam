CREATE TABLE ref.tbl_Connection
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,GroupId uniqueidentifier not null
	,EnvironmentId uniqueidentifier not null
	,EncryptedConnectionString varbinary(8000) not null
	,RecordHash varbinary(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,UpdateSessionId uniqueidentifier not null
	,RecordUpdate datetime2(7) not null default sysdatetime()
	,CONSTRAINT cnst_tbl_Connection_GroupId_EnvironmentId UNIQUE (GroupId, EnvironmentId)
	,CONSTRAINT fk_tbl_Connection_GroupId
		FOREIGN KEY (GroupId)
		REFERENCES ref.tbl_ConnectionGroup (Id)
	,CONSTRAINT fk_tbl_Connection_EnvironmentId
		FOREIGN KEY (EnvironmentId)
		REFERENCES ref.tbl_Environment (Id)
	,CONSTRAINT fk_tbl_Connection_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_tbl_Connection_UpdateSessionId
		FOREIGN KEY (UpdateSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO