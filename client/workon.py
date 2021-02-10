import configparser
import subprocess
import sys
from pathlib import Path


def Print(msg):
    return ("Print", msg)


def CreateFile(path, lines):
    return ("CreateFile", (path, lines))


def StartProcess(cmd_line):
    return ("StartProcess", cmd_line)


def parse(args, read_config):

    if len(args) == 0:
        return [Print("Usage: python3 workon.py <projname>")]

    if "--create" in args:
        args.remove("--create")
        if len(args) == 0:
            return [Print("Create what? --create by itself makes no sense...")]

        projname = args[0]
        inifile = f"{projname}.ini"
        if read_config(projname):
            return [Print(f"Cannot create {inifile}: file already exists!")]

        return [
            CreateFile(
                inifile,
                [
                    f"[workon]",
                    f"cmdline=subl .",
                    f"server=212.47.253.51:5333",
                    f"username=olof",
                ],
            ),
            Print(f"'{inifile}' created."),
            Print(f"Open it with your favorite text editor then type"),
            Print(f"   python3 workon.py {projname}"),
            Print(f"again to begin samkoding!"),
        ]

    else:
        projname = args[0]
        inifile = f"{projname}.ini"
        cfg = read_config(inifile)
        if not cfg:
            return [
                Print(
                    f"Did not find '{inifile}'. Re-run with flag --create to create a default!"
                )
            ]
        else:
            cmdline = cfg["cmdline"]
            return [
                Print(f"Working on {projname}. Command line: {cmdline}"),
                StartProcess(cmdline.split()),
            ]


def run_cmd_line(cmd_line):
    process = subprocess.Popen(cmd_line)
    while True:
        try:
            process.wait(1)
            break
        except subprocess.TimeoutExpired:
            print("timeout")


def read_config(path):
    config = configparser.ConfigParser()
    config.read(path)
    return config["workon"]


if __name__ == "__main__":
    effects = parse(args=sys.argv[1:], read_config=read_config)
    for effect in effects:
        name, args = effect
        if name == "Print":
            print(args)
        if name == "CreateFile":
            path, lines = args
            Path(path).write_text("\n".join(lines))
        if name == "StartProcess":
            run_cmd_line(args)
