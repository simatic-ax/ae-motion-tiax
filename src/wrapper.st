NAMESPACE SimaticAx.Lib

    FUNCTION_BLOCK MotorWrapper
        VAR_INPUT
            start : BOOL;
        END_VAR
        VAR
            m : ControlAxis;
        END_VAR
        
        IF start THEN
            m.Enable();
        END_IF;
    END_FUNCTION_BLOCK

END_NAMESPACE
