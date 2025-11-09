import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/app_bar_widget.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class StudentStatsScreen extends StatefulWidget {
  const StudentStatsScreen({super.key});

  @override
  State<StudentStatsScreen> createState() => _StudentStatsScreenState();
}

class _StudentStatsScreenState extends State<StudentStatsScreen> {
  UserModel? _currentUser;
  int _totalQuizzesTaken = 0; // unique quizzes (by quizId) across all quarters
  bool _loading = true;
  double _accuracyPct = 0.0; // passing rate based on best score per quiz
  int _totalCorrect = 0; // sum of correct answers from first attempt per quiz
  int _totalWrong = 0; // sum of wrong answers from first attempt per quiz
  Timer? _quoteTimer;
  List<String> _quotes = const [];
  int _quoteIndex = 0;
  String _currentQuote = '-';

  // Badge levels (mirror of dashboard logic)
  final List<Map<String, int>> _badgeLevels = const [
    {'minXp': 50, 'maxXp': 100}, // Rookie range handled below for <50
    {'minXp': 101, 'maxXp': 250}, // Learner
    {'minXp': 251, 'maxXp': 400}, // Explorer
    {'minXp': 401, 'maxXp': 550}, // Challenger
    {'minXp': 551, 'maxXp': 700}, // Solver
    {'minXp': 701, 'maxXp': 850}, // Master
    {'minXp': 851, 'maxXp': 1000}, // Legend
    {'minXp': 1001, 'maxXp': 1300}, // Math Wizard cap
  ];

  String _getCurrentBadge(int totalXp) {
    // Names aligned to dashboard order
    final names = [
      'Rookie',
      'Learner',
      'Explorer',
      'Challenger',
      'Solver',
      'Master',
      'Legend',
      'Math Wizard',
    ];

    // <50 is Rookie
    if (totalXp < 50) return 'Rookie';

    for (var i = 0; i < _badgeLevels.length; i++) {
      final lvl = _badgeLevels[i];
      final minXp = lvl['minXp']!;
      final maxXp = lvl['maxXp']!;
      if (totalXp >= minXp && totalXp <= maxXp) {
        return names[i];
      }
    }
    return 'Legend';
  }

  String _getBadgeImagePath(String badgeName) {
    final filename = badgeName.replaceAll(' ', '_');
    return 'assets/images/badges/$filename.png';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = DatabaseService.getCurrentUser();
    _currentUser = user;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Load aggregate stats for totals and first-attempt quiz count
    final agg = await DatabaseService.getAggregateQuizStatsForCurrentUser();
    _totalCorrect = agg['totalCorrect'] as int? ?? 0;
    _totalWrong = agg['totalWrong'] as int? ?? 0;
    final List<String> firstAttempted = List<String>.from(
      agg['firstAttemptedQuizIds'] as List,
    );
    _totalQuizzesTaken = firstAttempted.length;

    // For accuracy, compute from attempts using best score per quiz
    final attemptsBox = Hive.box('quizAttempts');
    final attempts = attemptsBox.values
        .where((a) => a['userId'] == user.id)
        .toList();

    // Compute passing rate using best score per quiz (pass threshold: 70)
    final Map<String, int> bestScoreByQuiz = {};
    for (final a in attempts) {
      final qid = a['quizId'] as String;
      final score = a['score'] as int;
      if (!bestScoreByQuiz.containsKey(qid) || score > bestScoreByQuiz[qid]!) {
        bestScoreByQuiz[qid] = score;
      }
    }
    int passed = 0;
    bestScoreByQuiz.forEach((_, score) {
      if (score >= 70) passed++;
    });
    _accuracyPct = bestScoreByQuiz.isEmpty
        ? 0.0
        : (passed / bestScoreByQuiz.length) * 100.0;

    // Correct/Wrong totals already loaded from aggregate stats

    // Prepare motivational quotes list based on accuracy bracket and start rotator
    // Only show quotes if student has taken at least one quiz
    if (_totalQuizzesTaken > 0) {
      _quotes = _buildQuotesForAccuracy(_accuracyPct);
      _quoteIndex = 0;
      _currentQuote = _quotes.isNotEmpty ? _quotes.first : '-';
      _quoteTimer?.cancel();
      if (_quotes.isNotEmpty) {
        _quoteTimer = Timer.periodic(const Duration(seconds: 10), (_) {
          if (!mounted) return;
          setState(() {
            _quoteIndex = (_quoteIndex + 1) % _quotes.length;
            _currentQuote = _quotes[_quoteIndex];
          });
        });
      }
    } else {
      // No quizzes taken yet, don't show quotes
      _quotes = [];
      _currentQuote = '-';
      _quoteTimer?.cancel();
    }

    setState(() {
      _loading = false;
    });
  }

  List<String> _buildQuotesForAccuracy(double acc) {
    if (acc >= 90) {
      return const [
        "You’re unstoppable! Keep challenging yourself.",
        "Mathematics bows to your brilliance.",
        "Perfect performance! Keep it up, Math Master!",
      ];
    } else if (acc >= 80) {
      return const [
        "Almost there! A little more effort and you’ll shine brighter.",
        "Great work! Consistency is your secret weapon.",
        "You’re mastering math one quiz at a time.",
      ];
    } else if (acc >= 60) {
      // Good / Satisfactory (60–79)
      return const [
        "Practice makes progress — you’re getting better!",
        "Keep going! Every mistake is a step toward success.",
        "You’re improving — stay focused and determined.",
      ];
    } else {
      // Needs Improvement / Poor (below 60)
      return const [
        "Don’t give up! Mistakes are proof that you’re trying.",
        "Every expert was once a beginner.",
        "Review, retry, and rise again — you can do it!",
        "Math is hard, but so are you!",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: const MathQuestAppBar(showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final xpValue = _currentUser?.xp ?? 0;
    final badgeValue = _getCurrentBadge(xpValue);
    final double acc = _accuracyPct;
    String remarks;
    if (acc >= 90) {
      remarks = 'Excellent';
    } else if (acc >= 80) {
      remarks = 'Very Good';
    } else if (acc >= 70) {
      remarks = 'Good';
    } else if (acc >= 50) {
      remarks = 'Needs Improvement';
    } else {
      remarks = 'Poor';
    }

    return Scaffold(
      appBar: const MathQuestAppBar(showBackButton: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100]!, Colors.grey[50]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EDD0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.bar_chart, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        'PERFORMANCE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Grid of statistic cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                    children: [
                      _StatTile(title: 'REMARKS', value: remarks),
                      _StatTile(
                        title: 'TOTAL QUIZ TAKEN:',
                        value: '$_totalQuizzesTaken',
                      ),
                      _StatTile(
                        title: 'CORRECT ANSWERS',
                        value: '$_totalCorrect',
                      ),
                      _StatTile(title: 'WRONG ANSWERS', value: '$_totalWrong'),
                      _StatTile(
                        title: 'ACCURACY',
                        value: '${_accuracyPct.toStringAsFixed(0)}%',
                      ),
                      _StatTile(
                        title: 'MOTIVATIONAL QUOTE',
                        value: _currentQuote,
                      ),
                      _StatTile(title: 'EXP', value: '$xpValue'),
                      _BadgeTile(
                        title: 'BADGE',
                        value: badgeValue,
                        imagePath: _getBadgeImagePath(badgeValue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({required this.title, this.value = '-'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDD0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final String title;
  final String value;
  final String imagePath;
  const _BadgeTile({
    required this.title,
    required this.value,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDD0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.stars, color: Colors.black38);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
