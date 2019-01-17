8 Bit CPU - V2
==============

So yeah, this is another 8-bit CPU project, starting with an emulator to validate the basic design...

| Address | Size (bytes) | Unit (name) | Read/Write/Both |
|---------|--------------------------|-------------|-----------------|
| 0x0000  | 1 | A Register | RW |
| 0x0001  | 1 | B Register | RW |
| 0x0002  | 2 | M Register | RW |
| 0x0004  | 2 | PC Register | RW |
| 0x0006  | 1 | Instruction Register | RW |
| 0x0007  | 1 | Flags Register | RW |
| 0x0008  | 1 | 0x00 Constant | RO |
| 0x0009  | 1 | 0xFF Constant | RO |
| 0x000A  | 1 | 0x7F Constant | RO |
| 0x000B  | 1 | 0xC0 Constant | RO |
| 0x0010  | 32751 | General Ram  | RW |
| 0x8000  | 16383 | IO Bus | RW |
| 0xC000  | 16383 | General ROM  | RO |


