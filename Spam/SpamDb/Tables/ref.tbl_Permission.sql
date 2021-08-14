CREATE TABLE ref.tbl_Permission
	(
	Id tinyint not null PRIMARY KEY CLUSTERED
	,Name nvarchar(32) not null
	,RecordAppend datetime2(7) not null default sysdatetime()
	)