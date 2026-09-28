import '../../../core/errors/app_exception.dart';
import '../domain/bank.dart';

const firstNames = [
  'Chinedu',
  'Aisha',
  'Oluwaseun',
  'Ngozi',
  'Emeka',
  'Funmilayo',
  'Ibrahim',
  'Temitope',
  'Uchenna',
  'Zainab',
  'Babatunde',
  'Chiamaka',
  'Yusuf',
  'Adaeze',
  'Segun',
  'Halima',
  'Kelechi',
  'Folake',
  'Musa',
  'Ifeoma',
];

const lastNames = [
  'Okafor',
  'Bello',
  'Adeyemi',
  'Eze',
  'Mohammed',
  'Ogunleye',
  'Nwosu',
  'Abubakar',
  'Balogun',
  'Okonkwo',
  'Adebayo',
  'Umar',
  'Obi',
  'Lawal',
];

/// Stands in for NIP name enquiry. The same account number always resolves
/// to the same name, and about 1 in 13 numbers doesn't exist, so the
/// "account not found" state can be demoed.
String mockAccountName(Bank bank, String accountNumber) {
  var hash = 17;
  for (final unit in '${bank.code}$accountNumber'.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  if (hash % 13 == 0) throw const AccountNotFoundException();

  final first = firstNames[hash % firstNames.length];
  final last = lastNames[(hash ~/ 7) % lastNames.length];
  // NIBSS returns names in upper case, surname first.
  return '$last $first'.toUpperCase();
}

/// Namespace for biller lookups (meters, smartcards) in [mockAccountName].
const billerDirectory = Bank(code: 'BILLER', name: 'Billers');
