import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'screens/main_shell.dart';

void main() => runApp(const CatatKeuanganmuApp());

class CatatKeuanganmuApp extends StatelessWidget {
  const CatatKeuanganmuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catat Keuanganmu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kViolet,
        scaffoldBackgroundColor: kBg,
      ),
      home: const MainShell(),
    );
  }
}