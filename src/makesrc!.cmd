@echo off
SET DELPHI_PATH=F:\Program files\Borland\Delphi7
echo.
echo Preparing Radius Building
echo.
echo * (1) Delete previous Radius build
if exist ..\RELEASE\argus.exe del ..\RELEASE\argus.exe
if exist e:\mail\radius\radius.exe del e:\mail\radius\radius.exe
if exist e:\mail\radius\taurus.exe del e:\mail\radius\taurus.exe
echo * (2) Make new Radius build
copy X:\Radius\taurus\src\VerInfo.rc X:\Radius\taurus\src\VerInfo.rc.2
IncVer.exe X:\Radius\taurus\src\VerInfo.rc
GoRC.exe X:\Radius\taurus\src\VerInfo.rc
E:\Mail\Radius\reshack\ResHacker.exe -addoverwrite X:\Radius\taurus\src\Taurus.res, X:\Radius\taurus\src\Taurus.res, X:\Radius\taurus\src\VerInfo.RES, VERSIONINFO,,
"%DELPHI_PATH%\bin\dcc32" -DNT -B Taurus >..\out\res.txt
if errorlevel 1 goto error
echo * (3) Delete previous packed Radius build
if exist ..\RELEASE\radius.exe del ..\RELEASE\radius.exe
if exist ..\RELEASE\taurus.exe del ..\RELEASE\taurus.exe
echo * (4) Packing new build...
rem ..\RELEASE\upx ..\RELEASE\argus.exe -o..\RELEASE\radius.exe
copy ..\RELEASE\argus.exe ..\RELEASE\radius.exe > nul
copy ..\RELEASE\radius.exe e:\mail\radius\radius.exe
copy ..\RELEASE\taurus.exe e:\mail\radius\taurus.exe
echo * (5) Delete temp files.
if exist ..\release\argus.map del ..\release\argus.map
if exist ..\release\taurus.map del ..\release\taurus.map
del ..\out\res.txt
goto exit
:error
echo * (3) Error occured. Exiting...
type ..\out\res.txt
echo * (3) Error occured. Exiting...
del /q X:\Radius\taurus\src\VerInfo.rc 2>nul
ren X:\Radius\taurus\src\VerInfo.rc.2 X:\Radius\taurus\src\VerInfo.rc
pause
:exit
exit