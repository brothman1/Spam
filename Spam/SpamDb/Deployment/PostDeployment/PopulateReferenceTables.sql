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