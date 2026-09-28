import 'package:flutter/material.dart';

import '../../../../core/theme/tally_colors.dart';
import '../../domain/bank.dart';

Future<Bank?> showBankPicker(BuildContext context, {Bank? selected}) =>
    showModalBottomSheet<Bank>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _BankPicker(selected: selected),
    );

class _BankPicker extends StatefulWidget {
  const _BankPicker({this.selected});

  final Bank? selected;

  @override
  State<_BankPicker> createState() => _BankPickerState();
}

class _BankPickerState extends State<_BankPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final banks = Bank.all
        .where((b) => b.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search banks',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (q) => setState(() => _query = q),
            ),
          ),
          Expanded(
            child: banks.isEmpty
                ? Center(
                    child: Text(
                      'No bank matches "$_query"',
                      style: TextStyle(color: context.tally.muted),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: banks.length,
                    itemBuilder: (context, i) {
                      final bank = banks[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: bank.isInternal
                              ? context.tally.card
                              : context.tally.border,
                          child: Text(
                            bank.name[0],
                            style: TextStyle(
                              color: bank.isInternal
                                  ? context.tally.accent
                                  : context.tally.debit,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        title: Text(bank.name),
                        subtitle: bank.isInternal
                            ? const Text('Free, instant transfers')
                            : null,
                        trailing: bank == widget.selected
                            ? const Icon(Icons.check_rounded)
                            : null,
                        onTap: () => Navigator.pop(context, bank),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
