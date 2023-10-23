import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.startQuiz});

  final void Function() startQuiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/quiz-logo.png',
          width: 200,
          opacity: const AlwaysStoppedAnimation(0.7),
        ),
        const SizedBox(height: 40),
        const Text(
          'Learn Flutter the fun way!',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: startQuiz,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color.fromARGB(210, 255, 255, 255),
            textStyle: const TextStyle(fontSize: 14),
          ),
          icon: const Icon(Icons.arrow_circle_right_rounded),
          label: const Text(
            'Start quiz',
          ),
        ),
      ],
    );
  }
}
