class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;

  const User({this.firstName, this.lastName, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, String?> toJson() => {
        "role": "ADMIN",
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      };
}
