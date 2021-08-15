CREATE TABLE dbo.tbl_CatalogItemPermission
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,CatalogId uniqueidentifier not null
	,SecurityGroupId uniqueidentifier not null
	,PermissionId tinyint not null
	,PermissionValue bit not null
	,RecordHash varbinary(32) not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,UpdateSessionId uniqueidentifier not null
	,RecordUpdate datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_tbl_CatalogItemPermission_CatalogId
		FOREIGN KEY (CatalogId)
		REFERENCES dbo.tbl_CatalogItem (Id)
	,CONSTRAINT fk_tbl_CatalogItemPermission_SecurityGroupId
		FOREIGN KEY (SecurityGroupId)
		REFERENCES ref.tbl_SecurityGroup (Id)
	,CONSTRAINT fk_tbl_CatalogItemPermission_PermissionId
		FOREIGN KEY (PermissionId)
		REFERENCES ref.tbl_Permission (Id)
	,CONSTRAINT fk_tbl_CatalogItemPermission_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_tbl_CatalogItemPermission_UpdateSessionId
		FOREIGN KEY (UpdateSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_tbl_CatalogItemPermission_CatalogId_SecurityGroupId_PermissionId on dbo.tbl_CatalogItemPermission
	(
	CatalogId
	,SecurityGroupId
	,PermissionId
	)
	INCLUDE	(
			Id
			,PermissionValue
			)
GO