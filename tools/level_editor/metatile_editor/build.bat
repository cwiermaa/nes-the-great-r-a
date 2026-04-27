@echo off
pause
"../../wla-6502.exe" -o main.asm main.o
"../../wlalink" -v link.txt metatile.nes
pause