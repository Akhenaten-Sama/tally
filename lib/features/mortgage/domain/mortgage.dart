import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/money/money.dart';
import 'amortization.dart';

part 'mortgage.freezed.dart';

/// Cooperative Mortgage Bank's mortgage products. Rates and limits are
/// indicative placeholders for the concept demo.
enum MortgageProduct {
  nhf(
    name: 'Social Mortgage (NHF)',
    blurb:
        'Government-backed loans from the National Housing Fund at a fixed '
        'single-digit rate.',
    eligibility: 'NHF contributors for at least 6 months',
    rateBps: 600,
    maxYears: 30,
    maxAmount: Money(5000000000),
  ),
  cooperators(
    name: "Cooperators' Mortgage",
    blurb:
        'For members of registered cooperative societies, with the society '
        'as guarantor.',
    eligibility: 'Members of a partner cooperative society',
    rateBps: 1500,
    maxYears: 15,
    maxAmount: Money(5000000000),
  ),
  individual(
    name: 'Individual Mortgage',
    blurb: 'Buy, build or complete a home of your choice anywhere in Nigeria.',
    eligibility: 'Salaried or self-employed, 21–60 years old',
    rateBps: 1950,
    maxYears: 20,
    maxAmount: Money(10000000000),
  ),
  offshore(
    name: 'Offshore Mortgage (REDL)',
    blurb:
        'For Nigerians in the diaspora buying a home back home, repaid from '
        'abroad.',
    eligibility: 'Nigerians living and earning abroad',
    rateBps: 1400,
    maxYears: 15,
    maxAmount: Money(10000000000),
  );

  const MortgageProduct({
    required this.name,
    required this.blurb,
    required this.eligibility,
    required this.rateBps,
    required this.maxYears,
    required this.maxAmount,
  });

  final String name;
  final String blurb;
  final String eligibility;

  /// Annual rate in basis points: 600 = 6% p.a.
  final int rateBps;
  final int maxYears;
  final Money maxAmount;

  String get rateLabel =>
      '${(rateBps / 100).toStringAsFixed(rateBps % 100 == 0 ? 0 : 1)}% p.a.';
}

@freezed
abstract class Mortgage with _$Mortgage {
  const Mortgage._();

  const factory Mortgage({
    required String id,
    required MortgageProduct product,
    required String propertyName,
    required String propertyLocation,
    required Money principal,
    required int tenorMonths,
    required DateTime firstDueDate,
    required int installmentsPaid,
  }) = _Mortgage;

  List<Installment> get schedule => amortize(
    principal: principal,
    annualRateBps: product.rateBps,
    months: tenorMonths,
    firstDueDate: firstDueDate,
  );

  Money get monthlyPayment => monthlyRepayment(
    principal: principal,
    annualRateBps: product.rateBps,
    months: tenorMonths,
  );

  bool get isPaidOff => installmentsPaid >= tenorMonths;

  Installment? get nextInstallment =>
      isPaidOff ? null : schedule[installmentsPaid];

  Money get outstanding => installmentsPaid == 0
      ? principal
      : schedule[installmentsPaid - 1].balanceAfter;

  Money get principalRepaid => principal - outstanding;

  /// Share of the loan amount repaid so far, 0–1.
  double get progress => principalRepaid.kobo / principal.kobo;

  DateTime get maturityDate => addMonths(firstDueDate, tenorMonths - 1);
}

/// Where an application is. The demo moves through a stage every
/// [stageDuration] so the tracker can be shown live.
enum ApplicationStage {
  submitted('Application received', 'We have your details and documents.'),
  review('Under review', 'A mortgage officer is checking your eligibility.'),
  valuation('Property valuation', 'An approved valuer is inspecting the home.'),
  offer('Offer letter issued', 'Review and accept your offer in the app.'),
  disbursed('Funds disbursed', 'Congratulations on your new home!');

  const ApplicationStage(this.title, this.description);

  final String title;
  final String description;

  static const stageDuration = Duration(seconds: 45);
}

@freezed
abstract class MortgageApplication with _$MortgageApplication {
  const MortgageApplication._();

  const factory MortgageApplication({
    required String id,
    required MortgageProduct product,
    required Money amount,
    required int tenorMonths,
    required String property,
    required Money monthlyIncome,
    required DateTime submittedAt,
  }) = _MortgageApplication;

  Money get monthlyPayment => monthlyRepayment(
    principal: amount,
    annualRateBps: product.rateBps,
    months: tenorMonths,
  );

  ApplicationStage stageAt(DateTime now) {
    final steps =
        now.difference(submittedAt).inSeconds ~/
        ApplicationStage.stageDuration.inSeconds;
    return ApplicationStage.values[steps.clamp(
      0,
      ApplicationStage.values.length - 1,
    )];
  }
}
