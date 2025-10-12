import 'package:flutter/material.dart';
import 'package:what_is_my_work/game/game.dart';
import 'package:what_is_my_work/game/models.dart';

class QuizOverlay extends StatefulWidget {
  final WhatIsMyWorkGame game;
  final Quiz quiz;

  const QuizOverlay({super.key, required this.game, required this.quiz});

  @override
  State<QuizOverlay> createState() => _QuizOverlayState();
}

class _QuizOverlayState extends State<QuizOverlay> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.game.userAnswers.clear();
  }

  void _nextQuestion(int selectedOption) {
    setState(() {
      widget.game.userAnswers[currentQuestionIndex] = selectedOption;
      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        widget.game.overlays.remove('Quiz');
        widget.game.overlays.add('QuizResult');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestionIndex];
    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Card(
          color: const Color(0xFF242424),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Soru ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ...question.options.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String text = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _nextQuestion(idx),
                      child: Text(text),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizResultOverlay extends StatelessWidget {
  final WhatIsMyWorkGame game;
  final Quiz quiz;
  final Map<int, int> userAnswers;

  const QuizResultOverlay({
    super.key,
    required this.game,
    required this.quiz,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int correctAnswers = 0;
    List<Question> failedQuestions = [];

    for (int i = 0; i < quiz.questions.length; i++) {
      if (userAnswers[i] == quiz.questions[i].correctOptionIndex) {
        correctAnswers++;
      } else {
        failedQuestions.add(quiz.questions[i]);
      }
    }

    final score = (correctAnswers / quiz.questions.length) * 100;

    if (score < 100) {
      game.failedQuestionsQuiz = failedQuestions;
      for (var question in failedQuestions) {
        for (var level in game.levels) {
          for (var stage in level.stages) {
            for (var task in stage.tasks) {
              if (task.name == question.relatedTaskName) {
                task.isCompleted = false;
              }
            }
          }
        }
      }
    }

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Card(
          color: const Color(0xFF242424),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Test Sonucu: ${score.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                if (score == 100)
                  ElevatedButton(
                    onPressed: () {
                      game.failedQuestionsQuiz.clear();
                      game.overlays.remove('QuizResult');
                      game.advanceToNextStage();
                    },
                    child: const Text('Harika! Devam Et'),
                  )
                else
                  Column(
                    children: [
                      const Text(
                        'Başarısız oldun. İlgili görevleri tekrar yapmalısın.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          game.overlays.remove('QuizResult');
                          game.findAndSetNextIncompleteTask();
                        },
                        child: const Text('İlgili Görevleri Tekrar Yap'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
