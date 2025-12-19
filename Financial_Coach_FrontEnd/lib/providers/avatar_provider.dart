import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarProvider extends ChangeNotifier {
  static const String _avatarIconKey = 'avatar_icon';
  static const String _avatarColorKey = 'avatar_color';

  String _selectedAvatarLabel = 'Default';
  IconData _avatarIcon = Icons.person;
  Color _avatarColor = const Color(0xFF6C63FF);

  String get selectedAvatarLabel => _selectedAvatarLabel;
  IconData get avatarIcon => _avatarIcon;
  Color get avatarColor => _avatarColor;

  final Map<String, Map<String, dynamic>> _avatarMap = {
    'Default': {'icon': Icons.person, 'color': const Color(0xFF6C63FF)},
    'Happy': {'icon': Icons.face, 'color': const Color(0xFFFF6B6B)},
    'Satisfied': {'icon': Icons.sentiment_satisfied, 'color': const Color(0xFF4ECDC4)},
    'Very Happy': {'icon': Icons.sentiment_very_satisfied, 'color': const Color(0xFFFFD93D)},
    'Circle': {'icon': Icons.account_circle, 'color': const Color(0xFF95E1D3)},
    'User': {'icon': Icons.supervised_user_circle, 'color': const Color(0xFFF38181)},
    'Natural': {'icon': Icons.face_retouching_natural, 'color': const Color(0xFFAA96DA)},
    'Emotions': {'icon': Icons.emoji_emotions, 'color': const Color(0xFFFCBF49)},
    'Mind': {'icon': Icons.psychology, 'color': const Color(0xFF00B4D8)},
    'Improvement': {'icon': Icons.self_improvement, 'color': const Color(0xFFFF6F91)},
    'Accessible': {'icon': Icons.accessibility_new, 'color': const Color(0xFF5F9EA0)},
    'Voice': {'icon': Icons.record_voice_over, 'color': const Color(0xFFFF8C42)},
  };

  AvatarProvider() {
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final iconCode = prefs.getInt(_avatarIconKey);
    final colorValue = prefs.getInt(_avatarColorKey);

    if (iconCode != null && colorValue != null) {
      _avatarIcon = IconData(iconCode, fontFamily: 'MaterialIcons');
      _avatarColor = Color(colorValue);

      // Find the label
      _avatarMap.forEach((label, data) {
        if (data['icon'] == _avatarIcon && data['color'] == _avatarColor) {
          _selectedAvatarLabel = label;
        }
      });

      notifyListeners();
    }
  }

  Future<void> setAvatar(String label) async {
    if (_avatarMap.containsKey(label)) {
      _selectedAvatarLabel = label;
      _avatarIcon = _avatarMap[label]!['icon'] as IconData;
      _avatarColor = _avatarMap[label]!['color'] as Color;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_avatarIconKey, _avatarIcon.codePoint);
      await prefs.setInt(_avatarColorKey, _avatarColor.toARGB32());

      notifyListeners();
    }
  }

  Map<String, dynamic> getAvatarData(String label) {
    return _avatarMap[label] ?? _avatarMap['Default']!;
  }

  List<String> get allAvatarLabels => _avatarMap.keys.toList();
}
