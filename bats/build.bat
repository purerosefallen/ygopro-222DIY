@echo off
set irrklang_pro=1
premake5 vs2015
msbuild build\ygo.sln /m /property:Configuration=Release
del /f ygopro.exe
move bin\release\ygopro.exe .
pause