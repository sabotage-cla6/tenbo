import 'package:flutter/material.dart';

import '../../../../lobby/presentation/pages/match_lobby_page.dart';

// MatchLobbyPage のインポート（プロジェクトの配置パスに合わせて調整してください）

// プレイヤー結果のデータモデル
class PlayerResult {
  final int rank;
  final String name;
  final int rawScore;
  double finalScore;
  final String ptSubtext;

  PlayerResult({
    required this.rank,
    required this.name,
    required this.rawScore,
    required this.finalScore,
    required this.ptSubtext,
  });
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // --- カラーパレット ---
  static const Color bgColor = Color(0xFF09170E);
  static const Color headerBg = Color(0xFA0C1C12);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color minusRed = Color(0xFFFF7675);

  // サンプルデータ
  final List<PlayerResult> _results = [
    PlayerResult(
      rank: 1,
      name: 'プレイヤー1 (親)',
      rawScore: 41500,
      finalScore: 51.5,
      ptSubtext: 'ウマ +20',
    ),
    PlayerResult(
      rank: 2,
      name: '自分',
      rawScore: 28000,
      finalScore: 3.0,
      ptSubtext: 'ウマ +10',
    ),
    PlayerResult(
      rank: 3,
      name: 'プレイヤー3',
      rawScore: 21000,
      finalScore: -14.0,
      ptSubtext: 'ウマ -10 / 焼き鳥 -10',
    ),
    PlayerResult(
      rank: 4,
      name: 'プレイヤー4',
      rawScore: 9500,
      finalScore: -50.5,
      ptSubtext: 'ウマ -20 / 飛び -10',
    ),
  ];

  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // 各プレイヤーのポイント初期値でコントローラーを初期化
    _controllers = _results.map((item) {
      final text = item.finalScore > 0 ? '+${item.finalScore}' : '${item.finalScore}';
      return TextEditingController(text: text);
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 数字をカンマ区切りにするフォーマット
  String _formatScore(int score) {
    final str = score.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }
    return result.toString();
  }

  // ロビー画面へ遷移する共通処理
  void _goToLobby() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MatchLobbyPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                // App Header
                _buildHeader(),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // セクションタイトル
                        Row(
                          children: const [
                            Text('🏆', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 6),
                            Text(
                              '最終成績・精算結果',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: accentGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // 順位結果リスト
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _results.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _buildRankingCard(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Actions
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ヘッダー ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
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
                    '点',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            '対局終了・精算',
            style: TextStyle(
              fontSize: 12,
              color: accentGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- 順位カード ---
  Widget _buildRankingCard(int index) {
    final item = _results[index];
    final bool isRank1 = item.rank == 1;
    final controller = _controllers[index];
    final isMinus = controller.text.trim().startsWith('-');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        gradient: isRank1
            ? LinearGradient(
                colors: [
                  accentGold.withValues(alpha: 0.15),
                  cardBg,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRank1 ? accentGold : cardBorder,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左側: 順位・プレイヤー情報
          Row(
            children: [
              // 順位バッジ
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isRank1 ? accentGold : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${item.rank}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: isRank1 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // プレイヤー名・持ち点
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '持ち点: ${_formatScore(item.rawScore)}点',
                    style: const TextStyle(
                      fontSize: 11,
                      color: textMuted,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 右側: ポイント調整入力フィールド・内訳テキスト
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 85,
                height: 32,
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: isMinus ? minusRed : accentGoldLight,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    fillColor: const Color(0xFF08140C),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: accentGold),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {}); // マイナス判定などのスタイル更新用
                  },
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.ptSubtext,
                style: const TextStyle(
                  fontSize: 10,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- フッターアクション ---
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: headerBg,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // 二次ボタン (保存する)
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('戦績を保存しました')),
                );
                _goToLobby();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '保存する',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 一次ボタン (ロビーに戻る)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [accentGold, Color(0xFFD35400)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accentGold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _goToLobby();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ロビーに戻る',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}