// To parse this JSON data, do
//
//     final countriesModel = countriesModelFromJson(jsonString);

import 'dart:convert';

class CountriesModel {
  CountriesModel({
    this.id,
    this.twoLetterAbbreviation,
    this.threeLetterAbbreviation,
    this.fullNameLocale,
    this.fullNameEnglish,
  });

  String id;
  String twoLetterAbbreviation;
  String threeLetterAbbreviation;
  String fullNameLocale;
  String fullNameEnglish;

  factory CountriesModel.fromRawJson(String str) => CountriesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountriesModel.fromJson(Map<String, dynamic> json) => CountriesModel(
    id: json["id"] == null ? null : json["id"],
    twoLetterAbbreviation: json["two_letter_abbreviation"] == null ? null : json["two_letter_abbreviation"],
    threeLetterAbbreviation: json["three_letter_abbreviation"] == null ? null : json["three_letter_abbreviation"],
    fullNameLocale: json["full_name_locale"] == null ? null : json["full_name_locale"],
    fullNameEnglish: json["full_name_english"] == null ? null : json["full_name_english"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "two_letter_abbreviation": twoLetterAbbreviation == null ? null : twoLetterAbbreviation,
    "three_letter_abbreviation": threeLetterAbbreviation == null ? null : threeLetterAbbreviation,
    "full_name_locale": fullNameLocale == null ? null : fullNameLocale,
    "full_name_english": fullNameEnglish == null ? null : fullNameEnglish,
  };
}
