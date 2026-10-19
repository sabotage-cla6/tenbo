import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/login_page.dart';
import '../../../auth/presentation/signup_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildHeader(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // メインコンテンツエリア（2ペイン / レスポンシブ）
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 32.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 900px以上は大画面（2ペイン表示）、未満は1列表示
                        if (constraints.maxWidth >= 900) {
                          return const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 12, child: _LeftPane()),
                              SizedBox(width: 40),
                              Expanded(flex: 8, child: _RightPane()),
                            ],
                          );
                        } else {
                          return const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _LeftPane(),
                              SizedBox(height: 40),
                              _RightPane(),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // フッター
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }

  // アプリバー（ヘッダー）
  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg.withValues(alpha: 0.95),
      elevation: 0,
      titleSpacing: 24,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentGold, AppColors.accentGoldLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4DF39C12),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '点',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, AppColors.accentGoldLight],
            ).createShader(bounds),
            child: const Text(
              '天棒',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1.0,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 左ペイン：サービス説明
// -----------------------------------------------------------------------------
class _LeftPane extends StatelessWidget {
  const _LeftPane();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // バッジ
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accentGold),
          ),
          child: const Text(
            '🀄 麻雀スコア管理・記録WEBアプリ',
            style: TextStyle(
              color: AppColors.accentGoldLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // メインキャッチコピー
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              height: 1.25,
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: '点棒計算をもっとスマートに。\n対局のすべてを'),
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, AppColors.accentGoldLight],
                  ).createShader(bounds),
                  child: const Text(
                    '「天棒」',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: 'で記録。'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // サブ説明テキスト
        const Text(
          '「天棒」は、麻雀の点数移動・リーチ棒の管理・成績記録をWeb上で完結できる対局サポートツールです。面メンツとのスコア共有や詳細なデータ分析がこれひとつで完了します。',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textMuted,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 32),

        // 機能カードリスト
        const Column(
          children: [
            _FeatureTile(
              icon: '⚡',
              title: 'ワンタップで点数計算',
              description: '複雑な点数移動や供託の計算もワンタップで自動計算。',
            ),
            SizedBox(height: 14),
            _FeatureTile(
              icon: '📊',
              title: '詳細な戦績・成績分析',
              description: '平均順位・トータル得点・勝率を直感的なグラフで可視化します。',
            ),
            SizedBox(height: 14),
            _FeatureTile(
              icon: '📱',
              title: 'ブラウザで即座に開始',
              description: 'アプリのインストール不要。スマホやPCからURL共有ですぐ卓に参加可能。',
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 右ペイン：アカウント作成・ログインカード
// -----------------------------------------------------------------------------
class _RightPane extends StatelessWidget {
  const _RightPane();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.accentGold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ヘッダー部分
              const Column(
                children: [
                  Text(
                    '天棒 をはじめる',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'アカウントを作成またはログインして対局を開始',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 新規アカウント登録ボタン
              Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGold, Color(0xFFD35400)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4DF39C12),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '⚡ 新規アカウント登録 (無料)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              // 仕切り線
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'または',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),

              // ログインボタン
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.inputBg,
                    side: const BorderSide(
                      color: AppColors.cardBorder,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 利用規約の注記
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    '登録することで',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '利用規約',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.accentGoldLight,
                      ),
                    ),
                  ),
                  const Text(
                    'および',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'プライバシーポリシー',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.accentGoldLight,
                      ),
                    ),
                  ),
                  const Text(
                    'に同意したものとみなされます。',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// フッター
// -----------------------------------------------------------------------------
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.bg.withValues(alpha: 0.98),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 12,
            children: [
              const Text(
                '© 2026 天棒 All rights reserved.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _footerLink('利用規約', () {}),
                  const SizedBox(width: 20),
                  _footerLink('プライバシーポリシー', () {}),
                  const SizedBox(width: 20),
                  _footerLink('ログイン', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }
}