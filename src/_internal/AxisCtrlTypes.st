NAMESPACE Motion

    TYPE
        AxisData : STRUCT
            enabled : BOOL;
            homed : BOOL;
            cmd : AxisCmd;
        END_STRUCT;
    END_TYPE

    TYPE
        AxisCmd : INT (
            NONE := 0, 
            ENABLE := 1, 
            DISABLE := 2, 
            STOP := 3, 
            JOG := 4, 
            POS_RELATIVE := 5, 
            POS_ABSOLUTE := 6) := NONE;
    END_TYPE

END_NAMESPACE
