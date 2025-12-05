import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

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

  Widget _buildSummaryChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final textColor = ThemeHelper.getTextColor(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.spacing(context, 12),
        vertical: ResponsiveHelper.spacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: ThemeHelper.getElevatedColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 30),
        ),
        border: Border.all(color: ThemeHelper.getBorderColor(context)),
        boxShadow: ThemeHelper.getElevation(context, 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.iconSize(context, 16),
            color: ThemeHelper.getPrimaryGreen(context),
          ),
          SizedBox(width: ResponsiveHelper.spacing(context, 6)),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 12),
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(context, 4)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 14),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final statTiles = [
      _StatTile(title: 'REMARKS', value: remarks),
      _StatTile(title: 'TOTAL QUIZ TAKEN', value: '$_totalQuizzesTaken'),
      _StatTile(title: 'CORRECT ANSWERS', value: '$_totalCorrect'),
      _StatTile(title: 'WRONG ANSWERS', value: '$_totalWrong'),
      _StatTile(title: 'ACCURACY', value: '${acc.toStringAsFixed(0)}%'),
      _StatTile(title: 'MOTIVATIONAL QUOTE', value: _currentQuote),
      _StatTile(title: 'EXP', value: '$xpValue'),
    ];

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: const CustomAppBar(showBackButton: true, title: 'Stats'),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: ResponsiveHelper.padding(
              context,
              all: ResponsiveHelper.contentPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomCard(
                  withGlow: ThemeHelper.isDarkMode(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            color: ThemeHelper.getPrimaryGreen(context),
                            size: ResponsiveHelper.iconSize(context, 32),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.spacing(context, 12),
                          ),
                          Text(
                            'Performance',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 22),
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 12)),
                      Text(
                        'Track your quiz journey and stay motivated.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeHelper.getSecondaryTextColor(context),
                          fontSize: ResponsiveHelper.fontSize(context, 13),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(context, 20)),
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeHelper.getPrimaryGreen(context),
                            ),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: ResponsiveHelper.spacing(
                            context,
                            12,
                          ),
                          mainAxisSpacing: ResponsiveHelper.spacing(
                            context,
                            12,
                          ),
                          childAspectRatio: 0.95,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ...statTiles,
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
    final textColor = ThemeHelper.getTextColor(context);
    final secondaryColor = ThemeHelper.getSecondaryTextColor(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(color: ThemeHelper.getBorderColor(context)),
        boxShadow: ThemeHelper.getElevation(context, 3),
      ),
      child: Padding(
        padding: ResponsiveHelper.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 13),
                fontWeight: FontWeight.w700,
                color: secondaryColor,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
    final textColor = ThemeHelper.getTextColor(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(color: ThemeHelper.getBorderColor(context)),
        boxShadow: [
          ...ThemeHelper.getElevation(context, 3),
          if (ThemeHelper.isDarkMode(context))
            ...ThemeHelper.getGlow(
              context,
              color: ThemeHelper.getPrimaryGreen(context),
              blur: 6,
            ),
        ],
      ),
      child: Padding(
        padding: ResponsiveHelper.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 13),
                fontWeight: FontWeight.w700,
                color: ThemeHelper.getSecondaryTextColor(context),
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveHelper.iconSize(context, 44),
                  height: ResponsiveHelper.iconSize(context, 44),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getElevatedColor(context),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 10),
                    ),
                    border: Border.all(
                      color: ThemeHelper.getBorderColor(context),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.stars,
                        color: ThemeHelper.getPrimaryGreen(context),
                      );
                    },
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 10)),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: textColor,
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
