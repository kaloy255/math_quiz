import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/theme_helper.dart';
import '../widgets/mathie_speech_bubble.dart';
import '../widgets/app_logo.dart';

class BadgeListScreen extends StatefulWidget {
  const BadgeListScreen({super.key});

  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  final List<Map<String, dynamic>> _badgeLevels = [
    {'name': 'Rookie', 'minXp': 50, 'maxXp': 100},
    {'name': 'Learner', 'minXp': 101, 'maxXp': 250},
    {'name': 'Explorer', 'minXp': 251, 'maxXp': 400},
    {'name': 'Challenger', 'minXp': 401, 'maxXp': 550},
    {'name': 'Solver', 'minXp': 551, 'maxXp': 700},
    {'name': 'Master', 'minXp': 701, 'maxXp': 850},
    {'name': 'Legend', 'minXp': 851, 'maxXp': 1000},
    {'name': 'Math Wizard', 'minXp': 1001, 'maxXp': 1300},
  ];

  String _getCurrentBadge(int totalXp) {
    for (var badge in _badgeLevels) {
      if (totalXp >= badge['minXp'] && totalXp <= badge['maxXp']) {
        return badge['name'];
      }
    }
    // If XP is less than 50, return Rookie
    if (totalXp < 50) return 'Rookie';
    // If XP exceeds max, return the highest badge
    return _badgeLevels.last['name'];
  }

  bool _isBadgeUnlocked(int totalXp, Map<String, dynamic> badge) {
    return totalXp >= badge['minXp'];
  }

  double _getProgressForBadge(int totalXp, Map<String, dynamic> badge) {
    if (!_isBadgeUnlocked(totalXp, badge)) return 0.0;

    final rangeSize = badge['maxXp'] - badge['minXp'] + 1;
    final progressInRange = (totalXp - badge['minXp']).clamp(0, rangeSize);
    return progressInRange / rangeSize;
  }

  int _getXpInBadgeRange(int totalXp, Map<String, dynamic> badge) {
    if (totalXp < badge['minXp']) return 0;
    if (totalXp > badge['maxXp']) return badge['maxXp'];
    return totalXp;
  }

  String _getBadgeImagePath(String badgeName) {
    final filename = badgeName.replaceAll(' ', '_');
    return 'assets/images/badges/$filename.png';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = DatabaseService.getCurrentUser();
    final totalXp = currentUser?.xp ?? 0;
    final currentBadge = _getCurrentBadge(totalXp);
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.getTextColor(context);
    final secondaryText = ThemeHelper.getSecondaryTextColor(context);
    final primaryGreen = ThemeHelper.getPrimaryGreen(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final elevatedColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: ThemeHelper.getHeaderGradient(context),
                  boxShadow: ThemeHelper.getElevation(context, 6),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          AppLogo(
                            backgroundColor: elevatedColor,
                            withGlow: isDark,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'MathQuest',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: elevatedColor.withOpacity(isDark ? 0.7 : 0.3),
                        shape: BoxShape.circle,
                        boxShadow: ThemeHelper.getElevation(context, 4),
                      ),
                      child: Icon(Icons.person, color: textColor, size: 24),
                    ),
                  ],
                ),
              ),

              // Current Status Cards (Static at top)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // XP Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          boxShadow: ThemeHelper.getElevation(context, 3),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                color: ThemeHelper.getInvertedTextColor(
                                  context,
                                ),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'XP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$totalXp',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Badge Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          boxShadow: ThemeHelper.getElevation(context, 3),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: elevatedColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: borderColor),
                              ),
                              child: Image.asset(
                                _getBadgeImagePath(currentBadge),
                                width: 32,
                                height: 32,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.stars,
                                    color: primaryGreen,
                                    size: 28,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Badge',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentBadge,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Badge List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _badgeLevels.length,
                        itemBuilder: (context, index) {
                          final badge = _badgeLevels[index];
                          final isCurrentBadge = currentBadge == badge['name'];
                          final isUnlocked = _isBadgeUnlocked(totalXp, badge);
                          final progress = _getProgressForBadge(totalXp, badge);
                          final xpInRange = _getXpInBadgeRange(totalXp, badge);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrentBadge
                                    ? primaryGreen
                                    : borderColor,
                                width: 2,
                              ),
                              boxShadow: [
                                ...ThemeHelper.getElevation(context, 2),
                                if (isDark && isCurrentBadge)
                                  ...ThemeHelper.getGlow(
                                    context,
                                    color: primaryGreen,
                                    blur: 10,
                                  ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // XP Range
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        '${badge['minXp']} - ${badge['maxXp']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isUnlocked
                                              ? textColor
                                              : secondaryText,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Vertical Divider
                                    Container(
                                      width: 1,
                                      height: 60,
                                      color: borderColor,
                                    ),
                                    const SizedBox(width: 16),
                                    // Badge Name
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            _getBadgeImagePath(badge['name']),
                                            width: 24,
                                            height: 24,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.stars,
                                                    color: isUnlocked
                                                        ? ThemeHelper.getTextColor(
                                                            context,
                                                          )
                                                        : ThemeHelper.getSecondaryTextColor(
                                                            context,
                                                          ),
                                                    size: 24,
                                                  );
                                                },
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            badge['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isUnlocked
                                                  ? textColor
                                                  : secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Progress Bar (only for current badge)
                                if (isCurrentBadge) ...[
                                  const SizedBox(height: 12),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          backgroundColor: isDark
                                              ? elevatedColor.withOpacity(0.4)
                                              : Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                primaryGreen,
                                              ),
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$xpInRange / ${badge['maxXp']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 120), // Space for Mathie below
                    ],
                  ),
                ),
              ),

              // Speech Bubble with Mathie Character (Fixed at bottom)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0, // Reduced top padding to lower Mathie
                  bottom: 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom
                  children: [
                    // Chat Bubble (Left side)
                    Expanded(
                      flex: 1,
                      child: MathieSpeechBubble(
                        text: 'EARN XP TO\nUNLOCK NEW BADGE',
                        rotation: -0.30,
                        offset: const Offset(55, -20),
                        tailDirection: TailDirection.bottomRight,
                        lightOverrides: const BubbleTuningOverrides(
                          width: 340,
                          height: 230,
                          paddingX: 22,
                          paddingY: 24,
                          fontSize: 13,
                          textRotationAdjust: -0.12,
                          textOffsetX: -6,
                          textOffsetY: -4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Mathie Character (Right side)
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          'assets/images/mathie/badge_mathie.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6BBF59),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.celebration,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: ThemeHelper.getHeaderGradient(context),
                  boxShadow: ThemeHelper.getElevation(context, 6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.home, color: secondaryText, size: 32),
                          const SizedBox(height: 4),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, color: textColor, size: 32),
                        const SizedBox(height: 4),
                        Text(
                          'Users',
                          style: TextStyle(color: textColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
