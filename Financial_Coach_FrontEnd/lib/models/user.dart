class User {
  final String id;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'roles': roles,
    };
  }

  bool hasRole(String role) {
    return roles.contains(role);
  }

  bool get isAdmin => hasRole('ROLE_ADMIN');
  bool get isCoach => hasRole('ROLE_COACH');
  bool get isUser => hasRole('ROLE_USER');
}