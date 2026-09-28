// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mortgage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Mortgage {

 String get id; MortgageProduct get product; String get propertyName; String get propertyLocation; Money get principal; int get tenorMonths; DateTime get firstDueDate; int get installmentsPaid;
/// Create a copy of Mortgage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MortgageCopyWith<Mortgage> get copyWith => _$MortgageCopyWithImpl<Mortgage>(this as Mortgage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Mortgage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mortgage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.propertyName, _this.propertyName) || other.propertyName == _this.propertyName)&&(identical(other.propertyLocation, _this.propertyLocation) || other.propertyLocation == _this.propertyLocation)&&(identical(other.principal, _this.principal) || other.principal == _this.principal)&&(identical(other.tenorMonths, _this.tenorMonths) || other.tenorMonths == _this.tenorMonths)&&(identical(other.firstDueDate, _this.firstDueDate) || other.firstDueDate == _this.firstDueDate)&&(identical(other.installmentsPaid, _this.installmentsPaid) || other.installmentsPaid == _this.installmentsPaid));
}


@override
int get hashCode {
  final _this = this as Mortgage;
  return Object.hash(runtimeType,_this.id,_this.product,_this.propertyName,_this.propertyLocation,_this.principal,_this.tenorMonths,_this.firstDueDate,_this.installmentsPaid);
}

@override
String toString() {
  final _this = this as Mortgage;
  return 'Mortgage(id: ${_this.id}, product: ${_this.product}, propertyName: ${_this.propertyName}, propertyLocation: ${_this.propertyLocation}, principal: ${_this.principal}, tenorMonths: ${_this.tenorMonths}, firstDueDate: ${_this.firstDueDate}, installmentsPaid: ${_this.installmentsPaid})';
}


}

/// @nodoc
abstract mixin class $MortgageCopyWith<$Res>  {
  factory $MortgageCopyWith(Mortgage value, $Res Function(Mortgage) _then) = _$MortgageCopyWithImpl;
@useResult
$Res call({
 String id, MortgageProduct product, String propertyName, String propertyLocation, Money principal, int tenorMonths, DateTime firstDueDate, int installmentsPaid
});




}
/// @nodoc
class _$MortgageCopyWithImpl<$Res>
    implements $MortgageCopyWith<$Res> {
  _$MortgageCopyWithImpl(this._self, this._then);

  final Mortgage _self;
  final $Res Function(Mortgage) _then;

/// Create a copy of Mortgage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? product = null,Object? propertyName = null,Object? propertyLocation = null,Object? principal = null,Object? tenorMonths = null,Object? firstDueDate = null,Object? installmentsPaid = null,}) {
  return _then(Mortgage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as MortgageProduct,propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,propertyLocation: null == propertyLocation ? _self.propertyLocation : propertyLocation // ignore: cast_nullable_to_non_nullable
as String,principal: null == principal ? _self.principal : principal // ignore: cast_nullable_to_non_nullable
as Money,tenorMonths: null == tenorMonths ? _self.tenorMonths : tenorMonths // ignore: cast_nullable_to_non_nullable
as int,firstDueDate: null == firstDueDate ? _self.firstDueDate : firstDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,installmentsPaid: null == installmentsPaid ? _self.installmentsPaid : installmentsPaid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Mortgage].
extension MortgagePatterns on Mortgage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mortgage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mortgage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mortgage value)  $default,){
final _that = this;
switch (_that) {
case _Mortgage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mortgage value)?  $default,){
final _that = this;
switch (_that) {
case _Mortgage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MortgageProduct product,  String propertyName,  String propertyLocation,  Money principal,  int tenorMonths,  DateTime firstDueDate,  int installmentsPaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mortgage() when $default != null:
return $default(_that.id,_that.product,_that.propertyName,_that.propertyLocation,_that.principal,_that.tenorMonths,_that.firstDueDate,_that.installmentsPaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MortgageProduct product,  String propertyName,  String propertyLocation,  Money principal,  int tenorMonths,  DateTime firstDueDate,  int installmentsPaid)  $default,) {final _that = this;
switch (_that) {
case _Mortgage():
return $default(_that.id,_that.product,_that.propertyName,_that.propertyLocation,_that.principal,_that.tenorMonths,_that.firstDueDate,_that.installmentsPaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MortgageProduct product,  String propertyName,  String propertyLocation,  Money principal,  int tenorMonths,  DateTime firstDueDate,  int installmentsPaid)?  $default,) {final _that = this;
switch (_that) {
case _Mortgage() when $default != null:
return $default(_that.id,_that.product,_that.propertyName,_that.propertyLocation,_that.principal,_that.tenorMonths,_that.firstDueDate,_that.installmentsPaid);case _:
  return null;

}
}

}

/// @nodoc


class _Mortgage extends Mortgage {
  const _Mortgage({required this.id, required this.product, required this.propertyName, required this.propertyLocation, required this.principal, required this.tenorMonths, required this.firstDueDate, required this.installmentsPaid}): super._();
  

@override final  String id;
@override final  MortgageProduct product;
@override final  String propertyName;
@override final  String propertyLocation;
@override final  Money principal;
@override final  int tenorMonths;
@override final  DateTime firstDueDate;
@override final  int installmentsPaid;

/// Create a copy of Mortgage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MortgageCopyWith<_Mortgage> get copyWith => __$MortgageCopyWithImpl<_Mortgage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mortgage&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.propertyName, propertyName) || other.propertyName == propertyName)&&(identical(other.propertyLocation, propertyLocation) || other.propertyLocation == propertyLocation)&&(identical(other.principal, principal) || other.principal == principal)&&(identical(other.tenorMonths, tenorMonths) || other.tenorMonths == tenorMonths)&&(identical(other.firstDueDate, firstDueDate) || other.firstDueDate == firstDueDate)&&(identical(other.installmentsPaid, installmentsPaid) || other.installmentsPaid == installmentsPaid));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,product,propertyName,propertyLocation,principal,tenorMonths,firstDueDate,installmentsPaid);
}

@override
String toString() {
    return 'Mortgage(id: $id, product: $product, propertyName: $propertyName, propertyLocation: $propertyLocation, principal: $principal, tenorMonths: $tenorMonths, firstDueDate: $firstDueDate, installmentsPaid: $installmentsPaid)';
}


}

/// @nodoc
abstract mixin class _$MortgageCopyWith<$Res> implements $MortgageCopyWith<$Res> {
  factory _$MortgageCopyWith(_Mortgage value, $Res Function(_Mortgage) _then) = __$MortgageCopyWithImpl;
@override @useResult
$Res call({
 String id, MortgageProduct product, String propertyName, String propertyLocation, Money principal, int tenorMonths, DateTime firstDueDate, int installmentsPaid
});




}
/// @nodoc
class __$MortgageCopyWithImpl<$Res>
    implements _$MortgageCopyWith<$Res> {
  __$MortgageCopyWithImpl(this._self, this._then);

  final _Mortgage _self;
  final $Res Function(_Mortgage) _then;

/// Create a copy of Mortgage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? product = null,Object? propertyName = null,Object? propertyLocation = null,Object? principal = null,Object? tenorMonths = null,Object? firstDueDate = null,Object? installmentsPaid = null,}) {
  return _then(_Mortgage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as MortgageProduct,propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,propertyLocation: null == propertyLocation ? _self.propertyLocation : propertyLocation // ignore: cast_nullable_to_non_nullable
as String,principal: null == principal ? _self.principal : principal // ignore: cast_nullable_to_non_nullable
as Money,tenorMonths: null == tenorMonths ? _self.tenorMonths : tenorMonths // ignore: cast_nullable_to_non_nullable
as int,firstDueDate: null == firstDueDate ? _self.firstDueDate : firstDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,installmentsPaid: null == installmentsPaid ? _self.installmentsPaid : installmentsPaid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MortgageApplication {

 String get id; MortgageProduct get product; Money get amount; int get tenorMonths; String get property; Money get monthlyIncome; DateTime get submittedAt;
/// Create a copy of MortgageApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MortgageApplicationCopyWith<MortgageApplication> get copyWith => _$MortgageApplicationCopyWithImpl<MortgageApplication>(this as MortgageApplication, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MortgageApplication;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MortgageApplication&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.tenorMonths, _this.tenorMonths) || other.tenorMonths == _this.tenorMonths)&&(identical(other.property, _this.property) || other.property == _this.property)&&(identical(other.monthlyIncome, _this.monthlyIncome) || other.monthlyIncome == _this.monthlyIncome)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt));
}


@override
int get hashCode {
  final _this = this as MortgageApplication;
  return Object.hash(runtimeType,_this.id,_this.product,_this.amount,_this.tenorMonths,_this.property,_this.monthlyIncome,_this.submittedAt);
}

@override
String toString() {
  final _this = this as MortgageApplication;
  return 'MortgageApplication(id: ${_this.id}, product: ${_this.product}, amount: ${_this.amount}, tenorMonths: ${_this.tenorMonths}, property: ${_this.property}, monthlyIncome: ${_this.monthlyIncome}, submittedAt: ${_this.submittedAt})';
}


}

/// @nodoc
abstract mixin class $MortgageApplicationCopyWith<$Res>  {
  factory $MortgageApplicationCopyWith(MortgageApplication value, $Res Function(MortgageApplication) _then) = _$MortgageApplicationCopyWithImpl;
@useResult
$Res call({
 String id, MortgageProduct product, Money amount, int tenorMonths, String property, Money monthlyIncome, DateTime submittedAt
});




}
/// @nodoc
class _$MortgageApplicationCopyWithImpl<$Res>
    implements $MortgageApplicationCopyWith<$Res> {
  _$MortgageApplicationCopyWithImpl(this._self, this._then);

  final MortgageApplication _self;
  final $Res Function(MortgageApplication) _then;

/// Create a copy of MortgageApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? product = null,Object? amount = null,Object? tenorMonths = null,Object? property = null,Object? monthlyIncome = null,Object? submittedAt = null,}) {
  return _then(MortgageApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as MortgageProduct,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,tenorMonths: null == tenorMonths ? _self.tenorMonths : tenorMonths // ignore: cast_nullable_to_non_nullable
as int,property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,monthlyIncome: null == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as Money,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MortgageApplication].
extension MortgageApplicationPatterns on MortgageApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MortgageApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MortgageApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MortgageApplication value)  $default,){
final _that = this;
switch (_that) {
case _MortgageApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MortgageApplication value)?  $default,){
final _that = this;
switch (_that) {
case _MortgageApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MortgageProduct product,  Money amount,  int tenorMonths,  String property,  Money monthlyIncome,  DateTime submittedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MortgageApplication() when $default != null:
return $default(_that.id,_that.product,_that.amount,_that.tenorMonths,_that.property,_that.monthlyIncome,_that.submittedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MortgageProduct product,  Money amount,  int tenorMonths,  String property,  Money monthlyIncome,  DateTime submittedAt)  $default,) {final _that = this;
switch (_that) {
case _MortgageApplication():
return $default(_that.id,_that.product,_that.amount,_that.tenorMonths,_that.property,_that.monthlyIncome,_that.submittedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MortgageProduct product,  Money amount,  int tenorMonths,  String property,  Money monthlyIncome,  DateTime submittedAt)?  $default,) {final _that = this;
switch (_that) {
case _MortgageApplication() when $default != null:
return $default(_that.id,_that.product,_that.amount,_that.tenorMonths,_that.property,_that.monthlyIncome,_that.submittedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MortgageApplication extends MortgageApplication {
  const _MortgageApplication({required this.id, required this.product, required this.amount, required this.tenorMonths, required this.property, required this.monthlyIncome, required this.submittedAt}): super._();
  

@override final  String id;
@override final  MortgageProduct product;
@override final  Money amount;
@override final  int tenorMonths;
@override final  String property;
@override final  Money monthlyIncome;
@override final  DateTime submittedAt;

/// Create a copy of MortgageApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MortgageApplicationCopyWith<_MortgageApplication> get copyWith => __$MortgageApplicationCopyWithImpl<_MortgageApplication>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MortgageApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.tenorMonths, tenorMonths) || other.tenorMonths == tenorMonths)&&(identical(other.property, property) || other.property == property)&&(identical(other.monthlyIncome, monthlyIncome) || other.monthlyIncome == monthlyIncome)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,product,amount,tenorMonths,property,monthlyIncome,submittedAt);
}

@override
String toString() {
    return 'MortgageApplication(id: $id, product: $product, amount: $amount, tenorMonths: $tenorMonths, property: $property, monthlyIncome: $monthlyIncome, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class _$MortgageApplicationCopyWith<$Res> implements $MortgageApplicationCopyWith<$Res> {
  factory _$MortgageApplicationCopyWith(_MortgageApplication value, $Res Function(_MortgageApplication) _then) = __$MortgageApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, MortgageProduct product, Money amount, int tenorMonths, String property, Money monthlyIncome, DateTime submittedAt
});




}
/// @nodoc
class __$MortgageApplicationCopyWithImpl<$Res>
    implements _$MortgageApplicationCopyWith<$Res> {
  __$MortgageApplicationCopyWithImpl(this._self, this._then);

  final _MortgageApplication _self;
  final $Res Function(_MortgageApplication) _then;

/// Create a copy of MortgageApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? product = null,Object? amount = null,Object? tenorMonths = null,Object? property = null,Object? monthlyIncome = null,Object? submittedAt = null,}) {
  return _then(_MortgageApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as MortgageProduct,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,tenorMonths: null == tenorMonths ? _self.tenorMonths : tenorMonths // ignore: cast_nullable_to_non_nullable
as int,property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,monthlyIncome: null == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as Money,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
