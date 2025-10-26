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

class _QuizOverlayState extends State<QuizOverlay> with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int? selectedOption;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    widget.game.userAnswers.clear();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectOption(int option) {
    setState(() {
      selectedOption = option;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _nextQuestion(option);
    });
  }

  void _nextQuestion(int selectedOption) {
    widget.game.userAnswers[currentQuestionIndex] = selectedOption;
    
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        this.selectedOption = null;
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      widget.game.overlays.remove('Quiz');
      widget.game.overlays.add('QuizResult');
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestionIndex];
    final screenSize = MediaQuery.of(context).size;
    
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900.withValues(alpha: 0.95),
              Colors.purple.shade900.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _animationController,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.9,
                  maxHeight: screenSize.height * 0.85,
                ),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1E1E2E),
                          Color(0xFF2D2D44),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Quiz icon and progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade400,
                                      Colors.pink.shade400,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withValues(alpha: 0.5),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.quiz,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade700,
                                      Colors.cyan.shade700,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Soru ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (currentQuestionIndex + 1) / widget.quiz.questions.length,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              color: Colors.cyan,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Question text
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.cyan.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              question.text,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Options
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                children: question.options.asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  String text = entry.value;
                                  final isSelected = selectedOption == idx;
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [
                                                  Colors.green.shade600,
                                                  Colors.teal.shade600,
                                                ],
                                              )
                                            : null,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Colors.green.withValues(alpha: 0.6),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: selectedOption == null
                                              ? () => _selectOption(idx)
                                              : null,
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.white.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.white.withValues(alpha: 0.8)
                                                    : Colors.white.withValues(alpha: 0.3),
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.white.withValues(alpha: 0.2),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      String.fromCharCode(65 + idx), // A, B, C, D
                                                      style: TextStyle(
                                                        color: isSelected
                                                            ? Colors.green.shade700
                                                            : Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Text(
                                                    text,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
    final isPerfect = score == 100;

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
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPerfect
                ? [
                    Colors.green.shade900.withValues(alpha: 0.95),
                    Colors.teal.shade900.withValues(alpha: 0.95),
                  ]
                : [
                    Colors.red.shade900.withValues(alpha: 0.95),
                    Colors.orange.shade900.withValues(alpha: 0.95),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPerfect
                          ? [
                              const Color(0xFF1B5E20),
                              const Color(0xFF2E7D32),
                            ]
                          : [
                              const Color(0xFF4E342E),
                              const Color(0xFF5D4037),
                            ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Result icon
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: isPerfect
                                        ? [Colors.green.shade400, Colors.teal.shade400]
                                        : [Colors.orange.shade600, Colors.red.shade600],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isPerfect ? Colors.green : Colors.orange)
                                          .withValues(alpha: 0.6),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isPerfect ? Icons.emoji_events : Icons.refresh,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        
                        // Title
                        Text(
                          isPerfect ? 'Mükemmel!' : 'Tekrar Dene',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Score display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${score.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Stats
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.check_circle,
                                'Doğru',
                                correctAnswers.toString(),
                                Colors.green,
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              _buildStatItem(
                                Icons.cancel,
                                'Yanlış',
                                failedQuestions.length.toString(),
                                Colors.red,
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              _buildStatItem(
                                Icons.quiz,
                                'Toplam',
                                quiz.questions.length.toString(),
                                Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Message
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPerfect
                                ? '🎉 Harika bir performans! Bir sonraki seviyeye geçebilirsin.'
                                : '💪 Başarısız olduğun görevleri tekrar yaparak kendini geliştirebilirsin.',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isPerfect
                                ? () {
                                    game.failedQuestionsQuiz.clear();
                                    game.overlays.remove('QuizResult');
                                    game.advanceToNextStage();
                                  }
                                : () {
                                    game.overlays.remove('QuizResult');
                                    game.findAndSetNextIncompleteTask();
                                  },
                            icon: Icon(
                              isPerfect ? Icons.arrow_forward : Icons.replay,
                              size: 28,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                isPerfect ? 'Devam Et' : 'Görevleri Tekrar Yap',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPerfect
                                  ? Colors.green.shade600
                                  : Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              elevation: 10,
                              shadowColor: (isPerfect ? Colors.green : Colors.orange)
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
