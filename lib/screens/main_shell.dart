import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/expense.dart';
import 'add_page.dart';
import 'history_page.dart';
import 'home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final now = DateTime.now();
  late final List<Expense> items = [
    Expense('Nasi goreng kantin', 'Makan', 18000, now),
    Expense('Ojek ke kampus', 'Transport', 12000, now),
    Expense('Fotokopi modul', 'Kuliah', 9000, now.subtract(const Duration(days: 1))),
    Expense('Buku statistika', 'Kuliah', 85000, now.subtract(const Duration(days: 2))),
  ];

  int get total => items.fold(0, (s, e) => s + e.amount);

  void addExpense(Expense e) {
    setState(() {
      items.add(e);
      items.sort((a, b) => b.date.compareTo(a.date));
      tab = 2; // pindah ke Riwayat setelah menyimpan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: tab,
          children: [
            HomePage(items: items),
            AddPage(remaining: kBudget - total, onSave: addExpense),
            HistoryPage(items: items),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        backgroundColor: Colors.white,
        indicatorColor: tab == 1 ? kLime : kViolet,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle, color: kInk),
            label: 'Catat',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: Colors.white),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}