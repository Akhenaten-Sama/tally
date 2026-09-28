abstract final class Routes {
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const login = '/onboarding/login';
  static const onboardingPhone = '/onboarding/phone';
  static const onboardingOtp = '/onboarding/otp';
  static const onboardingName = '/onboarding/name';
  static const onboardingPasscode = '/onboarding/passcode';
  static const onboardingPin = '/onboarding/pin';
  static const onboardingBiometrics = '/onboarding/biometrics';
  static const home = '/home';
  static const history = '/history';
  static const savings = '/savings';
  static const profile = '/profile';
  static const personalDetails = '/profile/details';
  static const accountLimits = '/profile/limits';
  static const upgradeTier = '/profile/limits/upgrade';
  static const changePin = '/profile/change-pin';
  static const changePasscode = '/profile/change-passcode';
  static const send = '/send';
  static const sendAmount = '/send/amount';
  static const notifications = '/notifications';
  static const statement = '/statement';
  static const bills = '/bills';
  static const airtime = '/bills/airtime';
  static const electricity = '/bills/electricity';
  static const cable = '/bills/cable';
  static const mortgage = '/mortgage';
  static const mortgageSchedule = '/mortgage/schedule';
  static const mortgageProducts = '/mortgage/products';
  static const mortgageCalculator = '/mortgage/products/calculator';
  static const mortgageApply = '/mortgage/apply';
  static String mortgageApplication(String id) => '/mortgage/applications/$id';

  /// Sits on top of Home, so "back" from a finished transfer lands there
  /// instead of returning into the completed flow.
  static String transferStatus(String id) => '/home/transfer/$id';
  static String transaction(String id) => '/transactions/$id';
}
