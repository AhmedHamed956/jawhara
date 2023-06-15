import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jawhara/view/index.dart';
import 'colors.dart';
import 'font_family.dart';

final ThemeData themeData = new ThemeData(
  fontFamily: FontFamily.tajawal,
  brightness: Brightness.light,
  cursorColor: AppColors.primaryColor,
  cupertinoOverrideTheme: CupertinoThemeData(
    primaryColor:  AppColors.secondaryColor,
  ),
  primaryColor: AppColors.primaryColor,
  inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: InputBorder.none,errorMaxLines: 3,errorStyle: TextStyle(fontSize: 12),
      contentPadding: EdgeInsets.symmetric(vertical: 10)),
  appBarTheme: AppBarTheme(
      color: AppColors.bgColor,
      brightness: Brightness.light,
      titleTextStyle:TextStyle(color: AppColors.primaryColor),
      textTheme: TextTheme(bodyText1: TextStyle(color: AppColors.primaryColor)),
      iconTheme: IconThemeData(color: AppColors.primaryColor),
      actionsIconTheme: IconThemeData(color: AppColors.primaryColor),
      elevation: 0.4),
);
