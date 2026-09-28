// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferRequest {

/// Idempotency key, generated once when the user reaches the PIN step.
/// Retrying with the same reference never sends money twice.
 String get reference; Bank get bank; String get accountNumber; String get accountName; Money get amount; String get narration;
/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferRequestCopyWith<TransferRequest> get copyWith => _$TransferRequestCopyWithImpl<TransferRequest>(this as TransferRequest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransferRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferRequest&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.bank, _this.bank) || other.bank == _this.bank)&&(identical(other.accountNumber, _this.accountNumber) || other.accountNumber == _this.accountNumber)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.narration, _this.narration) || other.narration == _this.narration));
}


@override
int get hashCode {
  final _this = this as TransferRequest;
  return Object.hash(runtimeType,_this.reference,_this.bank,_this.accountNumber,_this.accountName,_this.amount,_this.narration);
}

@override
String toString() {
  final _this = this as TransferRequest;
  return 'TransferRequest(reference: ${_this.reference}, bank: ${_this.bank}, accountNumber: ${_this.accountNumber}, accountName: ${_this.accountName}, amount: ${_this.amount}, narration: ${_this.narration})';
}


}

/// @nodoc
abstract mixin class $TransferRequestCopyWith<$Res>  {
  factory $TransferRequestCopyWith(TransferRequest value, $Res Function(TransferRequest) _then) = _$TransferRequestCopyWithImpl;
@useResult
$Res call({
 String reference, Bank bank, String accountNumber, String accountName, Money amount, String narration
});




}
/// @nodoc
class _$TransferRequestCopyWithImpl<$Res>
    implements $TransferRequestCopyWith<$Res> {
  _$TransferRequestCopyWithImpl(this._self, this._then);

  final TransferRequest _self;
  final $Res Function(TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reference = null,Object? bank = null,Object? accountNumber = null,Object? accountName = null,Object? amount = null,Object? narration = null,}) {
  return _then(TransferRequest(
reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferRequest].
extension TransferRequestPatterns on TransferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reference,  Bank bank,  String accountNumber,  String accountName,  Money amount,  String narration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.reference,_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reference,  Bank bank,  String accountNumber,  String accountName,  Money amount,  String narration)  $default,) {final _that = this;
switch (_that) {
case _TransferRequest():
return $default(_that.reference,_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reference,  Bank bank,  String accountNumber,  String accountName,  Money amount,  String narration)?  $default,) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.reference,_that.bank,_that.accountNumber,_that.accountName,_that.amount,_that.narration);case _:
  return null;

}
}

}

/// @nodoc


class _TransferRequest implements TransferRequest {
  const _TransferRequest({required this.reference, required this.bank, required this.accountNumber, required this.accountName, required this.amount, this.narration = ''});
  

/// Idempotency key, generated once when the user reaches the PIN step.
/// Retrying with the same reference never sends money twice.
@override final  String reference;
@override final  Bank bank;
@override final  String accountNumber;
@override final  String accountName;
@override final  Money amount;
@override@JsonKey() final  String narration;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferRequestCopyWith<_TransferRequest> get copyWith => __$TransferRequestCopyWithImpl<_TransferRequest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferRequest&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.narration, narration) || other.narration == narration));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reference,bank,accountNumber,accountName,amount,narration);
}

@override
String toString() {
    return 'TransferRequest(reference: $reference, bank: $bank, accountNumber: $accountNumber, accountName: $accountName, amount: $amount, narration: $narration)';
}


}

/// @nodoc
abstract mixin class _$TransferRequestCopyWith<$Res> implements $TransferRequestCopyWith<$Res> {
  factory _$TransferRequestCopyWith(_TransferRequest value, $Res Function(_TransferRequest) _then) = __$TransferRequestCopyWithImpl;
@override @useResult
$Res call({
 String reference, Bank bank, String accountNumber, String accountName, Money amount, String narration
});




}
/// @nodoc
class __$TransferRequestCopyWithImpl<$Res>
    implements _$TransferRequestCopyWith<$Res> {
  __$TransferRequestCopyWithImpl(this._self, this._then);

  final _TransferRequest _self;
  final $Res Function(_TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reference = null,Object? bank = null,Object? accountNumber = null,Object? accountName = null,Object? amount = null,Object? narration = null,}) {
  return _then(_TransferRequest(
reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,narration: null == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Beneficiary {

 String get name; String get accountNumber; Bank get bank; DateTime get lastUsedAt;
/// Create a copy of Beneficiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeneficiaryCopyWith<Beneficiary> get copyWith => _$BeneficiaryCopyWithImpl<Beneficiary>(this as Beneficiary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Beneficiary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Beneficiary&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.accountNumber, _this.accountNumber) || other.accountNumber == _this.accountNumber)&&(identical(other.bank, _this.bank) || other.bank == _this.bank)&&(identical(other.lastUsedAt, _this.lastUsedAt) || other.lastUsedAt == _this.lastUsedAt));
}


@override
int get hashCode {
  final _this = this as Beneficiary;
  return Object.hash(runtimeType,_this.name,_this.accountNumber,_this.bank,_this.lastUsedAt);
}

@override
String toString() {
  final _this = this as Beneficiary;
  return 'Beneficiary(name: ${_this.name}, accountNumber: ${_this.accountNumber}, bank: ${_this.bank}, lastUsedAt: ${_this.lastUsedAt})';
}


}

/// @nodoc
abstract mixin class $BeneficiaryCopyWith<$Res>  {
  factory $BeneficiaryCopyWith(Beneficiary value, $Res Function(Beneficiary) _then) = _$BeneficiaryCopyWithImpl;
@useResult
$Res call({
 String name, String accountNumber, Bank bank, DateTime lastUsedAt
});




}
/// @nodoc
class _$BeneficiaryCopyWithImpl<$Res>
    implements $BeneficiaryCopyWith<$Res> {
  _$BeneficiaryCopyWithImpl(this._self, this._then);

  final Beneficiary _self;
  final $Res Function(Beneficiary) _then;

/// Create a copy of Beneficiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? accountNumber = null,Object? bank = null,Object? lastUsedAt = null,}) {
  return _then(Beneficiary(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Beneficiary].
extension BeneficiaryPatterns on Beneficiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Beneficiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Beneficiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Beneficiary value)  $default,){
final _that = this;
switch (_that) {
case _Beneficiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Beneficiary value)?  $default,){
final _that = this;
switch (_that) {
case _Beneficiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String accountNumber,  Bank bank,  DateTime lastUsedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Beneficiary() when $default != null:
return $default(_that.name,_that.accountNumber,_that.bank,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String accountNumber,  Bank bank,  DateTime lastUsedAt)  $default,) {final _that = this;
switch (_that) {
case _Beneficiary():
return $default(_that.name,_that.accountNumber,_that.bank,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String accountNumber,  Bank bank,  DateTime lastUsedAt)?  $default,) {final _that = this;
switch (_that) {
case _Beneficiary() when $default != null:
return $default(_that.name,_that.accountNumber,_that.bank,_that.lastUsedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Beneficiary implements Beneficiary {
  const _Beneficiary({required this.name, required this.accountNumber, required this.bank, required this.lastUsedAt});
  

@override final  String name;
@override final  String accountNumber;
@override final  Bank bank;
@override final  DateTime lastUsedAt;

/// Create a copy of Beneficiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeneficiaryCopyWith<_Beneficiary> get copyWith => __$BeneficiaryCopyWithImpl<_Beneficiary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Beneficiary&&(identical(other.name, name) || other.name == name)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,accountNumber,bank,lastUsedAt);
}

@override
String toString() {
    return 'Beneficiary(name: $name, accountNumber: $accountNumber, bank: $bank, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class _$BeneficiaryCopyWith<$Res> implements $BeneficiaryCopyWith<$Res> {
  factory _$BeneficiaryCopyWith(_Beneficiary value, $Res Function(_Beneficiary) _then) = __$BeneficiaryCopyWithImpl;
@override @useResult
$Res call({
 String name, String accountNumber, Bank bank, DateTime lastUsedAt
});




}
/// @nodoc
class __$BeneficiaryCopyWithImpl<$Res>
    implements _$BeneficiaryCopyWith<$Res> {
  __$BeneficiaryCopyWithImpl(this._self, this._then);

  final _Beneficiary _self;
  final $Res Function(_Beneficiary) _then;

/// Create a copy of Beneficiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? accountNumber = null,Object? bank = null,Object? lastUsedAt = null,}) {
  return _then(_Beneficiary(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as Bank,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
