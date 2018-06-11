echo update > e:\fido\rd\exit.now
:still_active
sleep(100)
if exist e:\fido\rd\active.* goto still_active
