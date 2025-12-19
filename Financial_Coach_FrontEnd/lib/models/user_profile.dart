class UserProfile {
  final String userId;
  String? fullName;
  String? email;
  int? age;
  String? occupation;
  String? country;
  String? city;
  double? monthlyIncome;
  double? monthlySavings;
  List<String> financialGoals;
  String? riskTolerance; // 'low', 'medium', 'high'
  Map<String, double> budgetCategories; // Category -> Amount
  String? preferredLanguage;
  String? currency;
  bool hasCompletedOnboarding;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserProfile({
    required this.userId,
    this.fullName,
    this.email,
    this.age,
    this.occupation,
    this.country,
    this.city,
    this.monthlyIncome,
    this.monthlySavings,
    List<String>? financialGoals,
    this.riskTolerance,
    Map<String, double>? budgetCategories,
    this.preferredLanguage = 'fr',
    this.currency = 'EUR',
    this.hasCompletedOnboarding = false,
    this.createdAt,
    this.updatedAt,
  })  : financialGoals = financialGoals ?? [],
        budgetCategories = budgetCategories ?? {};

  // Conversion depuis JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      age: json['age'] as int?,
      occupation: json['occupation'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      monthlySavings: (json['monthlySavings'] as num?)?.toDouble(),
      financialGoals: (json['financialGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      riskTolerance: json['riskTolerance'] as String?,
      budgetCategories: (json['budgetCategories'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {},
      preferredLanguage: json['preferredLanguage'] as String? ?? 'fr',
      currency: json['currency'] as String? ?? 'EUR',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'age': age,
      'occupation': occupation,
      'country': country,
      'city': city,
      'monthlyIncome': monthlyIncome,
      'monthlySavings': monthlySavings,
      'financialGoals': financialGoals,
      'riskTolerance': riskTolerance,
      'budgetCategories': budgetCategories,
      'preferredLanguage': preferredLanguage,
      'currency': currency,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copie avec modifications
  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? email,
    int? age,
    String? occupation,
    String? country,
    String? city,
    double? monthlyIncome,
    double? monthlySavings,
    List<String>? financialGoals,
    String? riskTolerance,
    Map<String, double>? budgetCategories,
    String? preferredLanguage,
    String? currency,
    bool? hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      country: country ?? this.country,
      city: city ?? this.city,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlySavings: monthlySavings ?? this.monthlySavings,
      financialGoals: financialGoals ?? this.financialGoals,
      riskTolerance: riskTolerance ?? this.riskTolerance,
      budgetCategories: budgetCategories ?? this.budgetCategories,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      currency: currency ?? this.currency,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Vérifier si le profil est complet
  bool get isProfileComplete {
    return fullName != null &&
        age != null &&
        monthlyIncome != null &&
        financialGoals.isNotEmpty &&
        riskTolerance != null;
  }

  // Calculer le taux d'épargne
  double? get savingsRate {
    if (monthlyIncome != null &&
        monthlySavings != null &&
        monthlyIncome! > 0) {
      return (monthlySavings! / monthlyIncome!) * 100;
    }
    return null;
  }
}
