@echo off
SET DELPHI_PATH=F:\Program files\Borland\Delphi7

"%DELPHI_PATH%\bin\brcc32" eng.rc -foeng.res
"%DELPHI_PATH%\bin\brcc32" -c1251 rus.rc -forus.res
rem brcc32 -c1252 ger.rc -foger.res
rem brcc32 -c1252 dan.rc -fodan.res
exit