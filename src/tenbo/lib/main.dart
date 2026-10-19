import 'package:flutter/material.dart';
import 'package:tenbo/features/game_session/presentation/views/game_create.dart';
import 'package:tenbo/features/game_session/presentation/views/players_home.dart';
// 必要な画面ファイルをインポートしてください
// import 'features/game_session/presentation/views/game_lobby.dart';
// import 'features/game_session/presentation/views/game_create_view.dart'; // 実際のファイルパスに合わせて調整

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tenbo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF09170E),
      ),
      // アプリ起動時の初期ルート、または home を指定
      initialRoute: '/',
      routes: {
        '/': (context) => const PlayersHomeScreen(),
        '/game_create': (context) => const GameCreateScreen(), // ← ここにルートを追加
      },
    );
  }
}
