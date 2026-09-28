import '../../features/account/domain/account.dart';
import '../../features/mortgage/domain/mortgage.dart';
import '../../features/profile/domain/customer_profile.dart';
import '../../features/transactions/domain/bank_transaction.dart';
import '../../features/transfers/domain/bank.dart';
import '../../features/transfers/domain/transfer.dart';
import '../money/money.dart';
import 'database.dart';

extension AccountRowX on AccountRow {
  Account toDomain() => Account(
    id: id,
    holderName: holderName,
    accountNumber: accountNumber,
    balance: Money(balanceKobo),
    tier: KycTier.fromLevel(kycTier),
  );
}

extension TransactionRowX on TransactionRow {
  BankTransaction toDomain() => BankTransaction(
    id: id,
    reference: reference,
    direction: direction,
    category: category,
    status: status,
    amount: Money(amountKobo),
    fee: Money(feeKobo),
    narration: narration,
    counterpartyName: counterpartyName,
    counterpartyAccount: counterpartyAccount,
    counterpartyBank: counterpartyBank,
    createdAt: createdAt,
  );
}

extension BeneficiaryRowX on BeneficiaryRow {
  Beneficiary toDomain() => Beneficiary(
    name: name,
    accountNumber: accountNumber,
    bank: Bank.byCode(bankCode),
    lastUsedAt: lastUsedAt,
  );
}

extension MortgageRowX on MortgageRow {
  Mortgage toDomain() => Mortgage(
    id: id,
    product: product,
    propertyName: propertyName,
    propertyLocation: propertyLocation,
    principal: Money(principalKobo),
    tenorMonths: tenorMonths,
    firstDueDate: firstDueDate,
    installmentsPaid: installmentsPaid,
  );
}

extension MortgageApplicationRowX on MortgageApplicationRow {
  MortgageApplication toDomain() => MortgageApplication(
    id: id,
    product: product,
    amount: Money(amountKobo),
    tenorMonths: tenorMonths,
    property: property,
    monthlyIncome: Money(monthlyIncomeKobo),
    submittedAt: submittedAt,
  );
}

extension CustomerProfileRowX on CustomerProfileRow {
  CustomerProfile toDomain() => CustomerProfile(
    phone: phone,
    email: email,
    dateOfBirth: dateOfBirth,
    address: address,
    bvnLast4: bvnLast4,
    ninLast4: ninLast4,
    memberSince: memberSince,
  );
}
