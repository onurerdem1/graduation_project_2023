class SVGImageConstants {
  static SVGImageConstants? _instace;

  static SVGImageConstants get instance =>
      _instace ??= SVGImageConstants._init();

  SVGImageConstants._init();
  String get splashLogo => toSvg('splash_logo');

  String get loginToprightImage => toSvg('login_topright');
  String get onboardFirst => toSvg('onboard_1');
  String get onboardSecond => toSvg('onboard_2');
  String get onboardLast => toSvg('onboard_3');
  String get transactionSuccess => toSvg('transaction_success');
  String get transactionFail => toSvg('transaction_fail');
  String get firstMedal => toSvg('first_medal');
  String get secondMedal => toSvg('second_medal');
  String get thirdMedal => toSvg('third_medal');
  String get scooterIcon => toSvg('scooter');
  String get carIcon => toSvg('car');
  String get busIcon => toSvg('bus');
  String get footprintIcon => toSvg('carbon_footprint');
  String get notificationsIcon => toSvg('carbon_footprint');
  String get passwordResetIcon => toSvg('password_reset');
  String get ridesIcon => toSvg('rides');
  String get logoutIcon => toSvg('logout');

  String toSvg(String name) => 'assets/svg/$name.svg';

  String get homeIcon => toSvgIcon('home');
  String get calendarIcon => toSvgIcon('calendar');
  String get notificationIcon => toSvgIcon('bell');
  String get profileIcon => toSvgIcon('profile');

  String toSvgIcon(String name) => 'assets/svg/design/$name.svg';
}
