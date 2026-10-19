import 'package:flutter/material.dart';

import '../../../features/match/presentation/pages/match_page.dart';

class MatchLobbyPage extends StatefulWidget {
  const MatchLobbyPage({super.key});

  @override
  State<MatchLobbyPage> createState() => _MatchLobbyPageState();
}

class _MatchLobbyPageState extends State<MatchLobbyPage> {
  // --- カラーパレット ---
  static const Color bgColor = Color(0xFF09170E);
  static const Color headerBg = Color(0xFA0C1C12);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color accentRed = Color(0xFFE74C3C);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color inputBg = Color(0xFF08140C);

  // --- 画面状態 (State) ---
  final TextEditingController _tableNameController =
      TextEditingController(text: '金曜定期セット卓 (東南戦)');

  final List<TextEditingController> _playerControllers = [
    TextEditingController(text: 'プレイヤー1 (親)'),
    TextEditingController(text: '自分'),
    TextEditingController(text: 'プレイヤー3'),
    TextEditingController(text: 'プレイヤー4'),
  ];

  // ルール設定状態
  String _gameMode = '4人・東南戦';
  String _startPoints = '25000';
  String _returnPoints = '30000';
  String _uma1 = '30';
  String _uma2 = '10';
  String _uma3 = '-10';
  String _uma4 = '-30';
  bool _kiriage = true;
  String _multiRon = '頭ハネ (1名のみ)';
  bool _tobi = true;
  String _rounding = '五捨六入';
  bool _hakoshita = true;

  @override
  void dispose() {
    _tableNameController.dispose();
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // プレイヤーの席を入れ替える
  void _swapPlayer(int index) {
    final nextIndex = (index + 1) % 4;
    setState(() {
      final temp = _playerControllers[index].text;
      _playerControllers[index].text = _playerControllers[nextIndex].text;
      _playerControllers[nextIndex].text = temp;
    });
  }

  // ルール編集モーダルを開く
  void _openRuleModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return _RuleEditModal(
          initialGameMode: _gameMode,
          initialStartPoints: _startPoints,
          initialReturnPoints: _returnPoints,
          initialUma1: _uma1,
          initialUma2: _uma2,
          initialUma3: _uma3,
          initialUma4: _uma4,
          initialKiriage: _kiriage,
          initialMultiRon: _multiRon,
          initialTobi: _tobi,
          initialRounding: _rounding,
          initialHakoshita: _hakoshita,
          onSave: (rules) {
            setState(() {
              _gameMode = rules['gameMode'];
              _startPoints = rules['startPoints'];
              _returnPoints = rules['returnPoints'];
              _uma1 = rules['uma1'];
              _uma2 = rules['uma2'];
              _uma3 = rules['uma3'];
              _uma4 = rules['uma4'];
              _kiriage = rules['kiriage'];
              _multiRon = rules['multiRon'];
              _tobi = rules['tobi'];
              _rounding = rules['rounding'];
              _hakoshita = rules['hakoshita'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ルール設定を保存しました'),
                backgroundColor: accentGreen,
              ),
            );
          },
        );
      },
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
                // ヘッダー
                _buildHeader(),

                // メインコンテンツ
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTableAndRuleSection(),
                      const SizedBox(height: 16),
                      _buildPlayerSetupSection(),
                    ],
                  ),
                ),

                // フッター固定ボタン
                _buildFooterActions(),
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
            '対局準備ロビー',
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
        ],
      ),
    );
  }

  // --- 統合：卓情報・対局ルール ---
  Widget _buildTableAndRuleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('🀄', style: TextStyle(fontSize: 13)),
            SizedBox(width: 6),
            Text(
              '卓情報・対局ルール',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: accentGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorder, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. 卓の名前入力
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        controller: _tableNameController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: accentGoldLight,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          fillColor: inputBg,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: accentGold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Center(
                      child: Text('✏️', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.white10),
              ),
              // 2. 対局ルールサマリー
              InkWell(
                onTap: _openRuleModal,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_gameMode (${_startPoints}点持ち / ${_returnPoints}点返し)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ウマ: $_uma2-$_uma1 / 切り上げ満貫${_kiriage ? "あり" : "なし"} / 箱トビ終了${_tobi ? "あり" : "なし"}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: accentGold),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              '詳細・変更',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: accentGoldLight,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text('⚙️', style: TextStyle(fontSize: 10)),
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
      ],
    );
  }

  // --- 参加プレイヤー設定 ---
  Widget _buildPlayerSetupSection() {
    final winds = ['東', '南', '西', '北'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('👥', style: TextStyle(fontSize: 13)),
            SizedBox(width: 6),
            Text(
              '参加プレイヤー・座席設定',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: accentGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Column(
          children: List.generate(4, (index) {
            final isEast = index == 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder, width: 1.5),
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
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isEast
                                ? accentOrange
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              winds[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          height: 32,
                          child: TextField(
                            controller: _playerControllers[index],
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              fillColor: inputBg,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(color: cardBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(color: accentGold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _swapPlayer(index),
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Center(
                          child: Text('🔄', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        // 起家・場決めボタンエリア
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('起家・場決めを実行します')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardBg,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: cardBorder, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Text('🎲', style: TextStyle(fontSize: 12)),
                label: const Text('起家・場決め',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('起家決めを実行します')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardBg,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: cardBorder, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Text('🀄', style: TextStyle(fontSize: 12)),
                label: const Text('起家決め',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- フッターアクション ---
  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: headerBg,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // 対局画面 (MatchPage) へ画面遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MatchPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [accentGold, Color(0xFFD35400)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '対局を開始する',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ロビーから退出します')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: accentRed.withValues(alpha: 0.15),
                  side: BorderSide(color: accentRed.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🚪', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Text(
                      '退出',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF7675),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ルール編集ダイアログ (モーダル)
// =============================================================================
class _RuleEditModal extends StatefulWidget {
  final String initialGameMode;
  final String initialStartPoints;
  final String initialReturnPoints;
  final String initialUma1;
  final String initialUma2;
  final String initialUma3;
  final String initialUma4;
  final bool initialKiriage;
  final String initialMultiRon;
  final bool initialTobi;
  final String initialRounding;
  final bool initialHakoshita;
  final ValueChanged<Map<String, dynamic>> onSave;

  const _RuleEditModal({
    required this.initialGameMode,
    required this.initialStartPoints,
    required this.initialReturnPoints,
    required this.initialUma1,
    required this.initialUma2,
    required this.initialUma3,
    required this.initialUma4,
    required this.initialKiriage,
    required this.initialMultiRon,
    required this.initialTobi,
    required this.initialRounding,
    required this.initialHakoshita,
    required this.onSave,
  });

  @override
  State<_RuleEditModal> createState() => _RuleEditModalState();
}

class _RuleEditModalState extends State<_RuleEditModal> {
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color inputBg = Color(0xFF06110A);

  late String _gameMode;
  late TextEditingController _startPointsController;
  late TextEditingController _returnPointsController;
  late TextEditingController _uma1Controller;
  late TextEditingController _uma2Controller;
  late TextEditingController _uma3Controller;
  late TextEditingController _uma4Controller;
  late bool _kiriage;
  late String _multiRon;
  late bool _tobi;
  late String _rounding;
  late bool _hakoshita;

  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _gameMode = widget.initialGameMode;
    _startPointsController =
        TextEditingController(text: widget.initialStartPoints);
    _returnPointsController =
        TextEditingController(text: widget.initialReturnPoints);
    _uma1Controller = TextEditingController(text: widget.initialUma1);
    _uma2Controller = TextEditingController(text: widget.initialUma2);
    _uma3Controller = TextEditingController(text: widget.initialUma3);
    _uma4Controller = TextEditingController(text: widget.initialUma4);
    _kiriage = widget.initialKiriage;
    _multiRon = widget.initialMultiRon;
    _tobi = widget.initialTobi;
    _rounding = widget.initialRounding;
    _hakoshita = widget.initialHakoshita;
  }

  @override
  void dispose() {
    _startPointsController.dispose();
    _returnPointsController.dispose();
    _uma1Controller.dispose();
    _uma2Controller.dispose();
    _uma3Controller.dispose();
    _uma4Controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave({
      'gameMode': _gameMode,
      'startPoints': _startPointsController.text,
      'returnPoints': _returnPointsController.text,
      'uma1': _uma1Controller.text,
      'uma2': _uma2Controller.text,
      'uma3': _uma3Controller.text,
      'uma4': _uma4Controller.text,
      'kiriage': _kiriage,
      'multiRon': _multiRon,
      'tobi': _tobi,
      'rounding': _rounding,
      'hakoshita': _hakoshita,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['すべて', '基本設定', 'あがり・精算', 'ドラ・赤', '特殊ルール'];

    return Dialog(
      backgroundColor: const Color(0xFF102619),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: accentGold, width: 1.5),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🛠️ ルール設定の編集',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: accentGold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: textMuted, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Colors.white12),
              const SizedBox(height: 10),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isActive = _activeTabIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: () => setState(() => _activeTabIndex = index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isActive
                                ? accentGold
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isActive
                                  ? accentGoldLight
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.black : textMuted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),

              // Form Body
              Expanded(
                child: ListView(
                  children: [
                    _buildSection1Basic(),
                    const SizedBox(height: 8),
                    _buildSection2Agari(),
                    const SizedBox(height: 8),
                    _buildSection3Seisan(),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Modal Footer
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('キャンセル',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [accentGold, Color(0xFFD35400)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Text(
                            '変更を保存',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
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
    );
  }

  Widget _buildSection1Basic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('【基本設定】',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accentGoldLight)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('対局形式',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            DropdownButton<String>(
              value: _gameMode,
              dropdownColor: const Color(0xFF102619),
              style: const TextStyle(fontSize: 12, color: Colors.white),
              items: ['4人・東南戦', '4人・東風戦', '3人・東南戦']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _gameMode = v!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection2Agari() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('【あがり設定】',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accentGoldLight)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('切り上げ満貫',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            Switch(
              value: _kiriage,
              activeTrackColor: accentGold,
              onChanged: (v) => setState(() => _kiriage = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection3Seisan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('【精算設定】',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accentGoldLight)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('トビ終了',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            Switch(
              value: _tobi,
              activeTrackColor: accentGold,
              onChanged: (v) => setState(() => _tobi = v),
            ),
          ],
        ),
      ],
    );
  }
}