# workon

Samkoda (Social coding experiment) MVP


## Bakgrund

Jag och min samkodningskompis har diskuterat att man ibland får lust att bygga på sitt projekt, men inte "orkar" dela i What'sApp, Slack, Discord eller var man nu kommunicerar.

Istället skulle vi vilja att man kan se varandras status "någonstans" när man börjar bygga. D.v.s varken stör den andre / ger skuld, eller behöver ta steget att fråga "vill du bygga nu?". Lite som hur Steam funkar med friends och "PlayerName is playing GameName" fast för programmering/samkodning!


### Installera och köra
### Hur kör man servern?


### Hur kör man klienten?

   1. Installera Python 3.6+
   2. Ladda ned "workon.py"
   3. I en terminal, skriv sedan:

    python3 workon.py <projektnamn>

Följ sedan instruktionerna!


### Hur bygger man en .bat fil som startar ens editor och en PowerShell i projektets .venv?

1. Ändra på cmdline= raden i mittprojekt.ini till hela sökvägen till editorn, inklusive "" runtom 
2. Bygg en mittprojekt.bat fil som du ändrar efter behov:

    start powershell.exe -noexit -file "mittprojekt\venv\Scripts\Activate.ps1"
    python workon.py mittprojekt


### Hur kör man klienttesterna?


    cd client
    python3 test_client.py
