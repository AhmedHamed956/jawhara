import 'package:flutter/material.dart';

import 'credit_card_widget.dart';

class CommonPaymentWidgets {
  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  static Map<CardType, Set<List<String>>> cardNumPatterns =
  <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
//    CardType.americanExpress: <List<String>>{
//      <String>['34'],
//      <String>['37'],
//    },
//    CardType.discover: <List<String>>{
//      <String>['6011'],
//      <String>['622126', '622925'],
//      <String>['644', '649'],
//      <String>['65']
//    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  static CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
          (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  // This method returns the icon for the visa card type if found
  // else will return the empty container
  static Widget getCardTypeIcon(String cardNumber, {double height, double width}) {
    Widget icon;
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        icon = Image.asset(
          'assets/icons/payment/visa.png',
          height: height ?? 48,
          width: width ?? 48,
        );
//        isAmex = false;
        break;

//      case CardType.americanExpress:
//        icon = Image.asset(
//          'assets/icons/payment/amex.png',
//          height: 48,
//          width: 48,
//        );
//        isAmex = true;
//        break;

      case CardType.mastercard:
        icon = Image.asset(
          'assets/icons/payment/mastercard.png',
          height: height ?? 48,
          width: width ?? 48,
        );
//        isAmex = false;
        break;

//      case CardType.discover:
//        icon = Image.asset(
//          'assets/icons/payment/discover.png',
//          height: 48,
//          width: 48,
//        );
//        isAmex = false;
//        break;

      default:
        icon = Container(
//          height: 48,
//          width: 48,
        );
//        isAmex = false;
        break;
    }

    return icon;
  }
}
