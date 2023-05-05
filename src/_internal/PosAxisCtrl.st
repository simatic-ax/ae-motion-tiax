USING Siemens.Simatic.S71500.MotionControl.Native;
NAMESPACE Motion

    CLASS PUBLIC PosAxisCtrl EXTENDS SpeedAxisCtrl

        VAR PROTECTED
            _mcHome         : MC_HOME;
            _mcMoveRel      : MC_MOVERELATIVE;
            _mcMoveAbs      : MC_MOVEABSOLUTE;
        END_VAR

        METHOD PUBLIC OVERRIDE SetAxis : BOOL 
            VAR_INPUT
                axisDB : DB_ANY;
            END_VAR
            _axisDB := axisDB;
            SetAxis := THIS.RefToAxisIsValid();
        END_METHOD

        METHOD PUBLIC OVERRIDE ResetCmds
            SUPER.ResetCmds();
            _mcHome.Execute := FALSE;
            _mcMoveRel.Execute := FALSE;
            _mcMoveAbs.Execute := FALSE;
        END_METHOD

        METHOD PUBLIC HomeAxis
            VAR_INPUT
                position : LREAL;
                homingMode : INT;
            END_VAR
            _mcHome.Mode := homingMode;
            _mcHome.Position := position;
            _mcHome.Execute := TRUE;
        END_METHOD

        METHOD PUBLIC PosRelative
            VAR_INPUT
                distance : LREAL;
                velocity : LREAL;
                acceleration : LREAL;
                deceleration : LREAL;
                jerk : LREAL;
            END_VAR
            _mcMoveRel.Execute := TRUE;
            _mcMoveRel.Distance := distance;
            _mcMoveRel.velocity := velocity;
            _mcMoveRel.Acceleration := acceleration;
            _mcMoveRel.Deceleration := deceleration;
            _axisData.cmd := AxisCmd#POS_RELATIVE;
        END_METHOD

        METHOD PUBLIC PosAbsolute
            VAR_INPUT
                position : LREAL;
                velocity : LREAL;
                acceleration : LREAL;
                deceleration : LREAL;
                jerk : LREAL;
                direction : INT;
            END_VAR
            _mcMoveAbs.Execute := TRUE;
            _mcMoveAbs.Position := position;
            _mcMoveAbs.velocity := velocity;
            _mcMoveAbs.Acceleration := acceleration;
            _mcMoveAbs.Deceleration := deceleration;
            _mcMoveAbs.Jerk := jerk;
            IF direction > 0 THEN
                _mcMoveAbs.Direction := direction;
            ELSE
                _mcMoveAbs.Direction := 1;
            END_IF;
            _axisData.cmd := AxisCmd#POS_ABSOLUTE;
        END_METHOD
        
        METHOD PUBLIC OVERRIDE CyclicCall
            VAR_TEMP
                _axisAsPos      : REF_TO TO_PositioningAxis;
            END_VAR
            SUPER.CallMcBlocksSpeedAxis();
            THIS.CallMcBlocksPosAxis();
            _axisAsPos := AsPositioningAxisRef(_axisDB);
        END_METHOD

        METHOD PROTECTED CallMcBlocksPosAxis
            VAR_TEMP
                _axisAsPos      : REF_TO TO_PositioningAxis;
                _axisAsAxis     : REF_TO TO_Axis;
            END_VAR
            _axisAsPos := AsPositioningAxisRef(_axisDB);
            _axisAsAxis := _axisAsPos;
            IF _axisAsPos = NULL THEN
                RETURN;
            ELSE
                _mcHome(Axis := _axisAsAxis^);
                _mcMoveRel(Axis := _axisAsPos^);
                _mcMoveAbs(Axis := _axisAsPos^);
                
                IF _mcHome.Done THEN
                    _axisData.cmd := AxisCmd#NONE;
                    _mcHome.Execute := FALSE;
                END_IF;

                IF _mcMoveRel.Done OR _mcMoveRel.CommandAborted THEN
                    _mcMoveRel.Execute := FALSE;
                END_IF;

                IF _mcMoveAbs.Done OR _mcMoveAbs.CommandAborted THEN
                    _mcMoveAbs.Execute := FALSE;
                END_IF;
                _axisData.homed := _axisAsPos^.StatusWord.%X5;
            END_IF;

        END_METHOD

        METHOD PUBLIC OVERRIDE RefToAxisIsValid : BOOL
            VAR_TEMP
                _axisAsPos    : REF_TO TO_PositioningAxis;
            END_VAR
            _axisAsPos := AsPositioningAxisRef(_axisDB);
                RefToAxisIsValid := _axisAsPos <> NULL;
        END_METHOD

    END_CLASS

END_NAMESPACE
