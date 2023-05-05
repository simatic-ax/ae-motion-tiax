USING Siemens.Simatic.S71500.MotionControl.Native;
NAMESPACE Motion

    CLASS PUBLIC SpeedAxisCtrl

        VAR PROTECTED

            _mcPower    : MC_POWER;
            _mcJog      : MC_MOVEJOG;
            _mcHalt     : MC_HALT;
            _mcMoveVel  : MC_MOVEVELOCITY;

            _axisData   : AxisData;

            _axisDB : DB_ANY;

        END_VAR

        METHOD PUBLIC SetAxis : BOOL
            VAR_INPUT
                axisDB : DB_ANY;
            END_VAR
            _axisDB := axisDB;
            SetAxis := THIS.RefToAxisIsValid();
        END_METHOD

        METHOD PUBLIC ResetCmds
            _mcHalt.Execute := FALSE;
            _mcMoveVel.Execute := FALSE;
        END_METHOD

        METHOD PUBLIC EnableAxis
            VAR_INPUT
                startMode : INT;
            END_VAR
            _mcPower.StartMode := startMode;
            _mcPower.Enable := TRUE;
            _axisData.cmd := AxisCmd#ENABLE;
        END_METHOD

        METHOD PUBLIC DisableAxis
            VAR_INPUT
                stopMode : INT;
            END_VAR
            _mcPower.StopMode := stopMode;
            _mcPower.Enable := FALSE;
            _axisData.cmd := AxisCmd#DISABLE;
        END_METHOD

        METHOD PUBLIC StopAxis
            VAR_INPUT
                deceleration : LREAL;
                jerk : LREAL;
                abortAcceleration : BOOL;
            END_VAR
            _mcHalt.Deceleration := deceleration;
            _mcHalt.Jerk := jerk;
            _mcHalt.AbortAcceleration := abortAcceleration;
            _mcHalt.Execute := TRUE;
            _axisData.cmd := AxisCmd#STOP;
        END_METHOD

        METHOD PUBLIC MoveVelocity
            VAR_INPUT
                velocity : LREAL;
                acceleration : LREAL;
                deceleration : LREAL;
                jerk : LREAL;
                direction : INT;
                maintainCurrentVel : BOOL;
            END_VAR
            _mcMoveVel.velocity := velocity;
            _mcMoveVel.Acceleration := acceleration;
            _mcMoveVel.Deceleration := deceleration;
            _mcMoveVel.Jerk := jerk;
            _mcMoveVel.direction := direction;
            _mcMoveVel.Current := maintainCurrentVel;
            _mcMoveVel.Execute := TRUE;
        END_METHOD

        METHOD PUBLIC GetAxisStatus : AxisData
            GetAxisStatus := _axisData;
        END_METHOD

        METHOD PUBLIC CyclicCall
            THIS.CallMcBlocksSpeedAxis();
            _axisData.enabled := _mcPower.Status;

        END_METHOD

        METHOD PROTECTED CallMcBlocksSpeedAxis

            VAR_TEMP
                _axisAsSpeed    : REF_TO TO_SpeedAxis;
                _axisAsAxis     : REF_TO TO_Axis;
            END_VAR

            IF NOT THIS.RefToAxisIsValid() THEN
                RETURN;
            ELSE
                _axisAsSpeed := AsSpeedAxisRef(_axisDB);
                _axisAsAxis := AsAxisRef(_axisDB);
            
                _mcPower(Axis := _axisAsAxis^);
                _mcHalt(Axis := _axisAsSpeed^);
                _mcJog(Axis := _axisAsSpeed^);
                _mcMoveVel(Axis := _axisAsSpeed^);
                
                IF _mcHalt.Done THEN
                    _axisData.cmd := AxisCmd#NONE;
                    _mcHalt.Execute := FALSE;
                END_IF;

                IF _mcMoveVel.CommandAborted THEN
                    _axisData.cmd := AxisCmd#NONE;
                    _mcMoveVel.Execute := FALSE;
                END_IF;
            END_IF;

        END_METHOD

        METHOD PUBLIC RefToAxisIsValid : BOOL
            VAR_TEMP
                _axisAsSpeed    : REF_TO TO_SpeedAxis;
            END_VAR
                _axisAsSpeed := AsSpeedAxisRef(_axisDB);
                RefToAxisIsValid := _axisAsSpeed <> NULL;
        END_METHOD
        
    END_CLASS

END_NAMESPACE
