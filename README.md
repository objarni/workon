# workon

"Samkoda" - Social coding experiment


## Background

Me and my samkoda friend have been discussing that sometimes you get the urge to build on your project, but do not have the energy to share on WhatsApp, Slack, Discord IRC or wherever you communicate with coding buddies.

Instead, we would like to see each others statuses 'somewhere' when you start coding; similar to how the Friends view in Steam works for games! This has some consequences:

1) It will not disturb/interrupt anyone
2) There is no energy loss having to type 'do you want to code some with me now?'


### Install and run client

   1. Make sure you have Python 3.6+ available
   2. Download "client/workon.py"
   3. In a terminal, write:

    python3 workon.py <projectname>

Then follow instructions!


### Below untranslated How-to for Windows .bat file


### Hur bygger man en .bat fil som startar ens editor och en PowerShell i projektets .venv?

1. Ändra på `cmdline=` raden i `mittprojekt.ini` till hela sökvägen till editorn. Viktigt: `"..."` runtom!
2. Bygg en `mittprojekt.bat` fil som pekar ut `Activate.ps1` och kör workon

```
start powershell.exe -noexit -file "mittprojekt\venv\Scripts\Activate.ps1"
python workon.py mittprojekt
```

Exempel på struktur på hårddisken:

  * `C:\projekt\MittProjekt\`
     * Här ligger projektets filer
  * `C:\projekt\MittProjekt\venv`
     * Virtuell environment för projektet
  *  `C:\projekt\workon.py`
     * workon ligger "ovanför"
  * `C:\projekt\mittprojekt.ini`
     * workon-cfg-script
  * `C:\projekt\mittprojekt.bat`
     * startscript



### Hur kör man klienttesterna?

    cd client
    python3 test_client.py


### Hur kör man servern?

TBD
