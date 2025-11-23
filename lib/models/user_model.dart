class UserModel {
  final String name;
  final String phone;
  final String city;
  final String address;

  const UserModel({
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
  });

  UserModel copyWith({
    String? name,
    String? phone,
    String? city,
    String? address,
  }) {
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }

  static const empty = UserModel(
    name: '',
    phone: '',
    city: 'دمشق',
    address: '',
  );
}

