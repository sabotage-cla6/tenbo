import 'package:flutter/material.dart';

class PointPaymentScreen extends StatefulWidget {
  const PointPaymentScreen({super.key});

  @override
  State<PointPaymentScreen> createState() => _PointPaymentScreenState();
}

class _PointPaymentScreenState extends State<PointPaymentScreen> {
  // 選択された支払区分
  String _selectedPaymentType = 'ron';

  // 各入力用コントローラー
  final TextEditingController _topController = TextEditingController(
    text: '1000',
  );
  final TextEditingController _leftController = TextEditingController(
    text: '0',
  );
  final TextEditingController _rightController = TextEditingController(
    text: '0',
  );

  // 計算された合計点数
  int _totalAmount = 1000;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    final top = int.tryParse(_topController.text) ?? 0;
    final left = int.tryParse(_leftController.text) ?? 0;
    final right = int.tryParse(_rightController.text) ?? 0;

    setState(() {
      _totalAmount = top + left + right;
    });
  }

  void _confirmPayment() {
    debugPrint("支払確定: 区分=$_selectedPaymentType, 合計=$_totalAmount");
  }

  @override
  Widget build(BuildContext context) {
    // カラー定数の定義 (Tailwind CSS 互換カラー)
    const slate900 = Color(0xFF0F172A);
    const slate950 = Color(0xFF020617);
    const slate800 = Color(0xFF1E293B);
    const slate700 = Color(0xFF334155);
    const slate400 = Color(0xFF94A3B8);
    const slate300 = Color(0xFFCBD5E1);
    const slate200 = Color(0xFFE2E8F0);

    const amber400 = Color(0xFFFACC15);
    const amber500 = Color(0xFFF59E0B);
    const amber950 = Color(0xFF451A03);

    const red400 = Color(0xFFF87171);
    const red500 = Color(0xFFEF4444);
    const red950 = Color(0xFF450A0A);

    const emerald400 = Color(0xFF34D399);
    const mahjongBg = Color(0xFF065F46);

    return Scaffold(
      backgroundColor: slate900,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: slate900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: slate800),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- ヘッダー ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '支払確認',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: slate200,
                            ),
                          ),
                          Text(
                            '移動する点数を直接入力',
                            style: TextStyle(fontSize: 10, color: slate400),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: slate800,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: slate700),
                        ),
                        child: const Text(
                          '東2局 0本場',
                          style: TextStyle(fontSize: 12, color: amber400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- 支払区分プルダウン ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '支払区分',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600, // semibold -> w600
                            color: slate300,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: slate950,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: slate700),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPaymentType,
                              isExpanded: true,
                              dropdownColor: slate950,
                              style: const TextStyle(
                                fontSize: 12,
                                color: slate200,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: slate400,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'ron',
                                  child: Text('放銃'),
                                ),
                                DropdownMenuItem(
                                  value: 'tsumo',
                                  child: Text('ツモ'),
                                ),
                                DropdownMenuItem(
                                  value: 'chombo',
                                  child: Text('沖和'),
                                ),
                                DropdownMenuItem(
                                  value: 'penalty',
                                  child: Text('ペナルティ'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedPaymentType = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- 対局画面風 4方向レイアウト ---
                  Container(
                    height: 380,
                    decoration: BoxDecoration(
                      color: mahjongBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: amber950, width: 4),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        // 対面 (上)
                        Align(
                          alignment: Alignment.topCenter,
                          child: FractionallySizedBox(
                            widthFactor: 0.38,
                            heightFactor: 0.38,
                            child: _PlayerCard(
                              roleText: '支払相手',
                              roleBgColor: red950.withValues(alpha: 0.8),
                              roleTextColor: red400,
                              windText: '西家',
                              playerName: '対面 (Aさん)',
                              pointsText: '25,000点',
                              inputLabel: '支払額 (点)',
                              controller: _topController,
                              borderColor: red500,
                              enabled: true,
                              textColor: amber400,
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                        ),

                        // 上手 (左)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.38,
                            heightFactor: 0.38,
                            child: _PlayerCard(
                              roleText: '対象外',
                              roleBgColor: Colors.transparent,
                              roleTextColor: slate400,
                              windText: '北家',
                              playerName: '上手 (Bさん)',
                              pointsText: '25,000点',
                              inputLabel: '支払額 (点)',
                              controller: _leftController,
                              borderColor: slate700.withValues(alpha: 0.5),
                              enabled: false,
                              textColor: amber400,
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                        ),

                        // 中央情報 (合計点数)
                        Align(
                          alignment: Alignment.center,
                          child: FractionallySizedBox(
                            widthFactor: 0.38,
                            heightFactor: 0.28,
                            child: Container(
                              decoration: BoxDecoration(
                                color: slate950.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: amber500.withValues(alpha: 0.5),
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '合計点数',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: slate400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}点',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: amber400,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 下家 (右)
                        Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.38,
                            heightFactor: 0.38,
                            child: _PlayerCard(
                              roleText: '対象外',
                              roleBgColor: Colors.transparent,
                              roleTextColor: slate400,
                              windText: '東家',
                              playerName: '下家 (Cさん)',
                              pointsText: '25,000点',
                              inputLabel: '支払額 (点)',
                              controller: _rightController,
                              borderColor: slate700.withValues(alpha: 0.5),
                              enabled: false,
                              textColor: amber400,
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                        ),

                        // 自分 (下)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            widthFactor: 0.38,
                            heightFactor: 0.38,
                            child: _PlayerCard(
                              roleText: '和了者',
                              roleBgColor: amber950.withValues(alpha: 0.6),
                              roleTextColor: amber400,
                              windText: '南家',
                              playerName: '自分 (あなた)',
                              pointsText: '25,000点',
                              inputLabel: '受取額 (点)',
                              controller: TextEditingController(
                                text: '$_totalAmount',
                              ),
                              borderColor: amber400.withValues(alpha: 0.8),
                              enabled: false,
                              textColor: emerald400,
                              isReadOnly: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- フッターボタン ---
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: slate800,
                            foregroundColor: slate300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ), // EdgeInsets.symmetric に変更
                            elevation: 0,
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
                          onPressed: _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: amber500,
                            foregroundColor: slate950,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ), // EdgeInsets.symmetric に変更
                            elevation: 4,
                          ),
                          child: const Text(
                            '支払確定',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
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
}

// プレイヤーカード・コンポーネント
class _PlayerCard extends StatelessWidget {
  final String roleText;
  final Color roleBgColor;
  final Color roleTextColor;
  final String windText;
  final String playerName;
  final String pointsText;
  final String inputLabel;
  final TextEditingController controller;
  final Color borderColor;
  final bool enabled;
  final Color textColor;
  final bool isReadOnly;
  final ValueChanged<String>? onChanged;

  const _PlayerCard({
    required this.roleText,
    required this.roleBgColor,
    required this.roleTextColor,
    required this.windText,
    required this.playerName,
    required this.pointsText,
    required this.inputLabel,
    required this.controller,
    required this.borderColor,
    this.enabled = true,
    required this.textColor,
    this.isReadOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const slate800 = Color(0xFF1E293B);
    const slate950 = Color(0xFF020617);
    const slate400 = Color(0xFF94A3B8);
    const slate300 = Color(0xFFCBD5E1);

    return Container(
      decoration: BoxDecoration(
        color: slate800.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 上部役割＆風
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: roleBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  roleText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600, // semibold -> w600
                    color: roleTextColor,
                  ),
                ),
              ),
              Text(
                windText,
                style: const TextStyle(fontSize: 9, color: slate400),
              ),
            ],
          ),

          // プレイヤー名・現在持ち点
          Column(
            children: [
              Text(
                playerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                pointsText,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: slate300,
                ),
              ),
            ],
          ),

          // 入力エリア
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inputLabel,
                style: const TextStyle(fontSize: 8, color: slate400),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 24,
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  readOnly: isReadOnly,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  onChanged: onChanged,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    fillColor: slate950,
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
