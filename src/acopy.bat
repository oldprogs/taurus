g:
cd g:\kin\pas\radius\src
echo update > e:\fido\rd\exit.now
:still_active
sleep 10
if exist e:\fido\rd\active.* goto still_active
del e:\fido\rd\exit.now
:copy
sleep 10
copy /y Taurus.exe e:\fido\RD\Taurus.exe
if errorlevel 1 goto copy
del e:\fido\!!\gin\Taurus.*
del e:\fido\!!\sin\Taurus.*
rem upx -9 e:\fido\RD\Taurus.exe
:start_again
sleep 10
Start e:\fido\RD\Taurus
if not exist e:\fido\rd\active.* goto start_again 
start winrar a tau-alpha Taurus.exe