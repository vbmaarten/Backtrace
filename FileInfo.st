"FileInfo class"

Object subclass: FileInfo [
    
    FileInfo class >> architecture: file [
        | fileoutput |

        fileoutput := Tools system: ('file ', file). 
        (fileoutput matchRegex: '.*Intel 80386.*\n*') ifTrue: [ ^'IA32' ].

        ^'None'.

    ]

   FileInfo class >> manifest2dict: file [
        | manfile dict row |

        dict := Dictionary new.
        (FileInfo fileExists: file) ifFalse: [^(Dictionary new)].

        manfile := FileStream open: file mode: 'read'.   
        manfile := manfile contents subStrings: $<10>. 

        1 to: (manfile size) do: [ :i |
            row := (manfile at: i) subStrings: $<32>.
            dict at: (row at: 3) put: (row at: 1).
        ].

        ^dict.
    ]

    FileInfo class >> manifestone: one two: two [
        | manifest_dict1 manifest_dict2 keys |
       
        manifest_dict1 := self manifest2dict: one.
        manifest_dict2 := self manifest2dict: two.

        ((manifest_dict1 keys) = (manifest_dict2 keys)) ifFalse: [^false.].
    
        keys := manifest_dict1 keys asArray.
        1 to: (keys size) do: [ :i |
            ((keys at: i) matchRegex: 'rootfs.*') ifFalse: [
            (manifest_dict1 at: (keys at: i)) = (manifest_dict2 at: (keys at: i)) ifFalse: [
                ^false.
            ].
            ].
        ].

        ^true.
    ]

    FileInfo class >> binaryPath: cmdline [
        | cmdfile path i |

        cmdfile := FileStream open: cmdline mode: 'read'.
        (cmdfile next = $/) ifFalse: [^false.].

        path := '/'.
        [i := cmdfile next.
        ((i ~= $<00>) & (i ~= nil)) ] whileTrue: [
            path := (path, (i asString))
        ].

        ^path.
    ]

    FileInfo class >> extension: file [
        | splited |
        splited := file substrings: $..
        (splited size = 1)
            ifTrue: [
                ^''.
            ].
        ((splited at: ((splited size)-1)) = 'tar')
            ifTrue: [
                ((splited at: (splited size)) = 'gz')
                    ifTrue: [
                        ^'tar.gz'.
                    ].
                ((splited at: (splited size)) = 'bz2')
                    ifTrue: [
                        ^'tar.bz2'.
                    ].
            ].
        ^(splited at: (splited size)).

    ]

    FileInfo class >> fileExists: file [
        ^((File name: file) isFile).
    ]
]
