import 'package:jawhara/view/index.dart';

class Validators {
  // Phone number
  static String validatePhone(String value,{bool optional = false}) {
    if(optional == true)
      return null;
    if (value.isEmpty) {
      return translate('validation.enter_phone');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return translate('validation.number_only');
    } else if (!RegExp(r'^((?:[+?0?0?966]+)(?:\s?' r'\d{2})(?:\s?\d{7}))$').hasMatch(value)) {
      return translate('validation.number_only_saudi');
    } else {
      return null;
    }
  }
  // Phone number
  static String validatePrice(String value) {
    if (value.isEmpty) {
      return translate('validation.enter_price');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (!RegExp(r'(?<=\s|^)\d+(?=\s|$)').hasMatch(value)) {
      return translate('validation.number_only');
    } else {
      return null;
    }
  }

  // Terms&conditions
  static String validateTerms(bool value) {
    if (value) {
      return null;
    } else {
      return translate('validation.field_blank');
    }
  }

  // Password
  static String validatePassword(String value) {
    if (value.isEmpty) {
      return translate('validation.enter_password');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (!RegExp(r'^(?=.{8,32}$)(?=.*[ -\/:-@\[-\`{-~]{1,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*$')
        .hasMatch(value)) {
      return translate('validation.password_complex');
    } else {
      return null;
    }
  }

  static String validatePasswordConfirm(String value, {password}) {
    if (value.isEmpty) {
      return translate('validation.enter_password');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (!RegExp(r'^(?=.{8,32}$)(?=.*[ -\/:-@\[-\`{-~]{1,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*$')
        .hasMatch(value)) {
      return translate('validation.password_complex');
    } else if (value != password) {
      return translate('validation.password_confirm');
    } else {
      return null;
    }
  }

  // Gender
  static String validateGender(String value) {
    if (value == null || value.isEmpty) {
      return translate('validation.field_blank');
    } else {
      return null;
    }
  }

  // Full Name
  static String validateName(String value) {
    if (value.isEmpty) {
      return translate('validation.full_name');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
        .hasMatch(value)) {
      return translate('validation.letter_only');
    } else {
      return null;
    }
  }

  // Service
  static String validateService(String value) {
    if (value.isEmpty) {
      return translate('validation.other_service');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
        .hasMatch(value)) {
      return translate('validation.letter_only');
    } else {
      return null;
    }
  }

  // Email
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return translate('validation.email');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else if (RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value.substring(0,value.indexOf('@')))) {
      return translate('validation.email_valid');
    } else if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
      return translate('validation.email_valid');
    } else {
      return null;
    }
  }

  // Any Text Form
  static String validateForm(String value) {
    if (value.isEmpty) {
      return translate('validation.field_blank');
    } else if (value.trim().length == 0) {
      return translate('validation.field_blank');
    } else {
      return null;
    }
  }
}
