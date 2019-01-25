8 Bit CPU - V2
==============

So yeah, this is another 8-bit CPU project, starting with an emulator to validate the basic design...

## Memory Layout

| Address | End Address | Size (bytes) | Unit (name) | Read/Write/Both |
|---------|-------------|--------------|-------------|-----------------|
| 0x0000  | 0x0000 | 1 | A Register | RW |
| 0x0001  | 0x0001 | 1 | B Register | RW |
| 0x0002  | 0x0003 | 2 | M Register | RW |
| 0x0004  | 0x0005 | 2 | PC Register | RW |
| 0x0006  | 0x0006 | 1 | Instruction Register | RW |
| 0x0007  | 0x0007 | 1 | Flags Register | RW |
| 0x0008  | 0x0008 | 1 | 0x00 Constant | RO |
| 0x0009  | 0x0009 | 1 | 0xFF Constant | RO |
| 0x000A  | 0x000A | 1 | 0x7F Constant | RO |
| 0x000B  | 0x000B | 1 | 0xC0 Constant | RO |
| 0x000C  | 0x000F | 4 | Reserved | RO |
| 0x0010  | 0xAFFF | 45039 | General Ram  | RW |
| 0xB000  | 0xBFFF | 4095 | IO Bus | RW |
| 0xC000  | 0xFFFF | 16383 | General ROM  | RO |


## Memory Paging

Segment register: 8-bit (MSB is flag register for protected segment or not)

Page Address: 7-bit Segment, 4 MSB of Address


Physical Ram:
20 bits of physical ram
19 RAM
1  ROM

Banks: RAM 0, RAM 1 + I/O + ROM

Address:
0000 00000000 00000000
MSB 0 - RAM 0
MSB 10 - RAM 1
MSB 110 - I/O
MSB 111 - ROM

Address

0000 0000 1SEGMENT ADDR

### Physical Memory

| Address | End Address | Size (bytes) | Unit (name)   |
|---------|-------------|--------------|---------------|
| 0x00000 | 0x007FF     | 2047         | Reserved (OS) |
| 0x00800 | 0x00FFF     | 2047         | Page Table    |
| 0x01000 | 0xBFFFF     | 782335       | General RAM   |
| 0xC0000 | 0xDFFFF     | 131071       | I/O           |
| 0xE0000 | 0xFFFFF     | 131071       | ROM           |


### Paging Decoding

pageoffsetaddress = 0x800 | Segment[6...0] << 4 | Address[15..12]

pageoffset = memory_lookup(pageoffsetaddress)

physicaladdress = pageoffset << 12 | Address[11..0]


