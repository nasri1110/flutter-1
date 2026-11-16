/// Model entitas data akun pengguna / konsumen SayurHub
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String address;
  final String? avatarUrl;
  final String? token;
  final String role; // 'customer' atau 'admin'

  String get name => fullName;
  bool get isAdmin => role.toLowerCase() == 'admin';

  const User({
    required this.id,
    String? fullName,
    String? name,
    required this.phoneNumber,
    this.email,
    String? address,
    this.avatarUrl,
    this.token,
    this.role = 'customer',
  })  : fullName = fullName ?? name ?? '',
        address = address ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'name': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'avatarUrl': avatarUrl,
      'token': token,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      fullName: (map['fullName'] ?? map['name']) as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String?,
      address: map['address'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      token: map['token'] as String?,
      role: map['role'] as String? ?? 'customer',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}
