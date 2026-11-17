import 'package:flutter/material.dart';

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