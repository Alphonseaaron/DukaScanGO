class PaymentGatewaySettings {
  final String? id;
  final String gatewayName;
  final bool isEnabled;
  final Map<String, dynamic> settings;

  PaymentGatewaySettings({
    this.id,
    required this.gatewayName,
    required this.isEnabled,
    required this.settings,
  });

  factory PaymentGatewaySettings.fromMap(Map<String, dynamic> map, String id) {
    return PaymentGatewaySettings(
      id: id,
      gatewayName: map['gatewayName'],
      isEnabled: map['isEnabled'],
      settings: Map<String, dynamic>.from(map['settings']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gatewayName': gatewayName,
      'isEnabled': isEnabled,
      'settings': settings,
    };
  }
}
