import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const CatatKeuanganmuApp());

// ---------- Warna & data dasar ----------
const kViolet = Color(0xFF5B3DF5);
const kLime = Color(0xFFC8F53C);
const kCoral = Color(0xFFFF6B5B);
const kSky = Color(0xFF9ED8FF);
const kYellow = Color(0xFFFFD36B);
const kBg = Color(0xFFF5F2FF);
const kInk = Color(0xFF1B1740);
const kMuted = Color(0xFF5B5778);

const int kBudget = 1800000; // anggaran bulanan (contoh)

const Map<String, Color> kCategories = {
  'Makan': kLime,
  'Transport': kCoral,
  'Kuliah': kSky,
  'Hiburan': kYellow,
};

class Expense {
  Expense(this.name, this.category, this.amount, this.date);
  final String name;
  final String category;
  final int amount;
  final DateTime date;
}

// ---------- Fungsi bantu ----------
String rupiah(int n) {
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${n < 0 ? '-' : ''}Rp $b';
}

const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String dateLabel(DateTime d) {
  final now = DateTime.now();
  if (_sameDay(d, now)) return 'Hari ini';
  if (_sameDay(d, now.subtract(const Duration(days: 1)))) return 'Kemarin';
  return '${d.day} ${_bulan[d.month - 1]} ${d.year}';
}

BoxDecoration cardBox([Color c = Colors.white, double r = 22]) =>
    BoxDecoration(color: c, borderRadius: BorderRadius.circular(r));

// ---------- Aplikasi ----------
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
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Beranda'),
          NavigationDestination(
              icon: const Icon(Icons.add_circle_outline),
              selectedIcon: const Icon(Icons.add_circle, color: kInk),
              label: 'Catat'),
          const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: Colors.white),
              label: 'Riwayat'),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.sub, required this.title});
  final String sub;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(sub,
            style: const TextStyle(
                color: kMuted, fontSize: 13, fontWeight: FontWeight.w700)),
        Text(title,
            style: const TextStyle(
                color: kInk, fontSize: 26, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class ExpenseTile extends StatelessWidget {
  const ExpenseTile(this.e, {super.key, this.showDate = true});
  final Expense e;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: cardBox(kCategories[e.category] ?? kSky, 14),
        child: Text(e.category.substring(0, 2).toUpperCase(),
            style: const TextStyle(
                color: kInk, fontWeight: FontWeight.w800, fontSize: 14)),
      ),
      title: Text(e.name,
          style: const TextStyle(
              color: kInk, fontWeight: FontWeight.w700, fontSize: 15)),
      subtitle: Text(
          showDate ? '${e.category} · ${dateLabel(e.date)}' : e.category,
          style: const TextStyle(color: kMuted, fontSize: 12)),
      trailing: Text('−${rupiah(e.amount)}',
          style: const TextStyle(
              color: kInk, fontWeight: FontWeight.w800, fontSize: 15)),
    );
  }
}

// ---------- Screen 1: Beranda ----------
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.items});
  final List<Expense> items;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(0, (s, e) => s + e.amount);
    final perCat = <String, int>{};
    for (final e in items) {
      perCat[e.category] = (perCat[e.category] ?? 0) + e.amount;
    }

    return ListView(padding: const EdgeInsets.all(20), children: [
      const Header(sub: 'Halo, Abida', title: 'Catat Keuanganmu'),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: cardBox(kViolet, 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Pengeluaran bulan ini',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(rupiah(total),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (total / kBudget).clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: Colors.white24,
              color: kLime,
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Anggaran ${rupiah(kBudget)}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            Text('Sisa ${rupiah(kBudget - total)}',
                style: const TextStyle(
                    color: kLime, fontWeight: FontWeight.w700)),
          ]),
        ]),
      ),
      const SizedBox(height: 18),
      const Text('Per kategori',
          style: TextStyle(
              color: kInk, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Row(
        children: kCategories.entries.take(3).map((c) {
          final v = perCat[c.key] ?? 0;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(12),
              decoration: cardBox(Colors.white, 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.key,
                        style: const TextStyle(
                            color: kMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(rupiah(v),
                        style: const TextStyle(
                            color: kInk,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : v / total,
                        minHeight: 8,
                        backgroundColor: kBg,
                        color: c.value,
                      ),
                    ),
                  ]),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 18),
      const Text('Terakhir dicatat',
          style: TextStyle(
              color: kInk, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: cardBox(),
        child: Column(children: items.take(2).map((e) => ExpenseTile(e)).toList()),
      ),
    ]);
  }
}

// ---------- Screen 2: Catat Pengeluaran ----------
class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.remaining, required this.onSave});
  final int remaining;
  final void Function(Expense) onSave;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final amountC = TextEditingController();
  final nameC = TextEditingController();
  String category = 'Makan';
  DateTime date = DateTime.now();

  int get amount => int.tryParse(amountC.text) ?? 0;

  @override
  void dispose() {
    amountC.dispose();
    nameC.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => date = d);
  }

  void save() {
    if (amount == 0 || nameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi nominal dan nama dulu ya')));
      return;
    }
    widget.onSave(Expense(nameC.text.trim(), category, amount, date));
    amountC.clear();
    nameC.clear();
    setState(() => date = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Header(sub: 'Transaksi baru', title: 'Catat Pengeluaran'),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: cardBox(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nominal',
              style: TextStyle(
                  color: kMuted, fontSize: 13, fontWeight: FontWeight.w700)),
          TextField(
            controller: amountC,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
                color: kViolet, fontSize: 40, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(
                prefixText: 'Rp ', hintText: '0', border: InputBorder.none),
          ),
        ]),
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: kCategories.keys.map((k) {
          final on = k == category;
          return ChoiceChip(
            label: Text(k),
            selected: on,
            showCheckmark: false,
            selectedColor: kViolet,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: on ? Colors.white : kInk, fontWeight: FontWeight.w700),
            onSelected: (_) => setState(() => category = k),
          );
        }).toList(),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: nameC,
        decoration: InputDecoration(
          labelText: 'Nama pengeluaran',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        decoration: cardBox(Colors.white, 16),
        child: ListTile(
          onTap: pickDate,
          leading: const Icon(Icons.calendar_today, color: kViolet),
          title: Text(dateLabel(date),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: cardBox(kLime),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Sisa anggaran sekarang',
                style: TextStyle(
                    color: kInk, fontSize: 12, fontWeight: FontWeight.w700)),
            Text(rupiah(widget.remaining),
                style: const TextStyle(
                    color: kInk, fontSize: 15, fontWeight: FontWeight.w800)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('Setelah dicatat',
                style: TextStyle(
                    color: kInk, fontSize: 12, fontWeight: FontWeight.w700)),
            Text(rupiah(widget.remaining - amount),
                style: const TextStyle(
                    color: kInk, fontSize: 20, fontWeight: FontWeight.w800)),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: save,
          style: FilledButton.styleFrom(backgroundColor: kViolet),
          child: const Text('Simpan Pengeluaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ),
      ),
    ]);
  }
}

// ---------- Screen 3: Riwayat Transaksi ----------
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.items});
  final List<Expense> items;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final total = widget.items.fold<int>(0, (s, e) => s + e.amount);
    final shown = widget.items
        .where((e) => filter == 'Semua' || e.category == filter)
        .toList();

    final rows = <Widget>[];
    String? lastLabel;
    for (final e in shown) {
      final label = dateLabel(e.date);
      if (label != lastLabel) {
        rows.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 2),
          child: Text(label.toUpperCase(),
              style: const TextStyle(
                  color: kMuted, fontSize: 12, fontWeight: FontWeight.w800)),
        ));
        lastLabel = label;
      }
      rows.add(ExpenseTile(e, showDate: false));
    }

    return ListView(padding: const EdgeInsets.all(20), children: [
      const Header(sub: 'Semua catatan', title: 'Semua Transaksi'),
      Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: cardBox(kViolet, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Total keluar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              Text(rupiah(total),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: cardBox(kLime, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Transaksi',
                  style: TextStyle(
                      color: kInk, fontSize: 12, fontWeight: FontWeight.w700)),
              Text('${widget.items.length} catatan',
                  style: const TextStyle(
                      color: kInk, fontSize: 18, fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        children: ['Semua', ...kCategories.keys].map((k) {
          final on = k == filter;
          return ChoiceChip(
            label: Text(k),
            selected: on,
            showCheckmark: false,
            selectedColor: kViolet,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: on ? Colors.white : kInk, fontWeight: FontWeight.w700),
            onSelected: (_) => setState(() => filter = k),
          );
        }).toList(),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: cardBox(),
        child: rows.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Belum ada transaksi')))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
      ),
    ]);
  }
}