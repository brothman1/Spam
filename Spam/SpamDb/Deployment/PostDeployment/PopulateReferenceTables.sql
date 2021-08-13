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
--Create base session
DECLARE		@Timestamp datetime2(7) = sysdatetime()
DECLARE     @SessionId uniqueidentifier
exec dbo.usp_SessionStatusEvent 1,@Timestamp,'U71ODH','GEICO','dc=GEICO,dc=corp,dc=net','M2L13003',@SessionId OUTPUT
--Populate SecurityGroup
IF (dbo.ufn_SecurityGroupId('ENT-FS-REGIONAL-DATAINTEL-C',1) is null)
    BEGIN
        INSERT INTO ref.tbl_SecurityGroup
            (
            Name
	        ,DomainId
            ,AppendSessionId
            )
        VALUES ('ENT-FS-REGIONAL-DATAINTEL-C',1,@SessionId)
    END