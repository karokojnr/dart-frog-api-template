class AuthUser {
  AuthUser({
    required this.email,
    required this.password,
    this.id,
    this.name,
    this.age,
    this.weight,
  });

  AuthUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        email = json['email'] as String,
        password = json['password'] as String,
        age = json['age'] as int?,
        weight = json['weight'] as int?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'age': age,
        'weight': weight,
      };

  final String? id;
  final String? name;
  final String email;
  final String password;
  final int? age;
  final int? weight;

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    int? age,
    int? weight,
  }) =>
      AuthUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        age: age ?? this.age,
        weight: weight ?? this.weight,
      );
}
