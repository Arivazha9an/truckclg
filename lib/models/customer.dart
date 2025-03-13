// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Customer {
  final String Name;
  final String Place;
  final String Material;
  final String Payment;
  final String Paid;
  final String Not_Paid;
  Customer({
    required this.Name,
    required this.Place,
    required this.Material,
    required this.Payment,
    required this.Paid,
    required this.Not_Paid,
  });

  Customer copyWith({
    String? Name,
    String? Place,
    String? Material,
    String? Payment,
    String? Paid,
    String? Not_Paid,
  }) {
    return Customer(
      Name: Name ?? this.Name,
      Place: Place ?? this.Place,
      Material: Material ?? this.Material,
      Payment: Payment ?? this.Payment,
      Paid: Paid ?? this.Paid,
      Not_Paid: Not_Paid ?? this.Not_Paid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'Place': Place,
      'Material': Material,
      'Payment': Payment,
      'Paid': Paid,
      'Not_Paid': Not_Paid,
    };
  }
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      Name: map['Name'] ?? '',
      Place: map['Place'] ?? '',
      Material: map['Material'] ?? '',
      Payment: map['Payment'] ?? '',
      Paid: map['Paid'] ?? '',
      Not_Paid: map['Not_Paid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(Name: $Name, Place: $Place, Material: $Material, Payment: $Payment, Paid: $Paid, Not_Paid: $Not_Paid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.Name == Name &&
        other.Place == Place &&
        other.Material == Material &&
        other.Payment == Payment &&
        other.Paid == Paid &&
        other.Not_Paid == Not_Paid;
  }

  @override
  int get hashCode {
    return Name.hashCode ^
        Place.hashCode ^
        Material.hashCode ^
        Payment.hashCode ^
        Paid.hashCode ^
        Not_Paid.hashCode;
  }
}
