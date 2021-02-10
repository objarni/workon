import subprocess
import sys


def Print(msg):
    return ("Print", msg)


def CreateFile(path, lines):
    return ("CreateFile", lines)


def parse(args, read_config, get_user_input):
    effect = [
        Print("Did not find '~/rescue.txt'."),
        Print("Do you want to create it? [y/N]"),
    ]
    if "y" in get_user_input().lower():
        effect.extend(
            [
                CreateFile(
                    "~/rescue.txt",
                    [
                        "[workon]",
                        "cmdline=subl ~/path-to-rescue",
                        "server=212.47.253.51:5333",
                        "username=olof",
                        "projname=rescue",
                    ],
                ),
                Print("'~/rescue.txt' created, open it in"),
                Print("in you favorite editor to configure,"),
                Print("then type workon rescue once again!"),
            ]
        )
    else:
        effect.extend([Print("OK.")])
    return effect


def main(cmd_line):
    editor_process = subprocess.Popen(cmd_line)
    while True:
        try:
            editor_process.wait(1)
            break
        except subprocess.TimeoutExpired:
            print("timeout")
    print("Samuel <3")


if __name__ == "__main__":
    main(sys.argv[1:])
"""
    workon rescue

.. skulle jag vilja kunna skriva i en terminal. Då ska följande ske:

1- Skriver ut status för övriga friends i terminalen
2- Sätter min "status" till att jag jobbar på rescue till mina samkodningsvänner (förmodligen en heartbeat loop som även
 uppdaterar om andras status ändras)
3- CD:ar till rätt path och startar upp rätt editor med rätt projekt som open:as
   (dvs utför det cmd jag konfat)

Jag var på väg att stryka (3) från MVP, men då försvinner värdet:
det ska vara "normalt flow vid start av samkodning" och därför
behöver vanan att först starta sin editor brytas. Det ska liksom
vara *samma sak* att börja samkoda som att starta sin editor/terminal.

Det vore såklart ännu bättre om det inte var terminal, utan ett litet
minimalt och diskret tray-UI, men nu är det MVP vi pratar om ....

Du och Tor skulle vara de första jag lägger till i min friend-list!

"""
