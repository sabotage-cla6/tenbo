import 'package:flutter/material.dart';

class ScoreInputPage extends StatefulWidget {
  const ScoreInputPage({super.key});

  @override
  State<ScoreInputPage> createState() => _ScoreInputPageState();
}

class _ScoreInputPageState extends State<ScoreInputPage> {
  // --- カラーパレット ---
  static const Color bgColor = Color(0xFF09170E);
  static const Color headerBg = Color(0xFA0C1C12);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color dealerColor = Color(0xFFE67E22);
  static const Color modalBg = Color(0xFF102619);
  static const Color inputBg = Color(0xFF08140C);

  // --- モーダル内の入力 State ---
  bool _isParent = false; // false: 子, true: 親
  bool _isRon = true; // true: ロン, false: ツモ
  int _honbaCount = 0; // 本場数
  String _selectedScore = '満貫'; // 選択された点数・役

  // 点数・役ボタンの配置データリスト
  final List<ScoreOption> _scoreOptions = const [
    ScoreOption(text: '300\n500'),
    ScoreOption(text: '500\n1,000'),
    ScoreOption(text: '1,000\n2,000'),
    ScoreOption(text: '2,000\n3,900'),
    ScoreOption(text: '400\n700'),
    ScoreOption(text: '2,600'),
    ScoreOption(text: '5,200'),
    ScoreOption(isDisabled: true),
    ScoreOption(text: '400\n800'),
    ScoreOption(text: '3,200'),
    ScoreOption(text: '6,400'),
    ScoreOption(isDisabled: true),
    ScoreOption(text: '満貫'),
    ScoreOption(text: '跳満'),
    ScoreOption(text: '倍満'),
    ScoreOption(text: '三倍満'),
    ScoreOption(text: '役満'),
    ScoreOption(text: '○倍役満'),
    ScoreOption(isDisabled: true),
    ScoreOption(isDisabled: true),
    ScoreOption(text: '2,300'),
    ScoreOption(text: '4,500'),
    ScoreOption(text: '800\n1,800'),
    ScoreOption(text: '5,800'),
    ScoreOption(text: '900\n1,800'),
    ScoreOption(text: 'その他(支払者が設定)', isWide: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Stack(
              children: [
                // Layer 1: 対局卓メイン画面
                Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTableCanvas(),
                            const SizedBox(height: 12),
                            _buildControlDock(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Layer 2: 点数入力モーダル（オーバーレイ）
                _buildModalOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- アプリヘッダー ---
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: const Text(
              '東1局 0本場',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- 対局卓キャンバス ---
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
                      score: '21,500',
                      isDealer: false,
                      hasYakitori: false,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Row 2: [ 東(親), 中央ボード, 西(下家) ]
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '東',
                      name: '親',
                      score: '31,500',
                      isDealer: true,
                      hasYakitori: false,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: _buildCenterBoard()),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '西',
                      name: '下家',
                      score: '24,000',
                      isDealer: false,
                      hasYakitori: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Row 3: [ 空白, 南(自分), 空白 ]
            Expanded(
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: _buildPlayerCard(
                      wind: '南',
                      name: '自分',
                      score: '23,000',
                      isDealer: false,
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
    );
  }

  // プレイヤーカード表現
  Widget _buildPlayerCard({
    required String wind,
    required String name,
    required String score,
    required bool isDealer,
    required bool hasYakitori,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(
          color: isDealer ? dealerColor : cardBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDealer
                      ? dealerColor
                      : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    wind,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              score,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 16,
            child: hasYakitori
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD35400), Color(0xFFC0392B)],
                      ),
                      border: Border.all(color: accentGold),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('🍢', style: TextStyle(fontSize: 8)),
                        SizedBox(width: 2),
                        Text(
                          '焼き鳥',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '東 1 局',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '0 本場',
              style: TextStyle(
                fontSize: 10,
                color: accentGoldLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // コントロール・ドック（和了ボタン）
  Widget _buildControlDock() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            children: const [
              Text(
                '🀄 和了 (上がり)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ロン / ツモ 点数入力',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- モーダルオーバーレイ ---
  Widget _buildModalOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 340,
              maxHeight: 620,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: modalBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accentGold, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // モーダルヘッダー
                  const Text(
                    '🀄 和了（上がり）点数入力',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentGold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // モーダルボディ
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. 和了者の立場 (親/子)
                          _buildSettingGroup(
                            label: '和了者の立場:',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildModalButton(
                                    label: '親 (東) 🀀',
                                    isSelected: _isParent,
                                    onTap: () =>
                                        setState(() => _isParent = true),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildModalButton(
                                    label: '子 🀁🀂🀃',
                                    isSelected: !_isParent,
                                    onTap: () =>
                                        setState(() => _isParent = false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 2. 和了方式 (ロン/ツモ)
                          _buildSettingGroup(
                            label: '和了方式:',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildModalButton(
                                    label: 'ロン',
                                    isSelected: _isRon,
                                    onTap: () => setState(() => _isRon = true),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildModalButton(
                                    label: 'ツモ',
                                    isSelected: !_isRon,
                                    onTap: () => setState(() => _isRon = false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 3. 本場 変更エリア
                          _buildSettingGroup(
                            labelWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '本場:',
                                  style: TextStyle(
                                      fontSize: 11, color: textMuted),
                                ),
                                Text(
                                  '+300点/本 (ツモ:各100点加算)',
                                  style: TextStyle(
                                      fontSize: 10, color: textMuted),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: inputBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: cardBorder),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCounterButton(
                                    label: '－',
                                    onTap: () {
                                      if (_honbaCount > 0) {
                                        setState(() => _honbaCount--);
                                      }
                                    },
                                  ),
                                  Text(
                                    '$_honbaCount 本場',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: accentGoldLight,
                                    ),
                                  ),
                                  _buildCounterButton(
                                    label: '＋',
                                    onTap: () {
                                      setState(() => _honbaCount++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 4. 点数・役の選択エリア
                          const Text(
                            '点数・役の選択:',
                            style: TextStyle(fontSize: 11, color: textMuted),
                          ),
                          const SizedBox(height: 6),
                          _buildScoreGrid(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // モーダル フッターボタン
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // キャンセル押下でモーダル（画面）を閉じる
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            foregroundColor: Colors.white,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'キャンセル',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '請求点数: $_selectedScore (${_isParent ? "親" : "子"} / ${_isRon ? "ロン" : "ツモ"} / $_honbaCount本場)',
                                ),
                                backgroundColor: const Color(0xFF2ECC71),
                              ),
                            );
                            // 点数請求押下でモーダル（画面）を閉じる
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '点数請求',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // モーダル用設定グループ枠
  Widget _buildSettingGroup({
    String? label,
    Widget? labelWidget,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelWidget != null) labelWidget,
          if (label != null)
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: textMuted),
            ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  // モーダル選択用ボタン (Primary/Secondary)
  Widget _buildModalButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? accentGold : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  // 本場カウンター用 +/- ボタン
  Widget _buildCounterButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 36,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 点数・役 グリッド
  Widget _buildScoreGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _scoreOptions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final option = _scoreOptions[index];

        if (option.isDisabled) {
          return const SizedBox();
        }

        final isSelected = _selectedScore == option.text;

        // 特殊レイアウト：「その他(支払者が設定)」ボタン（2列分ぶち抜き風表現）
        if (option.isWide) {
          return GridTile(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return InkWell(
                  onTap: () => setState(() => _selectedScore = option.text!),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentGold
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option.text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return InkWell(
          onTap: () => setState(() => _selectedScore = option.text!),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? accentGold
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              option.text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                height: 1.1,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

// 点数オプション用データ型
class ScoreOption {
  final String? text;
  final bool isDisabled;
  final bool isWide;

  const ScoreOption({
    this.text,
    this.isDisabled = false,
    this.isWide = false,
  });
}