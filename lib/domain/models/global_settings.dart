class GlobalSettings {
  final String? id;
  final List<String> enabledCurrencies;
  final List<String> enabledLanguages;

  GlobalSettings({
    this.id,
    required this.enabledCurrencies,
    required this.enabledLanguages,
  });

  factory GlobalSettings.fromMap(Map<String, dynamic> map, String id) {
    return GlobalSettings(
      id: id,
      enabledCurrencies: List<String>.from(map['enabledCurrencies']),
      enabledLanguages: List<String>.from(map['enabledLanguages']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enabledCurrencies': enabledCurrencies,
      'enabledLanguages': enabledLanguages,
    };
  }
}
