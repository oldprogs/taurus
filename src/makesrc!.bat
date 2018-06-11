@echo off
SET DELPHI_PATH=d:\Program files\Borland\Delphi7
echo.
echo Preparing Radius Building
echo.
echo * (1) Delete previous Radius build
if exist ..\RELEASE\argus.exe del ..\RELEASE\argus.exe
if exist e:\fido\radius\radius.exe del e:\fido\radius\radius.exe
echo * (2) Make new Radius build
"%DELPHI_PATH%\bin\dcc32" -DNT argus >..\out\res.txt
if errorlevel 1 goto error
echo * (3) Delete previous packed Radius build
if exist ..\RELEASE\radius.exe del ..\RELEASE\radius.exe
echo * (4) Packing new build...
rem ..\RELEASE\upx ..\RELEASE\argus.exe -o..\RELEASE\radius.exe
copy ..\RELEASE\argus.exe ..\RELEASE\radius.exe > nul
copy ..\RELEASE\radius.exe e:\fido\radius\radius.exe
echo * (5) Delete temp files.
if exist ..\release\argus.map del ..\release\argus.map
del ..\out\res.txt
goto exit
:error
echo * (3) Error occured. Exiting...
pause
:exit
exit