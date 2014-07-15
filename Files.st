"Files class"

Object subclass: Files [
    "Files class"

    Files class >> unpack: file [
        | extension |
        (FileInfo fileExists: file) ifFalse: [^false].

        extension := FileInfo extension: file. 
        (extension = 'tar.gz') ifTrue: [
            ^((Tools system: 'tar xvzf ', file) subStrings: $<10>).
        ].
        (extension = 'tar.bz2') ifTrue: [
            ^((Tools system: 'tar xvjf ', file) subStrings: $<10>).
        ].
        (extension = 'gz') ifTrue: [
            ^((Tools system: 'gzip -df ', file) subStrings: $<10>).
        ].

        ^false.
    ]

    Files class >> touch: file [
        Tools system: ('touch ', file).
    ]

    Files class >> clean: files [
        1 to: (files size) do: [ :i |
            self remove: (files at: i).
        ].
    ]

    Files class >> remove: file[
        Tools system: ('rm -rf ', file).        
    ]
    
    Files class >> copy: file to: location [
        Tools system: ('cp -rf ', file, ' ', location).
    ]
]
