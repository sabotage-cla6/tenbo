import 'package:flutter/material.dart';

class PlayersHomeScreen extends StatelessWidget {
  const PlayersHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09170E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildActiveMatchBanner(context),
                        const SizedBox(height: 16),
                        _buildActionGrid(context),
                        const SizedBox(height: 24),
                        _buildSectionTitle('📊 通算戦績', '詳細データ ›'),
                        const SizedBox(height: 8),
                        _buildStatsCard(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('🕒 最近の対局履歴', 'すべて見る ›'),
                        const SizedBox(height: 8),
                        _buildHistoryList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xF00C1C12),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
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
                    colors: [Color(0xFFF39C12), Color(0xFFF1C40F)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '点',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'tenbo',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF39C12),
                  ),
                  child: const Center(
                    child: Text(
                      '山',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'ヤマダ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Active Match Banner ---
  Widget _buildActiveMatchBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x40E67E22), Color(0x26D35400)],
        ),
        border: Border.all(color: const Color(0xFFF39C12), width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔴 対局進行中: 金曜夜セット麻雀',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Text(
                '東 2 局 1本場 (自持ち: 23,000点)',
                style: TextStyle(color: Color(0xFFF1C40F), fontSize: 10),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF39C12),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text(
              '復帰 ›',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // --- Action Cards ---
  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/game_create');
            },
            borderRadius: BorderRadius.circular(16),
            child: _buildActionCard(
              '🀄',
              '卓を作成',
              'ルールを設定して新しく部屋を作る',
              const Color(0xFFF39C12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            '🔍',
            '卓に参加',
            '卓名を入力して進行中の部屋に入る',
            const Color(0xFF3498DB),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String icon, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xE614301F),
        border: Border.all(color: const Color(0xFF2C5E3D)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(color: Color(0xFF8E9E94), fontSize: 10),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // --- Stats & History Helpers ---
  Widget _buildSectionTitle(String title, String link) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E9E94),
            fontSize: 13,
          ),
        ),
        Text(
          link,
          style: const TextStyle(color: Color(0xFFF1C40F), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xE614301F),
        border: Border.all(color: const Color(0xFF2C5E3D)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('対局数', '24 回'),
          _buildStatItem('トップ率', '33.3%'),
          _buildStatItem('スコア', '+142.5', isPlus: true),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isPlus = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8E9E94), fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: isPlus ? const Color(0xFF2ECC71) : Colors.white,
            fontSize: 18,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    final history = [
      {
        'title': '金曜夜セット麻雀 (#3)',
        'meta': '2026/08/01 ・ 四人有段',
        'rank': '1 位',
        'score': '+48.2',
        'plus': true,
      },
      {
        'title': '週末麻雀部',
        'meta': '2026/07/26 ・ 四人有段',
        'rank': '3 位',
        'score': '-18.5',
        'plus': false,
      },
      {
        'title': '水曜リーグ戦',
        'meta': '2026/07/22 ・ 三人麻雀',
        'rank': '1 位',
        'score': '+35.0',
        'plus': true,
      },
    ];
    return Column(
      children: history
          .map(
            (h) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xD90A1810),
                border: Border.all(color: const Color(0xFF2C5E3D)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        h['meta'] as String,
                        style: const TextStyle(
                          color: Color(0xFF8E9E94),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          h['rank'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        h['score'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: (h['plus'] as bool)
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFFE74C3C),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
