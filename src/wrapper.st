USING Siemens.Simatic.S71500.MotionControl.Native;
NAMESPACE Motion
    FUNCTION_BLOCK Wrapper
        VAR_INPUT
            SetAxes : BOOL;
            Enable : BOOL;
            Disable : BOOL;
            PosRel : BOOL;
            PosAbs : BOOL;
            MoveVel : BOOL;
            Home : BOOL;
            Halt : BOOL;
            ResetCmds : BOOL;
            DefaultAccel : LREAL;
            DefaultDecel : LREAL;
            DefaultVel : LREAL;
            DefaultJerk : LREAL;
            PosVal : LREAL;
            SpeedAxis : DB_ANY;
            PosAxis : DB_ANY;
        END_VAR
        VAR_OUTPUT
            Error : BOOL;
        END_VAR
        VAR
            _speedAxisInst : PosAxisCtrl;
            _posAxisInst : PosAxisCtrl;
            _state : INT;
        END_VAR

        CASE _state OF
            0: //one-time setup
                IF SetAxes THEN
                    _speedAxisInst.SetAxis(SpeedAxis);
                    _posAxisInst.SetAxis(PosAxis);
                    _state := 1;
                END_IF;
                
            1: //enable axes
                IF Enable THEN
                    _speedAxisInst.EnableAxis();
                    _posAxisInst.EnableAxis(startmode := 1);
                    _state := 2;
                END_IF;

            2: //wait for command
                IF MoveVel THEN
                    _speedAxisInst.MoveVelocity(
                        velocity := DefaultVel, 
                        acceleration := DefaultAccel, 
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk
                    );
                    _posAxisInst.MoveVelocity(
                        velocity := DefaultVel, 
                        acceleration := DefaultAccel, 
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk
                    );
                ELSIF ResetCmds THEN
                    _posAxisInst.ResetCmds();
                    _speedAxisInst.ResetCmds();
                ELSIF Home THEN
                    _posAxisInst.HomeAxis(
                        position := 0.0,
                        homingMode := 0
                    );
                ELSIF PosRel THEN
                    _posAxisInst.PosRelative(
                        distance := PosVal, 
                        velocity := DefaultVel, 
                        acceleration := DefaultAccel, 
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk
                    );
                ELSIF PosAbs THEN
                    _posAxisInst.PosAbsolute(
                        position := PosVal, 
                        velocity := DefaultVel, 
                        acceleration := DefaultAccel, 
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk
                    );
                ELSIF Disable THEN
                    _speedAxisInst.DisableAxis(
                        stopMode := 1
                    );
                    _posAxisInst.DisableAxis(
                        stopMode := 1
                    );
                    _state := 1;
                ELSIF Halt THEN
                    _speedAxisInst.StopAxis(
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk,
                        abortAcceleration := TRUE
                    );
                    _posAxisInst.StopAxis(    
                        deceleration := DefaultDecel, 
                        jerk := DefaultJerk,
                        abortAcceleration := TRUE
                    );
                END_IF;
            
            ELSE
                ;
        END_CASE;

        _speedAxisInst.CyclicCall();
        _posAxisInst.CyclicCall();

    END_FUNCTION_BLOCK
    
END_NAMESPACE
