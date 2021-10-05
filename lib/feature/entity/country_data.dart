

import 'package:json_annotation/json_annotation.dart';

part 'country_data.g.dart';

@JsonSerializable()
class CountryData {
  String code;
  String name;
  String currency;
  List<Map<String, String>> languages;
  Map<String, String> continent;

  CountryData(
      this.code, this.name, this.currency, this.continent, this.languages);

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);

}
