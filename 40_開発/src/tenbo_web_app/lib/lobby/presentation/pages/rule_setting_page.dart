import 'package:flutter/material.dart';

// MatchLobbyPage のインポート（プロジェクトの配置パスに合わせて調整してください）
import 'match_lobby_page.dart';

class RuleSettingPage extends StatefulWidget {
  const RuleSettingPage({super.key});

  @override
  State<RuleSettingPage> createState() => _RuleSettingPageState();
}

class _RuleSettingPageState extends State<RuleSettingPage> {
  // --- プロジェクト共通カラーパレット (home_page.dartに準拠) ---
  static const Color bgColor = Color(0xFF09170E);
  static const Color headerBg = Color(0xFA0C1C12);
  static const Color cardBg = Color(0xE614301F);
  static const Color cardBorder = Color(0xFF2C5E3D);
  static const Color accentGold = Color(0xFFF39C12);
  static const Color accentGoldLight = Color(0xFFF1C40F);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color textMuted = Color(0xFF8E9E94);
  static const Color inputBg = Color(0xFF08140C);

  // 各セクション移動用 GlobalKey
  final GlobalKey _basicKey = GlobalKey();
  final GlobalKey _agariKey = GlobalKey();
  final GlobalKey _seisanKey = GlobalKey();

  // --- 設定値 State ---
  final TextEditingController _tableIdController = TextEditingController(text: 'TABLE-001');
  String _gameMode = '4人・東南戦';
  bool _extension = true;
  final TextEditingController _startPointsController = TextEditingController(text: '25000');
  final TextEditingController _returnPointsController = TextEditingController(text: '30000');

  // 順位ウマ (1位〜4位)
  final TextEditingController _uma1Controller = TextEditingController(text: '30');
  final TextEditingController _uma2Controller = TextEditingController(text: '10');
  final TextEditingController _uma3Controller = TextEditingController(text: '-10');
  final TextEditingController _uma4Controller = TextEditingController(text: '-30');

  // あがり・点数計算
  bool _kiriage = true;
  String _multiRon = '頭ハネ (1名のみ)';

  // 精算ルール
  String _rounding = '五捨六入';
  bool _tobi = true;
  bool _hakoshita = true;
  final TextEditingController _tobishoController = TextEditingController(text: '10');

  @override
  void dispose() {
    _tableIdController.dispose();
    _startPointsController.dispose();
    _returnPointsController.dispose();
    _uma1Controller.dispose();
    _uma2Controller.dispose();
    _uma3Controller.dispose();
    _uma4Controller.dispose();
    _tobishoController.dispose();
    super.dispose();
  }

  // 指定セクションへのスムーズスクロール
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  // 卓作成アクション (MatchLobbyPage への画面遷移)
  void _saveRules() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('卓「${_tableIdController.text}」を作成しました！'),
        backgroundColor: accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );

    // MatchLobbyPage へ遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MatchLobbyPage(),
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
                // ヘッダー
                _buildHeader(),

                // ジャンプタブ
                _buildRuleTabs(),

                // メインコンテンツ
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 一番最初の卓ID入力エリア
                      _buildTableIdCard(),
                      const SizedBox(height: 16),
                      _buildBasicSection(),
                      const SizedBox(height: 16),
                      _buildAgariSection(),
                      const SizedBox(height: 16),
                      _buildSeisanSection(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: const BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: const Center(
        child: Text(
          '⚙️ ルール設定',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: accentGold,
          ),
        ),
      ),
    );
  }

  Widget _buildRuleTabs() {
    return Container(
      color: Colors.black26,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('基本対局ルール', () => _scrollToSection(_basicKey)),
            const SizedBox(width: 8),
            _buildTabButton('あがり・点数計算', () => _scrollToSection(_agariKey)),
            const SizedBox(width: 8),
            _buildTabButton('精算ルール', () => _scrollToSection(_seisanKey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // 卓ID入力カード（一番最上部に配置）
  Widget _buildTableIdCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tag, size: 18, color: accentGold),
              SizedBox(width: 6),
              Text(
                '卓ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '（参加者が識別するための部屋ID）',
                  style: TextStyle(fontSize: 11, color: textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: TextField(
              controller: _tableIdController,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: accentGoldLight,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                hintText: '例: TABLE-001',
                hintStyle: const TextStyle(fontSize: 12, color: textMuted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                fillColor: inputBg,
                filled: true,
                prefixIcon: const Icon(Icons.key, size: 18, color: textMuted),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: cardBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: accentGold, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. 基本対局ルール
  Widget _buildBasicSection() {
    return _AccordionCard(
      key: _basicKey,
      title: '⚙️ 基本対局ルール',
      children: [
        _buildDropdownCard('対局形式', 'プレイヤー数と局数', _gameMode, ['4人・東南戦', '4人・東風戦', '3人・東南戦', '3人・東風戦'], (v) => setState(() => _gameMode = v!)),
        _buildSwitchCard('延長戦', '東風戦での南入、半荘戦での西入', _extension, (v) => setState(() => _extension = v)),
        _buildNumberInputCard('持ち点(配給原点)', '開始時の所持点数', _startPointsController),
        _buildNumberInputCard('返し点 (原点)', 'オカ計算の基準点', _returnPointsController),
        _buildUmaCard(),
      ],
    );
  }

  // 2. あがり・点数計算
  Widget _buildAgariSection() {
    return _AccordionCard(
      key: _agariKey,
      title: '🀄 あがり・点数計算',
      children: [
        _buildSwitchCard('切り上げ満貫', '30符4翻/60符3翻を8000点化', _kiriage, (v) => setState(() => _kiriage = v)),
        _buildDropdownCard('複数和了時の積棒', '複数人のロンあがり', _multiRon, ['頭ハネ (1名のみ)', '全員'], (v) => setState(() => _multiRon = v!)),
      ],
    );
  }

  // 3. 精算ルール
  Widget _buildSeisanSection() {
    return _AccordionCard(
      key: _seisanKey,
      title: '⚖️ 精算ルール',
      children: [
        _buildDropdownCard('100点棒', '100点棒の丸め方法を指定', _rounding, ['五捨六入', '丸めなし（小数点利用）', '四捨五入', '切り捨て', '切り上げ'], (v) => setState(() => _rounding = v!)),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black26,
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('💸 トビ・マイナス点設定', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentGoldLight)),
              ),
              _buildSwitchCard('トビ終了', '持ち点0点未満で即終了', _tobi, (v) => setState(() => _tobi = v)),
              const SizedBox(height: 8),
              _buildSwitchCard('箱下精算', '持ち点0点未満をマイナス点として計算', _hakoshita, (v) => setState(() => _hakoshita = v)),
              if (_tobi) ...[
                const SizedBox(height: 8),
                _buildNumberInputCard('飛び賞 (pt)', '飛ばした際に獲得する賞点（無しは0）', _tobishoController),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUmaCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: inputBg.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('順位ウマ (pt)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('1位 〜 4位の配分点を指定', style: TextStyle(fontSize: 11, color: textMuted)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildUmaField('1位', _uma1Controller),
              const SizedBox(width: 6),
              _buildUmaField('2位', _uma2Controller),
              const SizedBox(width: 6),
              _buildUmaField('3位', _uma3Controller),
              const SizedBox(width: 6),
              _buildUmaField('4位', _uma4Controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUmaField(String label, TextEditingController controller) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          SizedBox(
            height: 36,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentGoldLight),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                fillColor: inputBg,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: cardBorder)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard(String name, String sub, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: inputBg.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(sub, style: const TextStyle(fontSize: 11, color: textMuted)),
              ],
            ),
          ),
          SizedBox(
            height: 24,
            child: Switch(
              value: value,
              activeThumbColor: Colors.white,
              activeTrackColor: accentGreen,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard(String name, String sub, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: inputBg.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(sub, style: const TextStyle(fontSize: 11, color: textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: inputBg,
              border: Border.all(color: cardBorder),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                dropdownColor: cardBg,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentGoldLight),
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInputCard(String name, String sub, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: inputBg.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(sub, style: const TextStyle(fontSize: 11, color: textMuted)),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 36,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentGoldLight),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fillColor: inputBg,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: cardBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: accentGold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: headerBg,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _saveRules,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [accentGold, Color(0xFFD35400)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Text('卓作成', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccordionCard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const _AccordionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<_AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<_AccordionCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE614301F),
        border: Border.all(color: const Color(0xFF2C5E3D)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: Colors.white.withValues(alpha: 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFF1C40F)),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Text('▶', style: TextStyle(fontSize: 10, color: Color(0xFF8E9E94))),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1, color: Colors.white10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: widget.children
                    .map((child) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: child,
                        ))
                    .toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }
}