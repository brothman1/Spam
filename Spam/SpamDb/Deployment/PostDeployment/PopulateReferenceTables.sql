--Populate SessionStatusEventType
IF dbo.ufn_SessionStatusEventTypeId('Start') is null
    BEGIN
        INSERT INTO ref.tbl_SessionStatusEventType
            (
            Id
            ,Name
            )
        VALUES (1,'Start')
    END
IF dbo.ufn_SessionStatusEventTypeId('End') is null
    BEGIN
        INSERT INTO ref.tbl_SessionStatusEventType
            (
            Id
            ,Name
            )
        VALUES (2,'End')
    END
--Populate Domain
IF dbo.ufn_DomainId('GEICO','dc=GEICO,dc=corp,dc=net') is null
    BEGIN
        INSERT INTO ref.tbl_Domain
            (
            Id
            ,Name
            ,Container
            )
        VALUES (1,'GEICO','dc=GEICO,dc=corp,dc=net')
    END
--Populate Permissions
IF dbo.ufn_PermissionId('Get') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (1, 'Get')
    END
IF dbo.ufn_PermissionId('Post') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (2, 'Post')
    END
IF dbo.ufn_PermissionId('PostMany') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (3, 'PostMany')
    END
IF dbo.ufn_PermissionId('Put') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (4, 'Put')
    END
IF dbo.ufn_PermissionId('PutMany') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (5, 'PutMany')
    END
IF dbo.ufn_PermissionId('Delete') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (6, 'Delete')
    END
IF dbo.ufn_PermissionId('DeleteMany') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (7, 'DeleteMany')
    END
IF dbo.ufn_PermissionId('Control') is null
    BEGIN
        INSERT INTO ref.tbl_Permission
            (
            Id
            ,Name
            )
        VALUES (8, 'Control')
    END
--Populate Catalog Procedure Type
IF dbo.ufn_CatalogProcedureTypeId('Get') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (1, 'Get')
    END
IF dbo.ufn_CatalogProcedureTypeId('Post') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (2, 'Post')
    END
IF dbo.ufn_CatalogProcedureTypeId('PostMany') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (3, 'PostMany')
    END
IF dbo.ufn_CatalogProcedureTypeId('Put') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (4, 'Put')
    END
IF dbo.ufn_CatalogProcedureTypeId('PutMany') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (5, 'PutMany')
    END
IF dbo.ufn_CatalogProcedureTypeId('Delete') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (6, 'Delete')
    END
IF dbo.ufn_CatalogProcedureTypeId('DeleteMany') is null
    BEGIN
        INSERT INTO ref.tbl_CatalogProcedureType
            (
            Id
            ,Name
            )
        VALUES (7, 'DeleteMany')
    END
--Populate User
exec admin.usp_AddUser 1, 'U71ODH'
--Create base session
DECLARE		@Timestamp datetime2(7) = sysdatetime()
DECLARE     @SessionId uniqueidentifier
exec dbo.usp_PostSessionStatusEvent 1,@Timestamp,'U71ODH',1,'M2L13003',@SessionId OUTPUT
--Populate SecurityGroup
exec dbo.usp_PostSecurityGroup 'ENT-FS-REGIONAL-DATAINTEL-C',1,@SessionId
--Populate Environment
exec dbo.usp_PostEnvironment 'Development',@SessionId
exec dbo.usp_PostEnvironment 'Test',@SessionId
exec dbo.usp_PostEnvironment 'Production',@SessionId
