import 'package:easy_localization/easy_localization.dart';

import '../constants/app/application_constants.dart';

extension StringLocalization on String {
  String get locale => this.tr();

  String? get isValidEmail =>
      contains(RegExp(ApplicationConstants.EMAIL_REGIEX))
          ? null
          : 'Email is not valid';

  bool get isValidEmails =>
      RegExp(ApplicationConstants.EMAIL_REGIEX).hasMatch(this);
}

extension ImagePathExtension on String {
  String get toSVG => 'asset/svg/$this.svg';
}

extension LanguageExtension on String {
  String get toLanguageHeader {
    switch (this) {
      case 'US':
        return 'E';
      case 'TR':
        return 'T';

      default:
        return '';
    }
  }

  String get toLanguageString {
    switch (this) {
      case 'US':
        return 'EN';
      case 'TR':
        return 'TR';

      default:
        return '';
    }
  }
}
