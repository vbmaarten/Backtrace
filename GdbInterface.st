"GdbInterface class"

Object subclass: GdbInterface [

    GdbInterface class >> backtrace: bin core: core working: work [
        |in output btstart btend bt| 
        Tools system: 'echo "print \"bt-mark-start\"\nbt\nprint \"bt-mark-stop\"\nquit\n" > ', work, '/backtrace'.
        
        Tools system: 'gdb ', bin, ' -c ', core, ' --command=backtrace -cd=',work, ' > btoutput'.

        in := FileStream open: 'btoutput' mode: FileStream read.
        output := in copyFrom: 1 to: (in size).
        
        btstart := output indexOfRegex: 'bt-mark-start'.
        (btstart size = 0) ifTrue: [^''].
        btend:= (output indexOfRegex: 'bt-mark-stop').
        (btend size = 0) ifTrue: [^''].
        btstart := btstart at: 1.
        btend := btend at: 1.
        
        bt := output copyFrom: (btstart + 14) to: (btend - 7).
        
        Files remove: (work,'/backtrace').
        Files remove: 'btoutput'.

        ^bt.
    ]
]
