import 'package:flutter/material.dart';
import 'package:what_is_my_work/game/game.dart';
import 'package:what_is_my_work/game/models.dart';

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

  int get correctCount {
    int count = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (userAnswers[i] == quiz.questions[i].correctOptionIndex) {
        count++;
      }
    }
    return count;
  }

  // Tüm soruların doğru olması gerekiyor
  bool get isPassed => correctCount == quiz.questions.length;

  @override
  Widget build(BuildContext context) {
    final percentage = (correctCount / quiz.questions.length * 100).round();

    return Container(
      color: Colors.black.withOpacity(0.95),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPassed ? Icons.check_circle : Icons.cancel,
                  size: 120,
                  color: isPassed ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  isPassed ? 'Tebrikler!' : 'Başarısız',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$correctCount / ${quiz.questions.length} Doğru (%$percentage)',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 8),
                if (!isPassed)
                  const Text(
                    'Bir sonraki kademeye geçmek için tüm soruları doğru cevaplamalısın!',
                    style: TextStyle(fontSize: 14, color: Colors.orange),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 32),
                Card(
                  color: const Color(0xFF2D2D44),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        for (int i = 0; i < quiz.questions.length; i++) ...[
                          _buildQuestionResult(i),
                          if (i < quiz.questions.length - 1)
                            const Divider(color: Colors.white24, height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      game.overlays.remove('QuizResult');
                      game.clearQuizCache(); // Cache'i temizle
                      
                      if (isPassed) {
                        // Quiz başarılı (tüm sorular doğru) - bir sonraki kademeye geç
                        game.failedQuestionsQuiz.clear();
                        game.advanceToNextStage();
                      } else {
                        // Quiz başarısız - yanlış cevaplanan soruları bul ve o görevleri tekrar yap
                        List<Question> failedQuestions = [];
                        for (int i = 0; i < quiz.questions.length; i++) {
                          if (userAnswers[i] != quiz.questions[i].correctOptionIndex) {
                            failedQuestions.add(quiz.questions[i]);
                          }
                        }
                        
                        // Yanlış soruların görevlerini incomplete yap
                        game.markFailedQuestionTasksAsIncomplete(failedQuestions);
                        
                        // Başarısız soruları kaydet (tekrar quiz'de sorulacak)
                        game.failedQuestionsQuiz.clear();
                        game.failedQuestionsQuiz.addAll(failedQuestions);
                        
                        // GameStatus'a dön
                        game.overlays.add('GameStatus');
                      }
                    },
                    icon: Icon(isPassed ? Icons.arrow_forward : Icons.refresh),
                    label: Text(
                      isPassed ? 'Devam Et' : 'Görevleri Tekrar Yap',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isPassed ? Colors.green.shade600 : Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionResult(int index) {
    final question = quiz.questions[index];
    final userAnswer = userAnswers[index];
    final isCorrect = userAnswer == question.correctOptionIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                question.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (userAnswer != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Text(
                  isCorrect ? 'Cevabınız: ' : 'Yanlış Cevap: ',
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    question.options[userAnswer],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        if (!isCorrect) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Row(
              children: [
                const Text(
                  'Doğru Cevap: ',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    question.options[question.correctOptionIndex],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
