import 'dart:convert';

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country data) => json.encode(data.toJson());

class Country {
  final String label;
  final String code;
  final Currency currency;
  final String dialingCode;
  final String flag;
  final List<County> counties;

  Country({
    required this.label,
    required this.code,
    required this.currency,
    required this.dialingCode,
    required this.flag,
    required this.counties,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        label: json["label"],
        code: json["code"],
        currency: Currency.fromJson(json["currency"]),
        dialingCode: json["dialingCode"],
        flag: json["flag"],
        counties:
            List<County>.from(json["counties"].map((x) => County.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "code": code,
        "currency": currency.toJson(),
        "dialingCode": dialingCode,
        "flag": flag,
        "counties": List<dynamic>.from(counties.map((x) => x.toJson())),
      };
}

class County {
  final String label;
  final List<SubCounty> subCounties;

  County({
    required this.label,
    required this.subCounties,
  });

  factory County.fromJson(Map<String, dynamic> json) => County(
        label: json["label"],
        subCounties: List<SubCounty>.from(
            json["subCounties"].map((x) => SubCounty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "subCounties": List<dynamic>.from(subCounties.map((x) => x.toJson())),
      };
}

class SubCounty {
  final String label;
  final List<String> wards;

  SubCounty({
    required this.label,
    required this.wards,
  });

  factory SubCounty.fromJson(Map<String, dynamic> json) => SubCounty(
        label: json["label"],
        wards: List<String>.from(json["wards"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "wards": List<dynamic>.from(wards.map((x) => x)),
      };
}

class Currency {
  final String name;
  final String code;

  Currency({
    required this.name,
    required this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}
