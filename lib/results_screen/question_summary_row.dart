import 'package:first_app/data/questions.dart';
import 'package:flutter/material.dart';

class QuestionSummaryRow extends StatelessWidget {
  final bool isCorrect;
  final String givenAnswer;
  final int questionNumber;

  const QuestionSummaryRow({
    super.key,
    required this.isCorrect,
    required this.givenAnswer,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            maxRadius: 15,
            backgroundColor: isCorrect
                ? const Color.fromARGB(224, 175, 255, 178)
                : const Color.fromARGB(255, 239, 115, 156),
            child: Text(
              (questionNumber + 1).toString(),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questions[questionNumber].text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Visibility(
                  visible: !isCorrect,
                  child: Text(
                    givenAnswer,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Color.fromARGB(
                        255,
                        239,
                        115,
                        156,
                      ),
                    ),
                  ),
                ),
                Text(
                  questions[questionNumber].answers[0],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
