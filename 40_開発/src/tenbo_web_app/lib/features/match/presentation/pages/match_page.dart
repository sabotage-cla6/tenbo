import 'package:flutter/material.dart';

// 各ページのインポート（プロジェクトの配置パスに合わせて調整してください）
import 'score_input_page.dart';
import 'result_page.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  // --- カラーパレット ---
  static const Color bgColor = Color(0xFF09170E);
  static const Color headerBg = Color(0xFA0C1C12);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color dealerColor = Color(0xFFE67E22);

  // --- 対局 State ---
  int _roundNum = 1; // 1: 東1局, 2: 東2局...
  int _honba = 0; // 本場数
  int _kyotaku = 1000; // 供託点

  // 支払入力モードフラグ
  bool _isPaymentInputMode = false;

  // 各プレイヤーの支払入力用コントローラー
  final Map<String, TextEditingController> _paymentControllers = {
    'east': TextEditingController(),
    'south': TextEditingController(),
    'west': TextEditingController(),
    'north': TextEditingController(),
  };

  // 各プレイヤーの持ち点 (初期値)
  final Map<String, int> _scores = {
    'east': 31500, // 上家 (親)
    'south': 23000, // 自分
    'west': 24000, // 下家
    'north': 21500, // 対面
  };

  // 立直フラグ
  final Map<String, bool> _riichiState = {
    'east': true,
    'south': false,
    'west': false,
    'north': false,
  };

  // 焼き鳥フラグ (true: 焼き鳥あり, false: 解除済み)
  final Map<String, bool> _yakitoriState = {
    'east': true,
    'south': true,
    'west': true,
    'north': false,
  };

  // 配給原点に対する点数差分の計算用（初期持ち点25,000想定）
  static const int _startScore = 25000;

  @override
  void dispose() {
    for (var controller in _paymentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // リーチ切り替え処理
  void _toggleRiichi(String playerKey) {
    setState(() {
      final isRiichi = _riichiState[playerKey] ?? false;
      if (isRiichi) {
        _riichiState[playerKey] = false;
        _scores[playerKey] = (_scores[playerKey] ?? 0) + 1000;
        _kyotaku -= 1000;
      } else {
        _riichiState[playerKey] = true;
        _scores[playerKey] = (_scores[playerKey] ?? 0) - 1000;
        _kyotaku += 1000;
      }
    });
  }

  // 数字をカンマ区切りにするフォーマット
  String _formatScore(int score) {
    final str = score.abs().toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }
    return score < 0 ? '-$result' : result.toString();
  }

  // --- ダイアログ・画面遷移表示ロジック群 ---

  // 1. リーチボタン押下時
  void _onRiichiButtonPressed() {
    _toggleRiichi('south');
  }

  // 2. 和了画面へ遷移 (ScoreInputPage)
  void _openAgariModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScoreInputPage(),
      ),
    );
  }

  // 3. 精算画面へ遷移 (ResultPage)
  void _openResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultPage(),
      ),
    );
  }

  // 4. 支払入力 / 支払確定ボタン押下時
  void _onPaymentButtonPressed() {
    setState(() {
      if (_isPaymentInputMode) {
        // 確定処理
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('支払金額を確定しました'),
            backgroundColor: accentGreen,
          ),
        );
        // 入力値をクリアしてモードを解除
        for (var controller in _paymentControllers.values) {
          controller.clear();
        }
        _isPaymentInputMode = false;
      } else {
        // 支払入力モードを開始
        _isPaymentInputMode = true;
      }
    });
  }

  // 5. 流局モーダル
  void _openRyukyokuModal() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildDialogFrame(
          title: '🔄 流局精算',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('テンパイしている人を選択:', style: TextStyle(fontSize: 12, color: textMuted)),
              SizedBox(height: 6),
              CheckboxListTile(
                title: Text('上家 (東家・親)', style: TextStyle(color: Colors.white, fontSize: 13)),
                value: true,
                onChanged: null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: Text('自分 (南家)', style: TextStyle(color: Colors.white, fontSize: 13)),
                value: true,
                onChanged: null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: Text('下家 (西家)', style: TextStyle(color: Colors.white, fontSize: 13)),
                value: false,
                onChanged: null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: Text('対面 (北家)', style: TextStyle(color: Colors.white, fontSize: 13)),
                value: false,
                onChanged: null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          onConfirm: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('流局精算を適用しました'), backgroundColor: accentGreen),
            );
          },
        );
      },
    );
  }

  // 6. 次局へモーダル
  void _openNextRoundModal() {
    String advanceType = 'next';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildDialogFrame(
              title: '⏩ 局の進行（次局へ）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('局の移動パターン:', style: TextStyle(fontSize: 12, color: textMuted)),
                  const SizedBox(height: 4),
                  _buildDropdown<String>(
                    value: advanceType,
                    items: const [
                      DropdownMenuItem(
                        value: 'next',
                        child: Text('親移動（次の局へ / 本場クリア）'),
                      ),
                      DropdownMenuItem(
                        value: 'renchan',
                        child: Text('親連荘（同一局のまま / +1本場）'),
                      ),
                      DropdownMenuItem(
                        value: 'ryukyoku_renchan',
                        child: Text('流局連荘（同一局のまま / +1本場）'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => advanceType = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '※立直棒のクリアや次局へのセットを自動適用します。',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                ],
              ),
              onConfirm: () {
                setState(() {
                  if (advanceType == 'next') {
                    _roundNum += 1;
                    _honba = 0;
                  } else {
                    _honba += 1;
                  }
                  // 全員のリーチ状態を解除
                  _riichiState.updateAll((key, value) => false);
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  // モーダル共通フレーム
  Widget _buildDialogFrame({
    required String title,
    required Widget child,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      backgroundColor: const Color(0xFF102619),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: accentGold, width: 1.5),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: accentGold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: textMuted, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('キャンセル', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('確定', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF08140C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: const Color(0xFF102619),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: items,
          onChanged: onChanged,
        ),
      ),
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

                // Smartphone Main Frame
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Table Canvas (Square 1:1)
                        _buildTableCanvas(),
                        const SizedBox(height: 12),

                        // Action Control Dock
                        _buildControlDock(),
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
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13),
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

          // Header Info Badges
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Text(
                  '東$_roundNum局 $_honba本場',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: textMuted),
                    children: [
                      TextSpan(text: '配点: '),
                      TextSpan(
                        text: '25,000',
                        style: TextStyle(color: accentGold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 卓設定ボタン
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('卓設定を開きます')),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Center(
                child: Text('⚙️', style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 麻雀卓キャンバス (3x3 グリッド) ---
  Widget _buildTableCanvas() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [Color(0xFF174028), Color(0xFF0A2114)],
            center: Alignment.center,
            radius: 0.8,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF23140C), width: 6),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Row 1: [ 空白, 北(対面), 空白 ]
            Expanded(
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '北',
                      name: '対面',
                      scoreKey: 'north',
                      isDealer: false,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Row 2: [ 東(上家/親), 中央ボード, 西(下家) ]
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '東',
                      name: '上家 (親)',
                      scoreKey: 'east',
                      isDealer: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: _buildCenterBoard()),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '西',
                      name: '下家',
                      scoreKey: 'west',
                      isDealer: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Row 3: [ 空白, 南(自家/自分), 空白 ]
            Expanded(
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '南',
                      name: '自分 (自家)',
                      scoreKey: 'south',
                      isDealer: false,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // プレイヤーカード表現
  Widget _buildPlayerCard({
    required String wind,
    required String name,
    required String scoreKey,
    required bool isDealer,
  }) {
    final score = _scores[scoreKey] ?? 0;
    final diff = score - _startScore;
    final isRiichi = _riichiState[scoreKey] ?? false;
    final hasYakitori = _yakitoriState[scoreKey] ?? false;

    // ボーダー色決定
    Color borderColor = cardBorder;
    if (isRiichi) {
      borderColor = accentRed;
    } else if (isDealer) {
      borderColor = dealerColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (isRiichi)
            BoxShadow(color: accentRed.withValues(alpha: 0.5), blurRadius: 10)
          else if (isDealer)
            BoxShadow(color: dealerColor.withValues(alpha: 0.4), blurRadius: 10)
          else
            const BoxShadow(color: Colors.black26, blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Row: 風バッジ + プレイヤー名
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isDealer ? dealerColor : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    wind,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Score
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formatScore(score),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: Colors.white,
              ),
            ),
          ),

          // 支払入力モード時の入力フィールド表示
          if (_isPaymentInputMode) ...[
            const SizedBox(height: 2),
            SizedBox(
              height: 24,
              child: TextField(
                controller: _paymentControllers[scoreKey],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '点数',
                  hintStyle: const TextStyle(color: textMuted, fontSize: 10),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  fillColor: const Color(0xFF08140C),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: accentGold, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: accentGoldLight, width: 1.5),
                  ),
                ),
              ),
            ),
          ] else ...[
            // 通常時の差分表示
            Text(
              diff >= 0 ? '+${_formatScore(diff)}' : _formatScore(diff),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: diff >= 0 ? accentGreen : const Color(0xFFFF7675),
              ),
            ),

            // Status Badges (立直・焼き鳥)
            SizedBox(
              height: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isRiichi) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE74C3C), Color(0xFFC0392B)]),
                        border: Border.all(color: const Color(0xFFFF7675)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '⚡ 立直',
                        style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 2),
                  ],
                  if (hasYakitori) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFD35400), Color(0xFFC0392B)]),
                        border: Border.all(color: accentGold),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('🍢', style: TextStyle(fontSize: 7)),
                          SizedBox(width: 1),
                          Text(
                            '焼き鳥',
                            style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 中央ボード表現
  Widget _buildCenterBoard() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xEB0A1810),
        border: Border.all(color: accentGold, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: accentGold.withValues(alpha: 0.25), blurRadius: 12),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '東 $_roundNum 局',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_honba 本場',
              style: const TextStyle(fontSize: 10, color: accentGoldLight, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 立直棒アイコン表現
                Container(
                  width: 16,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: accentRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(':', style: TextStyle(color: textMuted, fontSize: 10)),
                const SizedBox(width: 2),
                Text(
                  _formatScore(_kyotaku),
                  style: const TextStyle(color: accentGold, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 操作用コントロール・ドック ---
  Widget _buildControlDock() {
    return Column(
      children: [
        // 上段ボタン 3つ
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: '⚡ リーチ',
                subtext: '1,000点供託',
                gradient: const LinearGradient(colors: [Color(0xFFF39C12), Color(0xFFD35400)]),
                onTap: _onRiichiButtonPressed,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: '🀄 和了',
                subtext: '和了点請求',
                gradient: const LinearGradient(colors: [Color(0xFFE74C3C), Color(0xFFC0392B)]),
                onTap: _openAgariModal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: _isPaymentInputMode ? '💸 支払確定' : '💸 支払入力',
                subtext: _isPaymentInputMode ? 'タップで確定' : '各人の点数を入力',
                gradient: _isPaymentInputMode
                    ? const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF1E8449)])
                    : const LinearGradient(colors: [Color(0xFF2980B9), Color(0xFF1F618D)]),
                onTap: _onPaymentButtonPressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 下段ボタン 3つ
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: '🔄 流局',
                subtext: 'ノーテン罰符',
                gradient: const LinearGradient(colors: [Color(0xFF34495E), Color(0xFF2C3E50)]),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                onTap: _openRyukyokuModal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: '⏩ 次局へ',
                subtext: '局・親更新',
                gradient: const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF1E8449)]),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                onTap: _openNextRoundModal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: '🏁 精算',
                subtext: '対局終了',
                gradient: const LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF732D91)]),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                onTap: _openResultPage,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String subtext,
    required Gradient gradient,
    Border? border,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: border,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtext,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.85),
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