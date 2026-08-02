import subprocess
import tempfile
import unittest
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "DWT_Skript.typ"


class ChapterQuizParser(HTMLParser):
    def __init__(self, chapter):
        super().__init__()
        self.chapter = chapter
        self.current = None
        self.sections = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        classes = set(attrs.get("class", "").split())
        if (
            tag == "section"
            and "quiz-section" in classes
            and attrs.get("data-chapter") == self.chapter
        ):
            self.current = {
                "events": [],
                "questions": [],
                "answers": [],
                "solution_groups": 0,
                "subquestions": 0,
            }
            self.sections.append(self.current)

        if self.current is None:
            return
        if "quiz-question" in classes:
            self.current["events"].append("question")
            self.current["questions"].append(attrs.get("data-qid"))
        if "quiz-answer" in classes:
            self.current["events"].append("answer")
            self.current["answers"].append(attrs.get("data-qid"))
        if "quiz-solutions" in classes:
            self.current["solution_groups"] += 1
        if "quiz-subquestion" in classes:
            self.current["subquestions"] += 1

    def handle_endtag(self, tag):
        if tag == "section" and self.current is not None:
            self.current = None


class ExamLayoutTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with tempfile.TemporaryDirectory() as tmpdir:
            output = Path(tmpdir) / "body.html"
            subprocess.run(
                [
                    "typst",
                    "compile",
                    "--features",
                    "html",
                    "-f",
                    "html",
                    str(SOURCE),
                    str(output),
                ],
                cwd=ROOT,
                check=True,
                capture_output=True,
                text=True,
            )
            parser = ChapterQuizParser("16")
            parser.feed(output.read_text(encoding="utf-8"))
            cls.sections = parser.sections

    def test_each_exam_groups_all_solutions_after_all_questions(self):
        self.assertEqual(len(self.sections), 3)
        for section in self.sections:
            self.assertEqual(section["solution_groups"], 1)
            self.assertEqual(section["events"], ["question"] * 5 + ["answer"] * 5)

    def test_each_exam_renders_one_spaced_row_per_subquestion(self):
        self.assertEqual(
            [section["subquestions"] for section in self.sections], [17, 17, 18]
        )

    def test_exam_reordering_preserves_stable_question_ids(self):
        self.assertEqual(len(self.sections), 3)
        for block, section in enumerate(self.sections, start=1):
            expected = [f"ch16-b{block}-q{question}" for question in range(1, 6)]
            self.assertEqual(section["questions"], expected)
            self.assertEqual(section["answers"], expected)


if __name__ == "__main__":
    unittest.main()
