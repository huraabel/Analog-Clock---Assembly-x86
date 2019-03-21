@echo off
set cale=%~dp0..\masm_minimal\
set file=%1
shift

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

if NOT exist "%file%.asm" (
    call :ColorText 0c "Nu gasesc fisierul %file%.asm!"
    echo.
    echo Exemplu de folosire: build_masm.bat file
    echo va asambla file.asm in file.obj si apoi va linkedita file.obj in file.dll
    exit /B 1
)

del "%file%.obj" "%file%.exp" "%file%.lib" "%file%.dll" >nul 2>nul


call "%cale%ml.exe" "%file%.asm" /link /dll /def:"%file%.def" /OUT:"%file%.dll" "%cale%msvcrt.lib"

if NOT "%ERRORLEVEL%" == "0" (
    call :ColorText 0c "Error building %file%"
    echo.
    exit /B 1
)

del "%file%.obj" "%file%.exp" "%file%.lib" >nul 2>nul
del "mllink$.lnk" >nul 2>nul
echo.
call :ColorText 0a "Operation succeeded"
echo.

goto :eof
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof