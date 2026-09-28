import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/auth_controller.dart';
import '../../data/auth_repository.dart';
import '../../domain/phone_number.dart';

part 'onboarding_controller.freezed.dart';

@freezed
abstract class OnboardingDraft with _$OnboardingDraft {
  const factory OnboardingDraft({
    PhoneNumber? phone,
    @Default('') String firstName,
    @Default('') String lastName,
    String? passcode,
    String? pin,
  }) = _OnboardingDraft;
}

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  Future<void> requestOtp(String input) async {
    final phone = PhoneNumber.tryParse(input);
    if (phone == null) {
      throw const ValidationException(
        'Enter a Nigerian mobile number, e.g. 0803 123 4567.',
      );
    }
    await ref.read(authRepositoryProvider).requestOtp(phone);
    state = state.copyWith(phone: phone);
  }

  Future<void> resendOtp() =>
      ref.read(authRepositoryProvider).requestOtp(state.phone!);

  Future<void> verifyOtp(String code) =>
      ref.read(authRepositoryProvider).verifyOtp(state.phone!, code);

  void setName(String first, String last) =>
      state = state.copyWith(firstName: first.trim(), lastName: last.trim());

  void setPasscode(String passcode) =>
      state = state.copyWith(passcode: passcode);

  void setPin(String pin) => state = state.copyWith(pin: pin);

  Future<void> finish({required bool biometricsEnabled}) async {
    await ref
        .read(authControllerProvider.notifier)
        .completeOnboarding(
          name: '${state.firstName} ${state.lastName}',
          phone: '0${state.phone!.national}',
          passcode: state.passcode!,
          pin: state.pin!,
          biometricsEnabled: biometricsEnabled,
        );
    ref.invalidateSelf();
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingController, OnboardingDraft>(
      OnboardingController.new,
    );
