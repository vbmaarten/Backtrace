"Main"

"Gather necesary files"
"get .tar.gz file"
| root targz unpacked_targz
  root_manifest 
  unpacked_core
  ow_dir 
  filesys_dir 
  unpacked_bz2 |

root := File name: '.'.
targz := (root filesMatching: '*.tar.gz').

((targz size) = 1)
    ifTrue: [
        targz := targz at: 1.
    ]
    ifFalse: [
        Transcript show: 'Count of tar.gz files != 1.'; cr.
        ObjectMemory quit.
    ].

"unpack .tar.gz"
unpacked_targz := (Files unpack: (targz name)).

"get manifest file"
root_manifest := (root filesMatching: '*manifest').

((root_manifest size) = 1)
    ifTrue: [
        root_manifest := root_manifest at: 1.
    ]
    ifFalse: [
        Transcript show: 'Count of manifest files != 1.'; cr.
        ObjectMemory quit.
    ].

"get binary path"
binary_dir := (FileInfo binaryPath: './proc/cmdline').

"unpack core.gz"
unpacked_core := (Files unpack: ('core.gz')). 
"gzip doesn't properly list the files it unpacks so"
unpacked_core add: 'core'.

"Walk through ow-* dir to find manifest file"
ow_dir := (root filesMatching: 'ow-*')
((ow_dir size) = 1)
    ifTrue: [
        ow_dir := ow_dir at: 1.
    ]
    ifFalse: [
        Transcript show: 'Count of ow-* directories != 1.'; cr.
        ObjectMemory quit.
    ].

filesys_dir := 'None'.
Directory allFilesMatching: '*' do: [ :file |
    ((file asString) matchRegex: '.*/manifest') ifTrue: [
        
        (FileInfo manifestone: (root_manifest asString) two: (file asString))
            ifTrue: [
                filesys_dir := (file asString) copyFrom: 1 to: ((file asString size) - ('/manifest' size)).
            ].
    ].
].

(filesys_dir = 'None')
    ifTrue: [
        Transcript show: 'No matching manifest file found'; cr.
        ObjectMemory quit.
    ].

Directory working: filesys_dir.

"Unpack rootfs.debug.tar.bz2"
unpacked_bz2 := Files unpack: 'rootfs.debug.tar.bz2'.

Directory working: root.
Transcript show: (GdbInterface backtrace: (filesys_dir asString, binary_dir asString) core: ((root asString), '/core') working: (filesys_dir asString)).

"Cleaning up"
Files clean: unpacked_targz.
Files clean: unpacked_core.
Directory working: filesys_dir.
Files clean: unpacked_bz2.
Directory working: root.
