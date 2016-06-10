#!/bin/sh
#\
exec tclsh $0 ${1+"$@"}

proc ecc {s e} {
    for {set i $s} {$i <= $e} {incr i} {
        set p [expr {$i - 1}]
        file rename chapter$i.xml chapter$p.xml
    }
}

file delete chapter16.xml chapter32.xml chapter37.xml
ecc 17 31
ecc 33 36

