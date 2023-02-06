NAMESPACE SimaticAx.Lib

    CLASS PUBLIC ControlAxis
        VAR PRIVATE
            _started : BOOL;
        END_VAR

        VAR PRIVATE

        END_VAR

        METHOD PUBLIC Enable : BOOL
            // TODO implement
            Enable := TRUE;
        END_METHOD

        METHOD PUBLIC Move : BOOL
            VAR_INPUT
                speed : LREAL;
            END_VAR
            // TODO implement
            Move := TRUE;
        END_METHOD

        METHOD PUBLIC Stop : BOOL
            // TODO implement
            Stop := TRUE;
        END_METHOD

    END_CLASS

END_NAMESPACE
