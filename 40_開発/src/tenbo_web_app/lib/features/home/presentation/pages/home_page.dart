import 'package:flutter/material.dart';

import '../../../../lobby/presentation/pages/rule_setting_page.dart';

// RuleSettingPage のインポート（プロジェクトの配置パスに合わせて調整してください）

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'ヤマダ');
  String _currentUserName = 'ヤマダ';

  // カラーパレットの定義
  static const Color bgColor = Color(0xFF09170E);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color inputBg = Color(0xFF08140C);

  void _updatePlayerName() {
    final newName = _usernameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('プレイヤー名を入力してください。'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _currentUserName = newName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('プレイヤー名を変更しました！'),
        backgroundColor: accentGreen,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFA0C1C12),
            border: Border(
              bottom: BorderSide(color: Colors.white10, width: 1.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [accentGold, accentGoldLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            '🀄',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, accentGoldLight],
                        ).createShader(bounds),
                        child: const Text(
                          'tenbo',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 9,
                          backgroundColor: accentGold,
                          child: Text(
                            _currentUserName.isNotEmpty
                                ? _currentUserName[0]
                                : '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _currentUserName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildActiveMatchBanner(),
                  const SizedBox(height: 16),
                  _buildActionCardsGrid(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('👤 プレイヤー設定'),
                  const SizedBox(height: 6),
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                    '📊 通算戦績',
                    actionLabel: '詳細データ ›',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 6),
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                    '🕒 最近の対局履歴',
                    actionLabel: 'すべて見る ›',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 6),
                  _buildHistoryList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveMatchBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE67E22).withValues(alpha: 0.25),
            const Color(0xFFD35400).withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentGold, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '⚡ 対局進行中: 金曜夜セット龍鳳',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '東 2 局 1本場 (手持ち: 23,000点)',
                  style: TextStyle(
                    fontSize: 10,
                    color: accentGoldLight,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accentGold,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '復帰 ›',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCardsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: '🀄',
            iconBg: const Color(0x26F39C12),
            iconBorder: const Color(0x4DF39C12),
            title: '卓を作成',
            desc: 'ルールを設定して新しい部屋を作る',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RuleSettingPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: '🔑',
            iconBg: const Color(0x263498DB),
            iconBorder: const Color(0x4D3498DB),
            title: '卓に参加',
            desc: '卓名を入力して進行中の部屋に入る',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String icon,
    required Color iconBg,
    required Color iconBorder,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: iconBorder),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(fontSize: 10, color: textMuted, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {String? actionLabel, VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textMuted,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 11,
                color: accentGoldLight,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _usernameController,
                maxLength: 12,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'プレイヤー名を入力',
                  hintStyle:
                      const TextStyle(color: Color(0xFF4A5D52), fontSize: 13),
                  filled: true,
                  fillColor: inputBg,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: cardBorder, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: accentGold, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [accentGold, accentGoldLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: _updatePlayerName,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text(
                '保存',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('対局数', '24 回'),
          _buildStatItem('トップ率', '33.3%'),
          _buildStatItem('トータルスコア', '+142.5', isPlus: true),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isPlus = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: isPlus ? accentGreen : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        _buildHistoryItem(
          title: '金曜夜セット龍鳳 (#3)',
          meta: '2026/08/01 ・ 四人有段',
          rank: '1 位',
          isFirstRank: true,
          score: '+48.2',
          isPlus: true,
        ),
        const SizedBox(height: 8),
        _buildHistoryItem(
          title: '週末龍鳳部',
          meta: '2026/07/26 ・ 四人有段',
          rank: '3 位',
          isFirstRank: false,
          score: '-18.5',
          isPlus: false,
        ),
        const SizedBox(height: 8),
        _buildHistoryItem(
          title: '水曜リーグ戦',
          meta: '2026/07/22 ・ 三人龍鳳',
          rank: '1 位',
          isFirstRank: true,
          score: '+35.0',
          isPlus: true,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String meta,
    required String rank,
    required bool isFirstRank,
    required String score,
    required bool isPlus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xD90A1810),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meta,
                style: const TextStyle(fontSize: 10, color: textMuted),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isFirstRank
                      ? const Color(0x33F39C12)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: isFirstRank
                      ? Border.all(color: const Color(0x66F39C12))
                      : null,
                ),
                child: Text(
                  rank,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isFirstRank ? accentGold : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                score,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: isPlus ? accentGreen : accentRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}