format PE console

entry start
include 'win32a.inc'

section '.data' data readable writable

        msg1 db "Test %d",0dh,0ah,0

        entr db 'Enter %s ',0
        _1st db 'A:',0
        res db 'result: %d',0
        itpt db ' %d',0
        nthn db '%d',0
        point db ',',0
        A dd ?

section '.text' code readable executable

start:

cinvoke printf, entr,_1st
cinvoke scanf, itpt, A
cinvoke printf, entr,_3rd



invoke getch    ;waiting for any key pressed
invoke ExitProcess, 0

section '.idata' import data readable
library kernel,'kernel32.dll',\
msvcrt,'msvcrt.dll'

import kernel,\
ExitProcess,'ExitProcess'

import msvcrt,\
printf,'printf',\
scanf,'scanf',\
getch,'_getch'
