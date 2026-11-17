import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/helpers.dart';
import '../models/expense.dart';

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
        child: Text(
          e.category.substring(0, 2).toUpperCase(),
          style: const TextStyle(
            color: kInk,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        e.name,
        style: const TextStyle(
          color: kInk,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        showDate ? '${e.category} · ${dateLabel(e.date)}' : e.category,
        style: const TextStyle(color: kMuted, fontSize: 12),
      ),
      trailing: Text(
        '−${rupiah(e.amount)}',
        style: const TextStyle(
          color: kInk,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    );
  }
}