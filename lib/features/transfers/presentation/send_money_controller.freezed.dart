// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_money_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SendMoneyDraft {

 Bank? get bank; String get accountNumber;/// Set once name enquiry succeeds, or straight from a beneficiary.
 String? get accountName; AmountInput get amount; String get narration;/// Idempotency key. Created on the first send attempt and kept for
/// retries; cleared whenever the recipient or amount changes.
 String? get reference;
/// Create a copy of SendMoneyDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMoneyDraftCopyWith<SendMoneyDraft> get copyWith => _$SendMoneyDraftCopyWithImpl<SendMoneyDraft>(this as SendMoneyDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SendMoneyDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMoneyDraft&&(identical(other.bank, _this.bank) || other.bank == _this.bank)&&(identical(other.accountNumber, _this.accountNumber) || other.accountNumber == _this.accountNumber)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.narration, _this.narration) || other.narration == _this.narration)&&(identical(other.reference, _this.reference) || other.reference == _this.reference));
}


@override
int get hashCode {
  final _this = this as SendMoneyDraft;
  return Object.hash(runtimeType,_this.bank,_this.accountNumber,_this.accountName,_this.amount,_this.narration,_this.reference);
}

@override
String toString() {
  final _this = this as SendMoneyDraft;
  return 'SendMoneyDraft(bank: ${_this.bank}, accountNumber: ${_this.accountNumber}, accountName: ${_this.accountName}, amount: ${_this.amount}, narration: ${_this.narration}, reference: ${_this.reference})';
}


}

/// @nodoc
abstract mixin class $SendMoneyDraftCopyWith<$Res>  {
  factory $SendMoneyDraftCopyWith(SendMoneyDraft value, $Res Function(SendMoneyDraft) _then) = _$SendMoneyDraftCopyWithImpl;
@useResult
$Res call({
 Bank? bank, String accountNumber, String? accountName, AmountInput amount, String narration, String? reference
});




}
/// @nodoc
class _$SendMoneyDraftCopyWithImpl<$Res>
    implements $SendMoneyDraftCopyWith<$Res> {
  _$SendMoneyDraftCopyWithImpl(this._self, this._then);

  final SendMoneyDraft _self;
  final $Res Function(SendMoneyDraft) _then;

/// Create a copy of SendMoneyDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bank = freezed,Object? accountNumber = null,Object? accountName = freezed,Object? amount = null,Object? narration = null,Object? reference = freezed,}) {
  return _then(SendMoneyDraft(
bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank?,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as AmountInput,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendMoneyDraft].
extension SendMoneyDraftPatterns on SendMoneyDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMoneyDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMoneyDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMoneyDraft value)  $default,){
final _that = this;
switch (_that) {
case _SendMoneyDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMoneyDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SendMoneyDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Bank? bank,  String accountNumber,  String? accountName,  AmountInput amount,  String narration,  String? reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMoneyDraft() when $default != null:
return $default(_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration,_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Bank? bank,  String accountNumber,  String? accountName,  AmountInput amount,  String narration,  String? reference)  $default,) {final _that = this;
switch (_that) {
case _SendMoneyDraft():
return $default(_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration,_that.reference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Bank? bank,  String accountNumber,  String? accountName,  AmountInput amount,  String narration,  String? reference)?  $default,) {final _that = this;
switch (_that) {
case _SendMoneyDraft() when $default != null:
return $default(_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration,_that.reference);case _:
  return null;

}
}

}

/// @nodoc


class _SendMoneyDraft extends SendMoneyDraft {
  const _SendMoneyDraft({this.bank, this.accountNumber = '', this.accountName, this.amount = const AmountInput(), this.narration = '', this.reference}): super._();
  

@override final  Bank? bank;
@override@JsonKey() final  String accountNumber;
/// Set once name enquiry succeeds, or straight from a beneficiary.
@override final  String? accountName;
@override@JsonKey() final  AmountInput amount;
@override@JsonKey() final  String narration;
/// Idempotency key. Created on the first send attempt and kept for
/// retries; cleared whenever the recipient or amount changes.
@override final  String? reference;

/// Create a copy of SendMoneyDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMoneyDraftCopyWith<_SendMoneyDraft> get copyWith => __$SendMoneyDraftCopyWithImpl<_SendMoneyDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMoneyDraft&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.reference, reference) || other.reference == reference));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bank,accountNumber,accountName,amount,narration,reference);
}

@override
String toString() {
    return 'SendMoneyDraft(bank: $bank, accountNumber: $accountNumber, accountName: $accountName, amount: $amount, narration: $narration, reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$SendMoneyDraftCopyWith<$Res> implements $SendMoneyDraftCopyWith<$Res> {
  factory _$SendMoneyDraftCopyWith(_SendMoneyDraft value, $Res Function(_SendMoneyDraft) _then) = __$SendMoneyDraftCopyWithImpl;
@override @useResult
$Res call({
 Bank? bank, String accountNumber, String? accountName, AmountInput amount, String narration, String? reference
});




}
/// @nodoc
class __$SendMoneyDraftCopyWithImpl<$Res>
    implements _$SendMoneyDraftCopyWith<$Res> {
  __$SendMoneyDraftCopyWithImpl(this._self, this._then);

  final _SendMoneyDraft _self;
  final $Res Function(_SendMoneyDraft) _then;

/// Create a copy of SendMoneyDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bank = freezed,Object? accountNumber = null,Object? accountName = freezed,Object? amount = null,Object? narration = null,Object? reference = freezed,}) {
  return _then(_SendMoneyDraft(
bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank?,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as AmountInput,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
