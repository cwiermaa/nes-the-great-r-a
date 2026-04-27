@echo off
pause
"../wla-6502.exe" -o main.asm main.o
"../wlalink.exe" -v link.txt level1.nes
pause