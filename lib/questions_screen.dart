import 'package:first_app/data/questions.dart';
import 'package:first_app/models/quiz_questions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  backgroundColor: Colors.purple.shade800,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(100),
  ),
);

class QuestionsScreen extends StatefulWidget {
  final void Function(String answer) onSelectAnswer;

  const QuestionsScreen({super.key, required this.onSelectAnswer});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int index = 0;

  void answerQuestion(String answer) {
    widget.onSelectAnswer(answer);
    setState(() {
      index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion = questions[index];

    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            currentQuestion.text,
            style: GoogleFonts.lato(
              color: const Color.fromARGB(183, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          ...currentQuestion.getShuffledAnswers().map(
                (answer) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    onPressed: () {
                      answerQuestion(answer);
                    },
                    style: buttonStyle,
                    child: Text(
                      answer,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
