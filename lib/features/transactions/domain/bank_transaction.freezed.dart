// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BankTransaction {

 String get id; String get reference; TxnDirection get direction; TxnCategory get category; TxnStatus get status; Money get amount; Money get fee; String get narration; String get counterpartyName; String? get counterpartyAccount; String? get counterpartyBank; DateTime get createdAt;
/// Create a copy of BankTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankTransactionCopyWith<BankTransaction> get copyWith => _$BankTransactionCopyWithImpl<BankTransaction>(this as BankTransaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BankTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.fee, _this.fee) || other.fee == _this.fee)&&(identical(other.narration, _this.narration) || other.narration == _this.narration)&&(identical(other.counterpartyName, _this.counterpartyName) || other.counterpartyName == _this.counterpartyName)&&(identical(other.counterpartyAccount, _this.counterpartyAccount) || other.counterpartyAccount == _this.counterpartyAccount)&&(identical(other.counterpartyBank, _this.counterpartyBank) || other.counterpartyBank == _this.counterpartyBank)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as BankTransaction;
  return Object.hash(runtimeType,_this.id,_this.reference,_this.direction,_this.category,_this.status,_this.amount,_this.fee,_this.narration,_this.counterpartyName,_this.counterpartyAccount,_this.counterpartyBank,_this.createdAt);
}

@override
String toString() {
  final _this = this as BankTransaction;
  return 'BankTransaction(id: ${_this.id}, reference: ${_this.reference}, direction: ${_this.direction}, category: ${_this.category}, status: ${_this.status}, amount: ${_this.amount}, fee: ${_this.fee}, narration: ${_this.narration}, counterpartyName: ${_this.counterpartyName}, counterpartyAccount: ${_this.counterpartyAccount}, counterpartyBank: ${_this.counterpartyBank}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BankTransactionCopyWith<$Res>  {
  factory $BankTransactionCopyWith(BankTransaction value, $Res Function(BankTransaction) _then) = _$BankTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String reference, TxnDirection direction, TxnCategory category, TxnStatus status, Money amount, Money fee, String narration, String counterpartyName, String? counterpartyAccount, String? counterpartyBank, DateTime createdAt
});




}
/// @nodoc
class _$BankTransactionCopyWithImpl<$Res>
    implements $BankTransactionCopyWith<$Res> {
  _$BankTransactionCopyWithImpl(this._self, this._then);

  final BankTransaction _self;
  final $Res Function(BankTransaction) _then;

/// Create a copy of BankTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reference = null,Object? direction = null,Object? category = null,Object? status = null,Object? amount = null,Object? fee = null,Object? narration = null,Object? counterpartyName = null,Object? counterpartyAccount = freezed,Object? counterpartyBank = freezed,Object? createdAt = null,}) {
  return _then(BankTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TxnDirection,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TxnCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TxnStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as Money,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,counterpartyName: null == counterpartyName ? _self.counterpartyName : counterpartyName // ignore: cast_nullable_to_non_nullable
as String,counterpartyAccount: freezed == counterpartyAccount ? _self.counterpartyAccount : counterpartyAccount // ignore: cast_nullable_to_non_nullable
as String?,counterpartyBank: freezed == counterpartyBank ? _self.counterpartyBank : counterpartyBank // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BankTransaction].
extension BankTransactionPatterns on BankTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankTransaction value)  $default,){
final _that = this;
switch (_that) {
case _BankTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _BankTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reference,  TxnDirection direction,  TxnCategory category,  TxnStatus status,  Money amount,  Money fee,  String narration,  String counterpartyName,  String? counterpartyAccount,  String? counterpartyBank,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankTransaction() when $default != null:
return $default(_that.id,_that.reference,_that.direction,_that.category,_that.status,_that.amount,_that.fee,_that.narration,_that.counterpartyName,_that.counterpartyAccount,_that.counterpartyBank,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reference,  TxnDirection direction,  TxnCategory category,  TxnStatus status,  Money amount,  Money fee,  String narration,  String counterpartyName,  String? counterpartyAccount,  String? counterpartyBank,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BankTransaction():
return $default(_that.id,_that.reference,_that.direction,_that.category,_that.status,_that.amount,_that.fee,_that.narration,_that.counterpartyName,_that.counterpartyAccount,_that.counterpartyBank,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reference,  TxnDirection direction,  TxnCategory category,  TxnStatus status,  Money amount,  Money fee,  String narration,  String counterpartyName,  String? counterpartyAccount,  String? counterpartyBank,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BankTransaction() when $default != null:
return $default(_that.id,_that.reference,_that.direction,_that.category,_that.status,_that.amount,_that.fee,_that.narration,_that.counterpartyName,_that.counterpartyAccount,_that.counterpartyBank,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BankTransaction extends BankTransaction {
  const _BankTransaction({required this.id, required this.reference, required this.direction, required this.category, required this.status, required this.amount, this.fee = const Money.zero(), this.narration = '', required this.counterpartyName, this.counterpartyAccount, this.counterpartyBank, required this.createdAt}): super._();
  

@override final  String id;
@override final  String reference;
@override final  TxnDirection direction;
@override final  TxnCategory category;
@override final  TxnStatus status;
@override final  Money amount;
@override@JsonKey() final  Money fee;
@override@JsonKey() final  String narration;
@override final  String counterpartyName;
@override final  String? counterpartyAccount;
@override final  String? counterpartyBank;
@override final  DateTime createdAt;

/// Create a copy of BankTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankTransactionCopyWith<_BankTransaction> get copyWith => __$BankTransactionCopyWithImpl<_BankTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.counterpartyName, counterpartyName) || other.counterpartyName == counterpartyName)&&(identical(other.counterpartyAccount, counterpartyAccount) || other.counterpartyAccount == counterpartyAccount)&&(identical(other.counterpartyBank, counterpartyBank) || other.counterpartyBank == counterpartyBank)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,reference,direction,category,status,amount,fee,narration,counterpartyName,counterpartyAccount,counterpartyBank,createdAt);
}

@override
String toString() {
    return 'BankTransaction(id: $id, reference: $reference, direction: $direction, category: $category, status: $status, amount: $amount, fee: $fee, narration: $narration, counterpartyName: $counterpartyName, counterpartyAccount: $counterpartyAccount, counterpartyBank: $counterpartyBank, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BankTransactionCopyWith<$Res> implements $BankTransactionCopyWith<$Res> {
  factory _$BankTransactionCopyWith(_BankTransaction value, $Res Function(_BankTransaction) _then) = __$BankTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String reference, TxnDirection direction, TxnCategory category, TxnStatus status, Money amount, Money fee, String narration, String counterpartyName, String? counterpartyAccount, String? counterpartyBank, DateTime createdAt
});




}
/// @nodoc
class __$BankTransactionCopyWithImpl<$Res>
    implements _$BankTransactionCopyWith<$Res> {
  __$BankTransactionCopyWithImpl(this._self, this._then);

  final _BankTransaction _self;
  final $Res Function(_BankTransaction) _then;

/// Create a copy of BankTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reference = null,Object? direction = null,Object? category = null,Object? status = null,Object? amount = null,Object? fee = null,Object? narration = null,Object? counterpartyName = null,Object? counterpartyAccount = freezed,Object? counterpartyBank = freezed,Object? createdAt = null,}) {
  return _then(_BankTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TxnDirection,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TxnCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TxnStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as Money,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,counterpartyName: null == counterpartyName ? _self.counterpartyName : counterpartyName // ignore: cast_nullable_to_non_nullable
as String,counterpartyAccount: freezed == counterpartyAccount ? _self.counterpartyAccount : counterpartyAccount // ignore: cast_nullable_to_non_nullable
as String?,counterpartyBank: freezed == counterpartyBank ? _self.counterpartyBank : counterpartyBank // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
