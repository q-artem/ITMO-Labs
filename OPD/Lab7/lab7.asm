ORG 0x0F
WORD 0x006D

ORG 0x0
START:
LD #0x2B
word 0x900F ; наша команда
HLT


ma E0
mw 0201C09811
mw 80C4101040
mdecodeall

