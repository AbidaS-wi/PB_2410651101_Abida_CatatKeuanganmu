import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../core/helpers.dart';
import '../models/expense.dart';
import '../widgets/header.dart';

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
        const SnackBar(content: Text('Isi nominal dan nama dulu ya')),
      );
      return;
    }
    widget.onSave(Expense(nameC.text.trim(), category, amount, date));
    amountC.clear();
    nameC.clear();
    setState(() => date = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Header(sub: 'Transaksi baru', title: 'Catat Pengeluaran'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardBox(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nominal',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextField(
                controller: amountC,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  color: kViolet,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  hintText: '0',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
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
                color: on ? Colors.white : kInk,
                fontWeight: FontWeight.w700,
              ),
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
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: cardBox(Colors.white, 16),
          child: ListTile(
            onTap: pickDate,
            leading: const Icon(Icons.calendar_today, color: kViolet),
            title: Text(
              dateLabel(date),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardBox(kLime),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sisa anggaran sekarang',
                    style: TextStyle(
                      color: kInk,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    rupiah(widget.remaining),
                    style: const TextStyle(
                      color: kInk,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Setelah dicatat',
                    style: TextStyle(
                      color: kInk,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    rupiah(widget.remaining - amount),
                    style: const TextStyle(
                      color: kInk,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: save,
            style: FilledButton.styleFrom(backgroundColor: kViolet),
            child: const Text(
              'Simpan Pengeluaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}