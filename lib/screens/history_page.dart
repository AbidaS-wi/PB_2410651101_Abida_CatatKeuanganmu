import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/helpers.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../widgets/header.dart';

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
        rows.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: kMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
        lastLabel = label;
      }
      rows.add(ExpenseTile(e, showDate: false));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Header(sub: 'Semua catatan', title: 'Semua Transaksi'),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: cardBox(kViolet, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total keluar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      rupiah(total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: cardBox(kLime, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaksi',
                      style: TextStyle(
                        color: kInk,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${widget.items.length} catatan',
                      style: const TextStyle(
                        color: kInk,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                color: on ? Colors.white : kInk,
                fontWeight: FontWeight.w700,
              ),
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
                  child: Center(child: Text('Belum ada transaksi')),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rows,
                ),
        ),
      ],
    );
  }
}