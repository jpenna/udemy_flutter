import 'package:first_app/data/questions.dart';
import 'package:first_app/results_screen/question_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuestionsSummary extends StatelessWidget {
  final List<String> selectedAnswers;

  const QuestionsSummary({super.key, required this.selectedAnswers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: selectedAnswers.mapIndexed((index, answer) {
            return QuestionSummaryRow(
              isCorrect: questions[index].answers[0] == answer,
              givenAnswer: selectedAnswers[index],
              questionNumber: index,
            );
          }).toList(),
        ),
      ),
    );
  }
}
