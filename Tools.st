"Tools class"

Object subclass: Tools [
    "Tools class"    

    Tools class >> system: command [
        "System command"
        | pipe |

        pipe := FileStream popen: command dir: FileStream read.
        ^pipe contents.
    ]
]

