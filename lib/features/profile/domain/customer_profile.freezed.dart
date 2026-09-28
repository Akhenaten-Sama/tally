// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerProfile {

 String get phone; String? get email; DateTime? get dateOfBirth; String? get address; String? get bvnLast4; String? get ninLast4; DateTime get memberSince;
/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerProfileCopyWith<CustomerProfile> get copyWith => _$CustomerProfileCopyWithImpl<CustomerProfile>(this as CustomerProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerProfile&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.bvnLast4, _this.bvnLast4) || other.bvnLast4 == _this.bvnLast4)&&(identical(other.ninLast4, _this.ninLast4) || other.ninLast4 == _this.ninLast4)&&(identical(other.memberSince, _this.memberSince) || other.memberSince == _this.memberSince));
}


@override
int get hashCode {
  final _this = this as CustomerProfile;
  return Object.hash(runtimeType,_this.phone,_this.email,_this.dateOfBirth,_this.address,_this.bvnLast4,_this.ninLast4,_this.memberSince);
}

@override
String toString() {
  final _this = this as CustomerProfile;
  return 'CustomerProfile(phone: ${_this.phone}, email: ${_this.email}, dateOfBirth: ${_this.dateOfBirth}, address: ${_this.address}, bvnLast4: ${_this.bvnLast4}, ninLast4: ${_this.ninLast4}, memberSince: ${_this.memberSince})';
}


}

/// @nodoc
abstract mixin class $CustomerProfileCopyWith<$Res>  {
  factory $CustomerProfileCopyWith(CustomerProfile value, $Res Function(CustomerProfile) _then) = _$CustomerProfileCopyWithImpl;
@useResult
$Res call({
 String phone, String? email, DateTime? dateOfBirth, String? address, String? bvnLast4, String? ninLast4, DateTime memberSince
});




}
/// @nodoc
class _$CustomerProfileCopyWithImpl<$Res>
    implements $CustomerProfileCopyWith<$Res> {
  _$CustomerProfileCopyWithImpl(this._self, this._then);

  final CustomerProfile _self;
  final $Res Function(CustomerProfile) _then;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? email = freezed,Object? dateOfBirth = freezed,Object? address = freezed,Object? bvnLast4 = freezed,Object? ninLast4 = freezed,Object? memberSince = null,}) {
  return _then(CustomerProfile(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bvnLast4: freezed == bvnLast4 ? _self.bvnLast4 : bvnLast4 // ignore: cast_nullable_to_non_nullable
as String?,ninLast4: freezed == ninLast4 ? _self.ninLast4 : ninLast4 // ignore: cast_nullable_to_non_nullable
as String?,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerProfile].
extension CustomerProfilePatterns on CustomerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerProfile value)  $default,){
final _that = this;
switch (_that) {
case _CustomerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String? email,  DateTime? dateOfBirth,  String? address,  String? bvnLast4,  String? ninLast4,  DateTime memberSince)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
return $default(_that.phone,_that.email,_that.dateOfBirth,_that.address,_that.bvnLast4,_that.ninLast4,_that.memberSince);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String? email,  DateTime? dateOfBirth,  String? address,  String? bvnLast4,  String? ninLast4,  DateTime memberSince)  $default,) {final _that = this;
switch (_that) {
case _CustomerProfile():
return $default(_that.phone,_that.email,_that.dateOfBirth,_that.address,_that.bvnLast4,_that.ninLast4,_that.memberSince);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String? email,  DateTime? dateOfBirth,  String? address,  String? bvnLast4,  String? ninLast4,  DateTime memberSince)?  $default,) {final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
return $default(_that.phone,_that.email,_that.dateOfBirth,_that.address,_that.bvnLast4,_that.ninLast4,_that.memberSince);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerProfile extends CustomerProfile {
  const _CustomerProfile({required this.phone, this.email, this.dateOfBirth, this.address, this.bvnLast4, this.ninLast4, required this.memberSince}): super._();
  

@override final  String phone;
@override final  String? email;
@override final  DateTime? dateOfBirth;
@override final  String? address;
@override final  String? bvnLast4;
@override final  String? ninLast4;
@override final  DateTime memberSince;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerProfileCopyWith<_CustomerProfile> get copyWith => __$CustomerProfileCopyWithImpl<_CustomerProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerProfile&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.address, address) || other.address == address)&&(identical(other.bvnLast4, bvnLast4) || other.bvnLast4 == bvnLast4)&&(identical(other.ninLast4, ninLast4) || other.ninLast4 == ninLast4)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,email,dateOfBirth,address,bvnLast4,ninLast4,memberSince);
}

@override
String toString() {
    return 'CustomerProfile(phone: $phone, email: $email, dateOfBirth: $dateOfBirth, address: $address, bvnLast4: $bvnLast4, ninLast4: $ninLast4, memberSince: $memberSince)';
}


}

/// @nodoc
abstract mixin class _$CustomerProfileCopyWith<$Res> implements $CustomerProfileCopyWith<$Res> {
  factory _$CustomerProfileCopyWith(_CustomerProfile value, $Res Function(_CustomerProfile) _then) = __$CustomerProfileCopyWithImpl;
@override @useResult
$Res call({
 String phone, String? email, DateTime? dateOfBirth, String? address, String? bvnLast4, String? ninLast4, DateTime memberSince
});




}
/// @nodoc
class __$CustomerProfileCopyWithImpl<$Res>
    implements _$CustomerProfileCopyWith<$Res> {
  __$CustomerProfileCopyWithImpl(this._self, this._then);

  final _CustomerProfile _self;
  final $Res Function(_CustomerProfile) _then;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? email = freezed,Object? dateOfBirth = freezed,Object? address = freezed,Object? bvnLast4 = freezed,Object? ninLast4 = freezed,Object? memberSince = null,}) {
  return _then(_CustomerProfile(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bvnLast4: freezed == bvnLast4 ? _self.bvnLast4 : bvnLast4 // ignore: cast_nullable_to_non_nullable
as String?,ninLast4: freezed == ninLast4 ? _self.ninLast4 : ninLast4 // ignore: cast_nullable_to_non_nullable
as String?,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
