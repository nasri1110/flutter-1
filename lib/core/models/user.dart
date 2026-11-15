/// Model entitas data akun pengguna / konsumen SayurHub
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String address;

  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}
