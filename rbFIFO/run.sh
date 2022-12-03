
export FORTE3=$HOME/forte_c/public_reflect_ac5107



export TCL_TK=/usr




export TCL_LIBRARY=/usr/share/tcl8.4
export TK_LIBRARY=/usr/share/tk8.4
export TIX_LIBRARY=/usr/share/tix8.1

export PATH=/usr/share:$PATH


export FLLIB=$FORTE3/methlib:$FORTE3/component
export FLLIB=$FORTE3/methlib:$FORTE3/component



export forte=$FORTE3/bin/forte
export  nexlif2exe2=$FORTE3/bin/nexlif2exe2

python gen_sol.py
$forte -noX -f run_opt.fl

