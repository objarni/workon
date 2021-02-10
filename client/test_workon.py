import unittest
import workon


class TestWorkon(unittest.TestCase):
    def test_creating_new_file(self):
        variants = ["y", "Y", "Yes", "yes"]
        for variant in variants:
            expected = [
                workon.Print("Did not find '~/rescue.txt'."),
                workon.Print("Do you want to create it? [y/N]"),
                workon.CreateFile(
                    "~/rescue.txt",
                    [
                        "[workon]",
                        "cmdline=subl ~/path-to-rescue",
                        "server=212.47.253.51:5333",
                        "username=olof",
                        "projname=rescue",
                    ],
                ),
                workon.Print("'~/rescue.txt' created, open it in"),
                workon.Print("in you favorite editor to configure,"),
                workon.Print("then type workon rescue once again!"),
            ]

            def fake_reader(path):
                return None

            def fake_input():
                return variant

            got = workon.parse(
                ["rescue"], read_config=fake_reader, get_user_input=fake_input
            )
            self.assertEqual(expected, got)

    def test_answering_no_when_prompted_to_create_file(self):
        for variant in ["", "n", "N"]:
            expected = [
                workon.Print("Did not find '~/rescue.txt'."),
                workon.Print("Do you want to create it? [y/N]"),
                workon.Print("OK."),
            ]

            def fake_reader(path):
                return None

            def fake_input():
                return variant

            got = workon.parse(
                ["rescue"], read_config=fake_reader, get_user_input=fake_input
            )
            self.assertEqual(expected, got)


if __name__ == "__main__":
    unittest.main()
