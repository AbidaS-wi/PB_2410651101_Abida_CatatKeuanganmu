import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/helpers.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../widgets/header.dart';

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

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Header(sub: 'Halo, Abida', title: 'Catat Keuanganmu'),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: cardBox(kViolet, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengeluaran bulan ini',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                rupiah(total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anggaran ${rupiah(kBudget)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Sisa ${rupiah(kBudget - total)}',
                    style: const TextStyle(
                      color: kLime,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Per kategori',
          style: TextStyle(
            color: kInk,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
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
                    Text(
                      c.key,
                      style: const TextStyle(
                        color: kMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rupiah(v),
                      style: const TextStyle(
                        color: kInk,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        const Text(
          'Terakhir dicatat',
          style: TextStyle(
            color: kInk,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: cardBox(),
          child: Column(
            children: items.take(2).map((e) => ExpenseTile(e)).toList(),
          ),
        ),
      ],
    );
  }
}