// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingDraft {

 PhoneNumber? get phone; String get firstName; String get lastName; String? get passcode; String? get pin;
/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDraftCopyWith<OnboardingDraft> get copyWith => _$OnboardingDraftCopyWithImpl<OnboardingDraft>(this as OnboardingDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingDraft&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.passcode, _this.passcode) || other.passcode == _this.passcode)&&(identical(other.pin, _this.pin) || other.pin == _this.pin));
}


@override
int get hashCode {
  final _this = this as OnboardingDraft;
  return Object.hash(runtimeType,_this.phone,_this.firstName,_this.lastName,_this.passcode,_this.pin);
}

@override
String toString() {
  final _this = this as OnboardingDraft;
  return 'OnboardingDraft(phone: ${_this.phone}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, passcode: ${_this.passcode}, pin: ${_this.pin})';
}


}

/// @nodoc
abstract mixin class $OnboardingDraftCopyWith<$Res>  {
  factory $OnboardingDraftCopyWith(OnboardingDraft value, $Res Function(OnboardingDraft) _then) = _$OnboardingDraftCopyWithImpl;
@useResult
$Res call({
 PhoneNumber? phone, String firstName, String lastName, String? passcode, String? pin
});




}
/// @nodoc
class _$OnboardingDraftCopyWithImpl<$Res>
    implements $OnboardingDraftCopyWith<$Res> {
  _$OnboardingDraftCopyWithImpl(this._self, this._then);

  final OnboardingDraft _self;
  final $Res Function(OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = freezed,Object? firstName = null,Object? lastName = null,Object? passcode = freezed,Object? pin = freezed,}) {
  return _then(OnboardingDraft(
phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneNumber?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,passcode: freezed == passcode ? _self.passcode : passcode // ignore: cast_nullable_to_non_nullable
as String?,pin: freezed == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingDraft].
extension OnboardingDraftPatterns on OnboardingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingDraft value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhoneNumber? phone,  String firstName,  String lastName,  String? passcode,  String? pin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.phone,_that.firstName,_that.lastName,_that.passcode,_that.pin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhoneNumber? phone,  String firstName,  String lastName,  String? passcode,  String? pin)  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft():
return $default(_that.phone,_that.firstName,_that.lastName,_that.passcode,_that.pin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhoneNumber? phone,  String firstName,  String lastName,  String? passcode,  String? pin)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.phone,_that.firstName,_that.lastName,_that.passcode,_that.pin);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingDraft implements OnboardingDraft {
  const _OnboardingDraft({this.phone, this.firstName = '', this.lastName = '', this.passcode, this.pin});
  

@override final  PhoneNumber? phone;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override final  String? passcode;
@override final  String? pin;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDraftCopyWith<_OnboardingDraft> get copyWith => __$OnboardingDraftCopyWithImpl<_OnboardingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingDraft&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.passcode, passcode) || other.passcode == passcode)&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,firstName,lastName,passcode,pin);
}

@override
String toString() {
    return 'OnboardingDraft(phone: $phone, firstName: $firstName, lastName: $lastName, passcode: $passcode, pin: $pin)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDraftCopyWith<$Res> implements $OnboardingDraftCopyWith<$Res> {
  factory _$OnboardingDraftCopyWith(_OnboardingDraft value, $Res Function(_OnboardingDraft) _then) = __$OnboardingDraftCopyWithImpl;
@override @useResult
$Res call({
 PhoneNumber? phone, String firstName, String lastName, String? passcode, String? pin
});




}
/// @nodoc
class __$OnboardingDraftCopyWithImpl<$Res>
    implements _$OnboardingDraftCopyWith<$Res> {
  __$OnboardingDraftCopyWithImpl(this._self, this._then);

  final _OnboardingDraft _self;
  final $Res Function(_OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = freezed,Object? firstName = null,Object? lastName = null,Object? passcode = freezed,Object? pin = freezed,}) {
  return _then(_OnboardingDraft(
phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneNumber?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,passcode: freezed == passcode ? _self.passcode : passcode // ignore: cast_nullable_to_non_nullable
as String?,pin: freezed == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
