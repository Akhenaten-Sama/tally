import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/brand/brand.dart';
import '../../../core/money/money.dart';
import '../../account/domain/account.dart';
import '../../profile/domain/customer_profile.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../domain/statement.dart';

final _date = DateFormat('d MMM yyyy');
final _dateTime = DateFormat('d MMM yyyy, HH:mm');

/// Renders a bank statement PDF. Amounts are printed without the ₦ sign
/// (the standard PDF fonts don't include it) under an "NGN" heading, as
/// Nigerian bank statements commonly do.
Future<Uint8List> buildStatementPdf({
  required Statement statement,
  required Account account,
  CustomerProfile? profile,
}) async {
  final brand = Brand.current;
  final primary = PdfColor.fromInt(brand.primary.toARGB32());
  final muted = const PdfColor.fromInt(0xFF5E6B63);
  final logoAsset = brand.logoAsset;
  final logo = logoAsset == null
      ? null
      : pw.MemoryImage((await rootBundle.load(logoAsset)).buffer.asUint8List());

  String amount(Money m) => m.format().replaceFirst('₦', '');

  final doc = pw.Document(
    title: '${brand.shortName} statement',
    author: brand.name,
  );

  pw.Widget labelValue(String label, String value, {bool bold = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 95,
              child: pw.Text(
                label,
                style: pw.TextStyle(color: muted, fontSize: 9),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: bold ? pw.FontWeight.bold : null,
                ),
              ),
            ),
          ],
        ),
      );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 42),
      header: (context) => context.pageNumber == 1
          ? pw.SizedBox()
          : pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Text(
                '${brand.name} · Account ${account.accountNumber} · '
                '${_date.format(statement.from)} - ${_date.format(statement.to)}',
                style: pw.TextStyle(color: muted, fontSize: 8),
              ),
            ),
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated ${_dateTime.format(DateTime.now())}',
            style: pw.TextStyle(color: muted, fontSize: 8),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(color: muted, fontSize: 8),
          ),
        ],
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (logo != null)
              pw.SizedBox(width: 64, height: 64, child: pw.Image(logo))
            else
              pw.Text(
                brand.shortName.toLowerCase(),
                style: pw.TextStyle(
                  color: primary,
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            pw.Spacer(),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Account statement',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: primary,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${_date.format(statement.from)} - '
                  '${_date.format(statement.to)}',
                  style: pw.TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 18),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  labelValue('Account name', account.holderName, bold: true),
                  labelValue('Account number', account.accountNumber),
                  labelValue('Account type', 'Savings · ${account.tier.label}'),
                  if (profile?.address != null)
                    labelValue('Address', profile!.address!),
                ],
              ),
            ),
            pw.SizedBox(width: 24),
            pw.Container(
              width: 200,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFF3F6F1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                children: [
                  labelValue('Opening balance', amount(statement.opening)),
                  labelValue('Money in', amount(statement.moneyIn)),
                  labelValue('Money out', amount(statement.moneyOut)),
                  pw.Divider(color: PdfColors.grey400, height: 8),
                  labelValue(
                    'Closing balance',
                    amount(statement.closing),
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 18),
        if (statement.lines.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Center(
              child: pw.Text(
                'No transactions in this period.',
                style: pw.TextStyle(color: muted),
              ),
            ),
          )
        else
          pw.TableHelper.fromTextArray(
            headers: [
              'Date',
              'Description',
              'Reference',
              'Debit (NGN)',
              'Credit (NGN)',
              'Balance (NGN)',
            ],
            data: [
              for (final line in statement.lines)
                [
                  _date.format(line.transaction.createdAt),
                  '${line.transaction.category.label}: '
                      '${line.transaction.counterpartyName}',
                  line.transaction.reference,
                  line.net.isNegative ? amount(line.net.abs) : '',
                  line.net.isNegative ? '' : amount(line.net),
                  amount(line.balance),
                ],
            ],
            headerStyle: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: pw.BoxDecoration(color: primary),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellHeight: 22,
            oddRowDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF6F8F4),
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(58),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FixedColumnWidth(62),
              4: const pw.FixedColumnWidth(62),
              5: const pw.FixedColumnWidth(70),
            },
            headerAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
            cellAlignments: {
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
            border: null,
          ),
        pw.SizedBox(height: 16),
        pw.Text(
          'All amounts are in Nigerian Naira (NGN). Please report any '
          'unrecognised transaction to ${brand.name} immediately.',
          style: pw.TextStyle(color: muted, fontSize: 8),
        ),
      ],
    ),
  );

  return doc.save();
}
