import unittest
import workon


def config_does_not_exist_reader(path):
    return None


def config_exists_reader(path):
    return {"hejsan": 5}


class TestWorkon(unittest.TestCase):
    def test_config_not_found(self):
        for projname in ["rescue", "polarbear"]:
            expected = [
                workon.Print(
                    f"Did not find '{projname}.ini'. Re-run with flag --create to create a default!"
                ),
            ]

            cmd_line = [projname]
            got = workon.parse(cmd_line, read_config=config_does_not_exist_reader)
            self.assertEqual(expected, got)

    def test_creating_config_for_rescue(self):
        expected = [
            workon.CreateFile(
                "rescue.ini",
                [
                    "[workon]",
                    "cmdline=subl .",
                    "server=212.47.253.51:5333",
                    "username=olof",
                ],
            ),
            workon.Print("'rescue.ini' created."),
            workon.Print("Open it with your favorite text editor then type"),
            workon.Print("   python3 workon.py rescue"),
            workon.Print("again to begin samkoding!"),
        ]
        cmd_line = ["rescue", "--create"]
        got = workon.parse(cmd_line, read_config=config_does_not_exist_reader)
        self.assertEqual(expected, got)

    def test_creating_config_for_polarbear(self):
        expected = [
            workon.CreateFile(
                "polarbear.ini",
                [
                    "[workon]",
                    "cmdline=subl .",
                    "server=212.47.253.51:5333",
                    "username=olof",
                ],
            ),
            workon.Print("'polarbear.ini' created."),
            workon.Print("Open it with your favorite text editor then type"),
            workon.Print("   python3 workon.py polarbear"),
            workon.Print("again to begin samkoding!"),
        ]
        cmd_line = ["polarbear", "--create"]
        got = workon.parse(cmd_line, read_config=config_does_not_exist_reader)
        self.assertEqual(expected, got)

    def test_no_args(self):
        expected = [workon.Print("Usage: python3 workon.py <projname>")]
        cmd_line = []
        got = workon.parse(cmd_line, read_config=config_does_not_exist_reader)
        self.assertEqual(expected, got)

    def test_create_flag_when_file_exists_prints_error(self):
        expected = [workon.Print("Cannot create rescue.ini: file already exists!")]
        cmd_line = ["rescue", "--create"]
        got = workon.parse(cmd_line, read_config=config_exists_reader)
        self.assertEqual(expected, got)

    def test_create_flag_but_no_projname_is_error(self):
        expected = [workon.Print("Create what? --create by itself makes no sense...")]
        cmd_line = ["--create"]
        got = workon.parse(cmd_line, read_config=config_exists_reader)
        self.assertEqual(expected, got)

    def test_green_path(self):
        for projname in ["rescue", "polarbear"]:
            for cmdline in ["subl .", "goland"]:

                def read_rescue_ini(path):
                    return {
                        "cmdline": cmdline,
                        "server": "212.47.253.51:5333",
                        "username": "olof",
                    }

                expected = [
                    workon.Print(f"Working on {projname}. Command line: {cmdline}"),
                    workon.StartProcess(cmdline.split()),
                ]
                got = workon.parse([projname], read_config=read_rescue_ini)
                self.assertEqual(expected, got)


# test list
# #no arguments prints usage
# #file not found, --create not set
# #file not found, --create set
# #create flag set but not project name
# #create flag when file exists prints error
# green path: starts cmd.line when config exists and --create not set
# parse error messages: ini file validation?

if __name__ == "__main__":
    unittest.main()
