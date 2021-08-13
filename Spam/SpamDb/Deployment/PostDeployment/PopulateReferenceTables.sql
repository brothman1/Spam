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
