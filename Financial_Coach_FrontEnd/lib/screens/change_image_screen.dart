import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/avatar_provider.dart';

class ChangeImageScreen extends StatefulWidget {
  const ChangeImageScreen({super.key});

  @override
  State<ChangeImageScreen> createState() => _ChangeImageScreenState();
}

class _ChangeImageScreenState extends State<ChangeImageScreen> {
  String? _selectedAvatar;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load current avatar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final avatarProvider = context.read<AvatarProvider>();
      setState(() {
        _selectedAvatar = avatarProvider.selectedAvatarLabel;
      });
    });
  }

  final List<Map<String, dynamic>> _avatarOptions = [
    {'icon': Icons.person, 'color': Color(0xFF6C63FF), 'label': 'Default'},
    {'icon': Icons.face, 'color': Color(0xFFFF6B6B), 'label': 'Happy'},
    {'icon': Icons.sentiment_satisfied, 'color': Color(0xFF4ECDC4), 'label': 'Satisfied'},
    {'icon': Icons.sentiment_very_satisfied, 'color': Color(0xFFFFD93D), 'label': 'Very Happy'},
    {'icon': Icons.account_circle, 'color': Color(0xFF95E1D3), 'label': 'Circle'},
    {'icon': Icons.supervised_user_circle, 'color': Color(0xFFF38181), 'label': 'User'},
    {'icon': Icons.face_retouching_natural, 'color': Color(0xFFAA96DA), 'label': 'Natural'},
    {'icon': Icons.emoji_emotions, 'color': Color(0xFFFCBF49), 'label': 'Emotions'},
    {'icon': Icons.psychology, 'color': Color(0xFF00B4D8), 'label': 'Mind'},
    {'icon': Icons.self_improvement, 'color': Color(0xFFFF6F91), 'label': 'Improvement'},
    {'icon': Icons.accessibility_new, 'color': Color(0xFF5F9EA0), 'label': 'Accessible'},
    {'icon': Icons.record_voice_over, 'color': Color(0xFFFF8C42), 'label': 'Voice'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Avatar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Current Avatar Preview
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getSelectedColor(),
              boxShadow: [
                BoxShadow(
                  color: _getSelectedColor().withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _getSelectedIcon(),
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Choose Your Avatar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF2D3142),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Avatar Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _avatarOptions.length,
                itemBuilder: (context, index) {
                  final avatar = _avatarOptions[index];
                  final isSelected = _selectedAvatar == avatar['label'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar['label'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? avatar['color'].withValues(alpha: 0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? avatar['color']
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: avatar['color'].withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            avatar['icon'],
                            size: 40,
                            color: avatar['color'],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            avatar['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: avatar['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAvatar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Avatar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSelectedIcon() {
    if (_selectedAvatar == null) return Icons.person;

    final avatar = _avatarOptions.firstWhere(
      (a) => a['label'] == _selectedAvatar,
      orElse: () => _avatarOptions[0],
    );
    return avatar['icon'];
  }

  Color _getSelectedColor() {
    if (_selectedAvatar == null) {
      return Theme.of(context).colorScheme.primary;
    }

    final avatar = _avatarOptions.firstWhere(
      (a) => a['label'] == _selectedAvatar,
      orElse: () => _avatarOptions[0],
    );
    return avatar['color'];
  }

  Future<void> _saveAvatar() async {
    if (_selectedAvatar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an avatar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save avatar using AvatarProvider
      final avatarProvider = context.read<AvatarProvider>();
      await avatarProvider.setAvatar(_selectedAvatar!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Avatar updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating avatar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
