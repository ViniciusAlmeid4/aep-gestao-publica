class Address {
  final String street;
  final String number;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode:
          json['zipCode']?.toString() ?? json['zip_code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'number': number,
    'city': city,
    'state': state,
    'zipCode': zipCode,
  };
}
