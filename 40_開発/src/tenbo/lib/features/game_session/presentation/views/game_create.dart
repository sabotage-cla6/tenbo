import 'package:flutter/material.dart';
import 'package:tenbo/features/game_session/presentation/views/players_home.dart';
// TODO: players_homeのインポートパスに合わせて変更してください
// import 'players_home_screen.dart';

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  State<GameCreateScreen> createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  // 状態管理用変数
  String _selectedPlayerCount = '四人麻雀';
  String _startingPoints = '25,000点';
  String _returnPoints = '30,000点';
  String _umaType = '10-30';
  int _umaFirst = 30;
  int _umaSecond = 10;
  int _umaThird = -10;
  int _umaFourth = -30;

  String _rendaType = 'head-bump';
  bool _boxSettlement = true;
  String _roundingType = 'round';
  int _cutVal = 5;
  int _inVal = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09170E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(12, 28, 18, 0.98),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF39C12), Color(0xFFF1C40F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '点',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFF1C40F)],
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
              IconButton(
                icon: const Text(
                  '✕',
                  style: TextStyle(color: Color(0xFF8E9E94), fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ページタイトル
              const Column(
                children: [
                  Text(
                    '新規卓の作成',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ルールを設定して対局ルームを作成します',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E9E94)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 基本設定カード
              _buildExpansionCard(
                title: '📝 基本情報設定',
                children: [
                  _buildSettingRow(
                    title: '卓の名称',
                    desc: '参加者に表示される名前',
                    control: SizedBox(
                      width: 180,
                      child: _buildTextField(
                        initialValue: '金曜夜セット麻雀',
                        hint: '例: たなか卓',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: 'パスコード',
                    desc: '入室用(任意・4桁)',
                    control: SizedBox(
                      width: 140,
                      child: _buildTextField(
                        hint: 'なし',
                        obscureText: true,
                        maxLength: 4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 既存卓コピー セクション
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 既存卓情報コピー',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF39C12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFF39C12,
                          ).withOpacity(0.12),
                          foregroundColor: const Color(0xFFF1C40F),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Color(0xFFF39C12),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          '既存の卓から設定を読み込む',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 対局形式カード
              _buildExpansionCard(
                title: '🀄 対局形式',
                children: [
                  _buildSettingRow(
                    title: '人数設定',
                    control: SizedBox(
                      width: 180,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF050D08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2C5E3D)),
                        ),
                        child: Row(
                          children: [
                            _buildSegmentBtn(
                              '四人麻雀',
                              _selectedPlayerCount == '四人麻雀',
                              () {
                                setState(() => _selectedPlayerCount = '四人麻雀');
                              },
                            ),
                            _buildSegmentBtn(
                              '三人麻雀',
                              _selectedPlayerCount == '三人麻雀',
                              () {
                                setState(() => _selectedPlayerCount = '三人麻雀');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '配給原点',
                    control: SizedBox(
                      width: 140,
                      child: _buildDropdown(
                        value: _startingPoints,
                        items: ['25,000点', '26,000点', '30,000点', '35,000点'],
                        onChanged: (val) =>
                            setState(() => _startingPoints = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '返し点',
                    control: SizedBox(
                      width: 140,
                      child: _buildDropdown(
                        value: _returnPoints,
                        items: ['30,000点', '25,000点', '40,000点'],
                        onChanged: (val) =>
                            setState(() => _returnPoints = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: 'ウマ',
                    control: SizedBox(
                      width: 140,
                      child: _buildDropdown(
                        value: _umaType,
                        items: const [
                          DropdownMenuItem(
                            value: '10-30',
                            child: Text('10 - 30'),
                          ),
                          DropdownMenuItem(
                            value: '10-20',
                            child: Text('10 - 20'),
                          ),
                          DropdownMenuItem(
                            value: '5-10',
                            child: Text('5 - 10'),
                          ),
                          DropdownMenuItem(value: 'none', child: Text('なし')),
                          DropdownMenuItem(value: 'custom', child: Text('その他')),
                        ],
                        onChanged: (val) => setState(() => _umaType = val!),
                      ),
                    ),
                  ),
                  if (_umaType == 'custom') ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: _customBoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1着〜4着のウマ(pt)を直接指定',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8E9E94),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildUmaInput(
                                '1着',
                                _umaFirst,
                                (v) => _umaFirst = int.tryParse(v) ?? 0,
                              ),
                              const SizedBox(width: 6),
                              _buildUmaInput(
                                '2着',
                                _umaSecond,
                                (v) => _umaSecond = int.tryParse(v) ?? 0,
                              ),
                              const SizedBox(width: 6),
                              _buildUmaInput(
                                '3着',
                                _umaThird,
                                (v) => _umaThird = int.tryParse(v) ?? 0,
                              ),
                              const SizedBox(width: 6),
                              _buildUmaInput(
                                '4着',
                                _umaFourth,
                                (v) => _umaFourth = int.tryParse(v) ?? 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // 積み棒設定カード
              _buildExpansionCard(
                title: '🥢 積み棒設定',
                children: [
                  _buildSettingRow(
                    title: '点数',
                    desc: '1本あたりの加算点',
                    control: SizedBox(
                      width: 140,
                      child: _buildUnitTextField(
                        initialValue: '300',
                        unit: '点',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '複数ロン時',
                    desc: 'ダブロン等の積み棒分配',
                    control: SizedBox(
                      width: 140,
                      child: _buildDropdown(
                        value: _rendaType,
                        items: const [
                          DropdownMenuItem(
                            value: 'head-bump',
                            child: Text('頭ハネ'),
                          ),
                          DropdownMenuItem(value: 'all', child: Text('全員')),
                        ],
                        onChanged: (val) => setState(() => _rendaType = val!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 精算設定カード
              _buildExpansionCard(
                title: '🧮 精算設定',
                children: [
                  _buildSettingRow(
                    title: '箱下精算',
                    desc: 'マイナス分も精算に反映',
                    control: Switch(
                      value: _boxSettlement,
                      activeColor: Colors.black,
                      activeTrackColor: const Color(0xFFF39C12),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.15,
                      ),
                      onChanged: (val) => setState(() => _boxSettlement = val),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '飛び賞',
                    control: SizedBox(
                      width: 140,
                      child: _buildUnitTextField(
                        initialValue: '10',
                        unit: 'pt',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '焼き鳥',
                    control: SizedBox(
                      width: 140,
                      child: _buildUnitTextField(
                        initialValue: '10',
                        unit: 'pt',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    title: '端数処理',
                    desc: 'ポイント計算時の丸め方式',
                    control: SizedBox(
                      width: 140,
                      child: _buildDropdown(
                        value: _roundingType,
                        items: const [
                          DropdownMenuItem(value: 'round', child: Text('四捨五入')),
                          DropdownMenuItem(
                            value: '5cut6in',
                            child: Text('五捨六入'),
                          ),
                          DropdownMenuItem(value: 'none', child: Text('丸めなし')),
                          DropdownMenuItem(value: 'ceil', child: Text('切り上げ')),
                          DropdownMenuItem(value: 'floor', child: Text('切り捨て')),
                          DropdownMenuItem(value: 'custom', child: Text('その他')),
                        ],
                        onChanged: (val) =>
                            setState(() => _roundingType = val!),
                      ),
                    ),
                  ),
                  if (_roundingType == 'custom') ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: _customBoxDecoration(),
                      child: Column(
                        children: [
                          const Text(
                            '「捨」の数字を入力すると「入」が自動計算されます',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8E9E94),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                child: _shortTextField(
                                  initialValue: _cutVal.toString(),
                                  onChanged: (v) {
                                    setState(() {
                                      _cutVal = int.tryParse(v) ?? 0;
                                      if (_cutVal >= 0 && _cutVal <= 8) {
                                        _inVal = _cutVal + 1;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '捨',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 50,
                                child: _shortTextField(
                                  initialValue: _inVal.toString(),
                                  enabled: false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '入',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // アクションボタン
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF14301F),
                        foregroundColor: const Color(0xFFF0F4F1),
                        side: const BorderSide(
                          color: Color(0xFF2C5E3D),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // ホームボタンを押したときの処理
                      onPressed: () {
                        // ルートを全てクリアして players_home (PlayersHomeScreen) へ遷移する場合
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                const PlayersHomeScreen(), // クラス名をルール通りScreenに統一
                          ),
                          (route) => false,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🏠 ホーム',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '✨ 卓を作成して部屋に入る',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- ヘルパーウィジェット・装飾群 ---

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color.fromRGBO(20, 48, 31, 0.9),
      border: Border.all(color: const Color(0xFF2C5E3D), width: 1.5),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black45, offset: Offset(0, 8), blurRadius: 20),
      ],
    );
  }

  BoxDecoration _customBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFF050D08),
      border: Border.all(color: const Color(0xFF2C5E3D)),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _buildExpansionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF39C12),
          ),
        ),
        iconColor: const Color(0xFF8E9E94),
        collapsedIconColor: const Color(0xFF8E9E94),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: children,
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    String? desc,
    required Widget control,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF0F4F1),
                ),
              ),
              if (desc != null) ...[
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8E9E94),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        control,
      ],
    );
  }

  Widget _buildTextField({
    String? initialValue,
    String? hint,
    TextAlign textAlign = TextAlign.right,
    bool obscureText = false,
    int? maxLength,
  }) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: initialValue != null
            ? TextEditingController(text: initialValue)
            : null,
        obscureText: obscureText,
        maxLength: maxLength,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: textAlign,
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF8E9E94),
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: const Color(0xFF050D08),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2C5E3D), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF39C12), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitTextField({
    required String initialValue,
    required String unit,
  }) {
    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: TextEditingController(text: initialValue),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF050D08),
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 32, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF2C5E3D),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFF39C12),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              unit,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E9E94),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required dynamic value,
    required List<dynamic> items,
    required ValueChanged<dynamic?> onChanged,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF050D08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2C5E3D), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          dropdownColor: const Color(0xFF050D08),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF8E9E94)),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          items: items.map((item) {
            if (item is String) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, textAlign: TextAlign.right),
              );
            }
            return item as DropdownMenuItem<dynamic>;
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSegmentBtn(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF39C12) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: active ? Colors.black : const Color(0xFF8E9E94),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUmaInput(
    String rank,
    int value,
    ValueChanged<String> onChanged,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            rank,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8E9E94),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 34,
            child: TextField(
              controller: TextEditingController(text: value.toString()),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF14301F),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFF2C5E3D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFF39C12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shortTextField({
    required String initialValue,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: TextEditingController(text: initialValue),
        enabled: enabled,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? const Color(0xFF14301F) : Colors.black,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF2C5E3D)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF2C5E3D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFF39C12)),
          ),
        ),
      ),
    );
  }
}
