@echo off
brcc32 eng.rc -foeng.res
brcc32 -c1251 rus.rc -forus.res
rem brcc32 -c1252 ger.rc -foger.res
rem brcc32 -c1252 dan.rc -fodan.res
exit