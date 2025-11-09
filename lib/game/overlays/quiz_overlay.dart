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
  int? selectedAnswer;

  void _submitAnswer() {
    if (selectedAnswer == null) return;
    
    widget.game.userAnswers[currentQuestionIndex] = selectedAnswer!;
    
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = widget.game.userAnswers[currentQuestionIndex];
      });
    } else {
      // Quiz tamamlandı
      widget.game.overlays.remove('Quiz');
      widget.game.overlays.add('QuizResult');
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = widget.game.userAnswers[currentQuestionIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Container(
      color: Colors.black.withOpacity(0.95),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
              ),
              const SizedBox(height: 16),
              Text(
                'Soru ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Card(
                color: const Color(0xFF2D2D44),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    question.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedAnswer == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedAnswer = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.blue.shade600
                              : const Color(0xFF1E1E2E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.white24,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Önceki'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  if (currentQuestionIndex > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: selectedAnswer != null ? _submitAnswer : null,
                      icon: Icon(
                        currentQuestionIndex < widget.quiz.questions.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                      ),
                      label: Text(
                        currentQuestionIndex < widget.quiz.questions.length - 1
                            ? 'Sonraki'
                            : 'Bitir',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        disabledBackgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
