import 'package:first_app/data/questions.dart';
import 'package:first_app/results_screen/questions_summary.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ResultsScreen extends StatelessWidget {
  final void Function() resetQuiz;
  final List<String> selectedAnswers;

  const ResultsScreen(this.resetQuiz, this.selectedAnswers, {super.key});

  @override
  Widget build(BuildContext context) {
    int correctCount = selectedAnswers.foldIndexed(
      0,
      (index, value, element) =>
          element == questions[index].answers[0] ? value + 1 : value,
    );

    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You answered $correctCount out of ${selectedAnswers.length} questions correctly!',
            style: const TextStyle(
              color: Color.fromARGB(195, 255, 255, 255),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: QuestionsSummary(selectedAnswers: selectedAnswers),
          ),
          TextButton.icon(
            onPressed: resetQuiz,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Restart quiz!',
            ),
          ),
        ],
      ),
    );
  }
}
