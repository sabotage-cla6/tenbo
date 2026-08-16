import 'package:flutter/material.dart';
import 'package:tenbo/features/game_session/presentation/views/game/point_payment.dart';
import 'package:tenbo/features/game_session/presentation/views/game/point_request.dart';

void main() {
  runApp(const TenboApp());
}

class AppColors {
  static const Color bgColor = Color(0xFF09170E);
  static const Color tableBgStart = Color(0xFF174028);
  static const Color tableBgEnd = Color(0xFF0A2114);
  static const Color cardBg = Color(0xE614301F); // rgba(20, 48, 31, 0.9)
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentBlue = Color(0xFF3498DB);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color textMain = Color(0xFFF0F4F1);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color dealerColor = Color(0xFFE67E22);
}

class TenboApp extends StatelessWidget {
  const TenboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tenbo - 対局（卓）画面',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgColor,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.textMain,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      home: const TenboScreen(),
    );
  }
}

class TenboScreen extends StatefulWidget {
  const TenboScreen({super.key});

  @override
  State<TenboScreen> createState() => _TenboScreenState();
}

class _TenboScreenState extends State<TenboScreen> {
  // Mock State equivalent to the JS in HTML
  Map<String, int> scores = {
    'east': 31500,
    'south': 23000,
    'west': 24000,
    'north': 21500,
  };

  int kyotaku = 1000;
  int currentRoundNum = 1;
  int currentHonba = 0;

  Map<String, bool> riichiState = {
    'east': true,
    'south': false,
    'west': false,
    'north': false,
  };

  void toggleRiichi(String playerKey) {
    setState(() {
      riichiState[playerKey] = !riichiState[playerKey]!;
      if (riichiState[playerKey]!) {
        scores[playerKey] = scores[playerKey]! - 1000;
        kyotaku += 1000;
      } else {
        scores[playerKey] = scores[playerKey]! + 1000;
        kyotaku -= 1000;
      }
    });
  }

  void _showPointRequestModal() {
    showDialog(
      context: context,
      builder: (context) => const PointRequestScreen(),
    );
  }

  void _showPointPaymentModal() {
    showDialog(
      context: context,
      builder: (context) => const PointPaymentScreen(),
    );
  }

  void _showDummyModal(String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF102619),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.accentGold, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.accentGold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'この機能はモックアップです。',
          style: TextStyle(color: AppColors.textMain),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              '閉じる',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFA0C1C12), // rgba(12, 28, 18, 0.98)
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGold, AppColors.accentGoldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '点',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, AppColors.accentGoldLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'tenbo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // Header Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Text(
                  '東$currentRoundNum局 $currentHonba本場',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 10),
                const Text('配点: ', style: TextStyle(fontSize: 12)),
                const Text(
                  '25,000',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Settings Icon
          InkWell(
            onTap: () => _showDummyModal('⚙️ 卓設定'),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white10,
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text('⚙️', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String wind,
    required String name,
    required String key,
    required String diff,
    bool isPlus = false,
    bool isDealer = false,
    bool hasYakitori = false,
  }) {
    bool isRiichi = riichiState[key] ?? false;
    int score = scores[key] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRiichi
              ? AppColors.accentRed
              : (isDealer
                    ? AppColors.dealerColor
                    : (key == 'south' ? Colors.white38 : AppColors.cardBorder)),
          width: 1.5,
        ),
        boxShadow: [
          if (isRiichi)
            BoxShadow(
              color: AppColors.accentRed.withValues(alpha: 0.5),
              blurRadius: 10,
            )
          else if (isDealer)
            BoxShadow(
              color: AppColors.dealerColor.withValues(alpha: 0.4),
              blurRadius: 10,
            )
          else
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Row (Wind + Name)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDealer ? AppColors.dealerColor : Colors.white12,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  wind,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Score
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              score.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                fontFamily: 'Courier',
                color: Colors.white,
              ),
            ),
          ),

          // Score Diff
          Text(
            diff,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isPlus ? AppColors.accentGreen : const Color(0xFFFF7675),
            ),
          ),

          // Bottom Status
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRiichi) _buildRiichiBadge(),
              if (isRiichi && hasYakitori) const SizedBox(width: 4),
              if (hasYakitori) _buildYakitoriBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiichiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentRed, Color(0xFFC0392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFF7675)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: const Text(
        '⚡ 立直',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildYakitoriBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD35400), Color(0xFFC0392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.accentGold),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: const Row(
        children: [
          Text('🍢', style: TextStyle(fontSize: 9)),
          SizedBox(width: 2),
          Text(
            '焼き鳥',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterBoard() {
    return Container(
      margin: const EdgeInsets.all(2), // Padding adjustment for grid cell
      decoration: BoxDecoration(
        color: const Color(0xEB0A1810),
        border: Border.all(color: AppColors.accentGold, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.25),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '東 $currentRoundNum 局',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$currentHonba 本場',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.accentGoldLight,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Riichi Stick Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Text(
                  ':',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
                const SizedBox(width: 4),
                Text(
                  kyotaku.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},',
                  ),
                  style: const TextStyle(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtext,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: borderColor != null
                  ? Border.all(color: borderColor)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtext,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Table Grid Container
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                colors: [
                                  AppColors.tableBgStart,
                                  AppColors.tableBgEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF23140C),
                                width: 6,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 24,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Top Row
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        child: _buildPlayerCard(
                                          wind: '北',
                                          name: '対面',
                                          key: 'north',
                                          diff: '-3,500',
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Middle Row
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildPlayerCard(
                                          wind: '東',
                                          name: '上家 (親)',
                                          key: 'east',
                                          diff: '+6,500',
                                          isPlus: true,
                                          isDealer: true,
                                          hasYakitori: true,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: _buildCenterBoard()),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildPlayerCard(
                                          wind: '西',
                                          name: '下家',
                                          key: 'west',
                                          diff: '-1,000',
                                          hasYakitori: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Bottom Row
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        child: _buildPlayerCard(
                                          wind: '南',
                                          name: '自分 (自家)',
                                          key: 'south',
                                          diff: '-2,000',
                                          hasYakitori: true,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Control Dock
                        Column(
                          children: [
                            // Top Row Buttons
                            Row(
                              children: [
                                _buildActionButton(
                                  title: '⚡ リーチ',
                                  subtext: '1,000点供託',
                                  gradientColors: const [
                                    AppColors.accentGold,
                                    Color(0xFFD35400),
                                  ],
                                  onTap: () => toggleRiichi('south'),
                                ),
                                _buildActionButton(
                                  title: '🀄 和了',
                                  subtext: 'ロン / ツモ 点数入力',
                                  gradientColors: const [
                                    AppColors.accentRed,
                                    Color(0xFFC0392B),
                                  ],
                                  onTap: _showPointRequestModal,
                                ),
                                _buildActionButton(
                                  title: '💸 移動',
                                  subtext: '点棒移動',
                                  gradientColors: const [
                                    AppColors.accentBlue,
                                    Color(0xFF1F618D),
                                  ],
                                  onTap: _showPointPaymentModal,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Bottom Row Buttons
                            Row(
                              children: [
                                _buildActionButton(
                                  title: '🔄 流局',
                                  subtext: '聴牌精算',
                                  gradientColors: const [
                                    Color(0xFF34495E),
                                    Color(0xFF2C3E50),
                                  ],
                                  borderColor: Colors.white10,
                                  onTap: () => _showDummyModal('🔄 流局精算'),
                                ),
                                _buildActionButton(
                                  title: '⏩ 次局へ',
                                  subtext: '局・親更新',
                                  gradientColors: const [
                                    AppColors.accentGreen,
                                    Color(0xFF1E8449),
                                  ],
                                  borderColor: Colors.white24,
                                  onTap: () => _showDummyModal('⏩ 局の進行（次局へ）'),
                                ),
                                _buildActionButton(
                                  title: '🏁 精算',
                                  subtext: '対局終了',
                                  gradientColors: const [
                                    Color(0xFF8E44AD),
                                    Color(0xFF732D91),
                                  ],
                                  borderColor: Colors.white24,
                                  onTap: () => _showDummyModal('🏁 精算'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
}
