class AuthResponse {
  final String userId;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final List<String> roles;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: json['expiresIn'] as int,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'roles': roles,
    };
  }
}