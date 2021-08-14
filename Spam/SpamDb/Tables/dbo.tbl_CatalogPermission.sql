CREATE TABLE dbo.tbl_CatalogPermission
	(
	Id uniqueidentifier not null default newid() PRIMARY KEY CLUSTERED
	,CatalogId uniqueidentifier not null
	,SecurityGroupId uniqueidentifier not null
	,PermissionId tinyint not null
	,PermissionValue bit not null
	,AppendSessionId uniqueidentifier not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	,UpdateSessionId uniqueidentifier not null
	,RecordUpdate datetime2(7) not null default sysdatetime()
	,CONSTRAINT fk_dbo_tbl_CatalogPermission_CatalogId
		FOREIGN KEY (CatalogId)
		REFERENCES dbo.tbl_Catalog (Id)
	,CONSTRAINT fk_dbo_tbl_CatalogPermission_SecurityGroupId
		FOREIGN KEY (SecurityGroupId)
		REFERENCES ref.tbl_SecurityGroup (Id)
	,CONSTRAINT fk_dbo_tbl_CatalogPermission_PermissionId
		FOREIGN KEY (PermissionId)
		REFERENCES ref.tbl_Permission (Id)
	,CONSTRAINT fk_dbo_tbl_CatalogPermission_AppendSessionId
		FOREIGN KEY (AppendSessionId)
		REFERENCES dbo.tbl_Session (Id)
	,CONSTRAINT fk_dbo_tbl_CatalogPermission_UpdateSessionId
		FOREIGN KEY (UpdateSessionId)
		REFERENCES dbo.tbl_Session (Id)
	)
GO
CREATE UNIQUE NONCLUSTERED INDEX nci_dbo_tbl_CatalogPermission_CatalogId_SecurityGroupId_PermissionId on dbo.tbl_CatalogPermission
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