import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/brand/brand.dart';
import '../../../core/money/money.dart';
import '../../../core/utils/formatters.dart';
import '../../account/domain/account.dart';
import '../../profile/domain/customer_profile.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/statement.dart';

/// A statement in the bank's own printed layout: letterhead, "Customer
/// Account Details" panel, Tran Date / Narration / Debit / Credit / Balance
/// rows with fees on their own lines, and a totals row.
///
/// Amounts use "=N=" for the Naira sign, as the bank's statements do; the
/// standard PDF fonts have no ₦ glyph.
Future<Uint8List> buildClassicStatementPdf({
  required Statement statement,
  required Account account,
  required Letterhead letterhead,
  CustomerProfile? profile,
  Money? loanBalance,
  DateTime? printedAt,
}) async {
  final brand = Brand.current;
  final green = PdfColor.fromInt(brand.bright.toARGB32());
  final grey = const PdfColor.fromInt(0xFF555555);
  final panel = const PdfColor.fromInt(0xFFD5D5D5);
  final logoAsset = brand.logoAsset;
  final logo = logoAsset == null
      ? null
      : pw.MemoryImage((await rootBundle.load(logoAsset)).buffer.asUint8List());
  final serif = pw.Font.timesBold();
  final printed = printedAt ?? DateTime.now();
  final rows = _rows(statement, account);

  final debits = rows.fold(
    const Money.zero(),
    (s, r) => s + (r.debit ?? const Money.zero()),
  );
  final credits = rows.fold(
    const Money.zero(),
    (s, r) => s + (r.credit ?? const Money.zero()),
  );

  String plain(Money m) => m.format().replaceFirst('₦', '');
  String naira(Money m) => '=N=${plain(m)}';

  pw.Widget text(
    String value, {
    double size = 8.5,
    bool bold = false,
    PdfColor? color,
    pw.Font? font,
    pw.TextAlign? align,
  }) => pw.Text(
    value,
    textAlign: align,
    style: pw.TextStyle(
      fontSize: size,
      font: font,
      fontWeight: bold ? pw.FontWeight.bold : null,
      color: color,
    ),
  );

  pw.Widget letterheadBlock() => pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${letterhead.legalName} ',
                    style: pw.TextStyle(
                      color: green,
                      fontSize: 12.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: letterhead.rcNumber,
                    style: pw.TextStyle(
                      color: green,
                      fontSize: 6.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 2),
            text(letterhead.branch, bold: true, size: 9),
            for (final line in letterhead.addressLines) text(line, size: 8.5),
            text(letterhead.phone, size: 8.5),
            text(letterhead.website, size: 8.5),
            text(letterhead.email, size: 8.5),
          ],
        ),
      ),
      if (logo != null)
        pw.Column(
          children: [
            pw.SizedBox(width: 92, height: 72, child: pw.Image(logo)),
            text(letterhead.tagline, size: 6.5, font: pw.Font.timesItalic()),
          ],
        ),
      pw.SizedBox(width: 70),
    ],
  );

  pw.Widget titleBar() => pw.Column(
    children: [
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              height: 9,
              decoration: pw.BoxDecoration(
                color: panel,
                border: pw.Border.all(color: grey, width: 0.6),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6),
            child: text('Customer Account Details', size: 12, bold: true),
          ),
          pw.Expanded(
            child: pw.Container(
              height: 9,
              decoration: pw.BoxDecoration(
                color: panel,
                border: pw.Border.all(color: grey, width: 0.6),
              ),
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 6),
      pw.Text(
        'Between ${_long.format(statement.from)} And '
        '${_long.format(statement.to)}',
        style: const pw.TextStyle(
          fontSize: 9,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    ],
  );

  pw.Widget field(String label, String value, {double width = 76}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width: width,
              child: text(
                '$label :',
                size: 7.5,
                bold: true,
                align: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Expanded(child: text(value, size: 10.5, font: serif)),
          ],
        ),
      );

  pw.Widget detailsPanel() => pw.Container(
    padding: const pw.EdgeInsets.fromLTRB(6, 6, 6, 6),
    decoration: pw.BoxDecoration(
      color: panel,
      border: pw.Border.all(color: PdfColors.grey700, width: 1.2),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              field('Account Name', account.holderName.toUpperCase()),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 76,
                      child: text(
                        'Address :',
                        size: 7.5,
                        bold: true,
                        align: pw.TextAlign.right,
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Expanded(
                      child: text(
                        (profile?.address ?? '').toUpperCase(),
                        size: 7,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: field('Account No', account.accountNumber),
                  ),
                  pw.SizedBox(
                    width: 120,
                    child: field('NUBAN', account.accountNumber, width: 38),
                  ),
                ],
              ),
              field('Account Type', letterhead.accountType),
              field('Ledger Balance', naira(account.balance)),
              field('Cur. Balance', naira(account.balance)),
            ],
          ),
        ),
        pw.SizedBox(width: 8),
        pw.SizedBox(
          width: 104,
          child: pw.Column(
            children: [
              pw.SizedBox(height: 4),
              text('Customer Identity :', size: 7.5, bold: true),
              pw.SizedBox(height: 14),
              text('Loan Balance :', size: 7.5, bold: true),
              text(
                plain(loanBalance ?? const Money.zero()),
                size: 10.5,
                font: serif,
              ),
              pw.SizedBox(height: 8),
              text("Account's Officer :", size: 7.5, bold: true),
              text('DIGITAL BANKING', size: 7.5),
            ],
          ),
        ),
        // The branch prints the customer's passport photo here.
        pw.Container(
          width: 74,
          height: 86,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: PdfColors.grey500,
            border: pw.Border.all(color: PdfColors.grey700, width: 0.5),
          ),
          child: text(
            initials(account.holderName),
            size: 26,
            bold: true,
            color: PdfColors.white,
          ),
        ),
      ],
    ),
  );

  const dateWidth = 52.0;
  const amountWidth = 72.0;

  pw.Widget headerRow() => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
    child: pw.Row(
      children: [
        pw.SizedBox(
          width: dateWidth,
          child: text('Tran Date', bold: true, size: 7.5),
        ),
        pw.Expanded(
          child: text(
            'Narration',
            bold: true,
            size: 7.5,
            align: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(
          width: amountWidth,
          child: text(
            'Debit',
            bold: true,
            size: 7.5,
            align: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(
          width: amountWidth,
          child: text(
            'Credit',
            bold: true,
            size: 7.5,
            align: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(
          width: amountWidth,
          child: text(
            'Balance',
            bold: true,
            size: 7.5,
            align: pw.TextAlign.right,
          ),
        ),
      ],
    ),
  );

  pw.Widget dotted() => pw.Container(
    margin: const pw.EdgeInsets.only(left: dateWidth + 200),
    height: 0.6,
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColors.grey600,
          width: 0.6,
          style: pw.BorderStyle.dotted,
        ),
      ),
    ),
  );

  pw.Widget row(_Row r) => pw.Column(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 7),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width: dateWidth,
              child: text(_short(r.date), size: 7.5),
            ),
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(right: 12),
                child: text(r.narration, size: 7.5),
              ),
            ),
            pw.SizedBox(
              width: amountWidth,
              child: text(
                plain(r.debit ?? const Money.zero()),
                size: 7.5,
                bold: true,
                align: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(
              width: amountWidth,
              child: text(
                plain(r.credit ?? const Money.zero()),
                size: 7.5,
                align: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(
              width: amountWidth,
              child: text(
                plain(r.balance),
                size: 7.5,
                bold: true,
                align: pw.TextAlign.right,
              ),
            ),
          ],
        ),
      ),
      dotted(),
    ],
  );

  pw.Widget totals() => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(width: 1.4),
                bottom: pw.BorderSide(width: 1.4),
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                text('Accrued Int. On Overdraft : 0.00', size: 7.5, bold: true),
                pw.SizedBox(height: 6),
                text('Uncleared Effect : 0.00', size: 7.5, bold: true),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 24),
        pw.Container(
          width: amountWidth * 3,
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 1.4),
              bottom: pw.BorderSide(width: 2.4, style: pw.BorderStyle.solid),
            ),
          ),
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: amountWidth,
                child: text(
                  naira(debits),
                  size: 7.5,
                  bold: true,
                  align: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(
                width: amountWidth,
                child: text(
                  naira(credits),
                  size: 7.5,
                  bold: true,
                  align: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(
                width: amountWidth,
                child: text(
                  naira(statement.closing),
                  size: 7.5,
                  bold: true,
                  align: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  final doc = pw.Document(
    title: '${brand.shortName} statement ${account.accountNumber}',
    author: brand.name,
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 24, 28, 20),
      header: (context) => context.pageNumber == 1
          ? pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 14),
              child: letterheadBlock(),
            )
          : pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 14),
                child: logo == null
                    ? text(brand.name, bold: true, color: green, size: 12)
                    : pw.SizedBox(width: 74, height: 56, child: pw.Image(logo)),
              ),
            ),
      footer: (context) => pw.Column(
        children: [
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    text('Account : ${account.accountNumber}', size: 8),
                    pw.SizedBox(height: 8),
                    text(
                      '© ${brand.shortName} Digital Banking',
                      size: 8,
                      font: pw.Font.times(),
                    ),
                  ],
                ),
              ),
              pw.Column(
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        const pw.TextSpan(
                          text: 'Printed Today: ',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TextSpan(
                          text: '${_printed.format(printed)}.',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.RichText(
                    text: const pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: 'Printed By: ',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TextSpan(
                          text: 'MOBILE APP',
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Expanded(
                child: pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: text(
                    '${context.pageNumber} of ${context.pagesCount}',
                    size: 8,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          if (context.pageNumber == 1)
            text(letterhead.directors, size: 8, align: pw.TextAlign.center)
          else
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(left: 70),
                child: text(letterhead.website, size: 8, color: grey),
              ),
            ),
        ],
      ),
      build: (context) => [
        titleBar(),
        pw.SizedBox(height: 6),
        detailsPanel(),
        headerRow(),
        pw.Divider(height: 1, thickness: 0.6),
        for (final r in rows) row(r),
        totals(),
      ],
    ),
  );

  return doc.save();
}

class _Row {
  const _Row({
    required this.date,
    required this.narration,
    required this.balance,
    this.debit,
    this.credit,
  });

  final DateTime date;
  final String narration;
  final Money? debit;
  final Money? credit;
  final Money balance;
}

/// One row per money movement, with transfer fees on their own "FT charge."
/// line, starting from a "Balance Taken Forward" row.
List<_Row> _rows(Statement statement, Account account) {
  var balance = statement.opening;
  final rows = [
    _Row(
      date: statement.from,
      narration: 'Balance Taken Forward',
      debit: const Money.zero(),
      credit: const Money.zero(),
      balance: balance,
    ),
  ];
  for (final line in statement.lines) {
    final t = line.transaction;
    if (t.isCredit) {
      balance += t.amount;
      rows.add(
        _Row(
          date: t.createdAt,
          narration: _narration(t, account),
          credit: t.amount,
          debit: const Money.zero(),
          balance: balance,
        ),
      );
      continue;
    }
    balance -= t.amount;
    rows.add(
      _Row(
        date: t.createdAt,
        narration: _narration(t, account),
        debit: t.amount,
        credit: const Money.zero(),
        balance: balance,
      ),
    );
    if (!t.fee.isZero) {
      balance -= t.fee;
      rows.add(
        _Row(
          date: t.createdAt,
          narration: 'FT charge.',
          debit: t.fee,
          credit: const Money.zero(),
          balance: balance,
        ),
      );
    }
  }
  return rows;
}

/// Narrations in the bank's core-banking style.
String _narration(BankTransaction t, Account account) {
  final ref = t.reference.replaceAll('-', '');
  final name = t.counterpartyName.toUpperCase();
  final holder = account.holderName.toUpperCase();
  final acct = t.counterpartyAccount ?? '';
  final bank = (t.counterpartyBank ?? '').toUpperCase();
  final amount = t.amount.format().replaceFirst('₦', '').replaceAll(',', '');
  final note = t.narration.isEmpty ? '' : ' ${t.narration.toUpperCase()}';

  return switch (t.category) {
    TxnCategory.transfer when t.isCredit =>
      'MT FT-$ref FROM $name IFO ${account.accountNumber} $holder TRANSFER '
          'TRF Amount CR - (NGN$amount)$note',
    TxnCategory.transfer => 'FT-$ref/DB/IFO $name/$bank/$acct$note',
    TxnCategory.reversal => 'REVERSAL: ${t.narration.toUpperCase()} - $name',
    TxnCategory.airtime => 'AIRTIME/$name/$acct/$ref',
    TxnCategory.data => 'DATA/$name/${t.narration.toUpperCase()}/$acct/$ref',
    TxnCategory.electricity => 'ELECTRICITY/$name/METER $acct/$ref',
    TxnCategory.cable => 'CABLE TV/$name/IUC $acct/$ref',
    TxnCategory.mortgage =>
      'MORTGAGE REPAYMENT/${t.narration.toUpperCase()}/$bank/$ref',
    TxnCategory.interest => 'INTEREST CREDIT/$name',
    TxnCategory.savings => 'SAVINGS/$name/$ref',
  };
}

final _long = DateFormat('dd-MMM-yyyy');
final _printed = DateFormat('EEEE, MMMM d, yyyy');

/// "24-Sept-25", matching the bank's statements (September is "Sept").
String _short(DateTime d) {
  final month = d.month == 9 ? 'Sept' : DateFormat('MMM').format(d);
  return '${d.day.toString().padLeft(2, '0')}-$month-${DateFormat('yy').format(d)}';
}
