import 'package:flutter/material.dart';

class SupportUsScreen extends StatelessWidget {
  const SupportUsScreen({super.key});

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
          'Support Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 80,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Support WealthPath',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Help us keep WealthPath free and accessible to everyone',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Why Support Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Why Support Us?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.check_circle_outline,
                    'Keep WealthPath completely free',
                    Colors.green,
                  ),
                  _buildBenefitItem(
                    Icons.rocket_launch_outlined,
                    'Help us develop new features',
                    Colors.blue,
                  ),
                  _buildBenefitItem(
                    Icons.language,
                    'Support more languages',
                    Colors.purple,
                  ),
                  _buildBenefitItem(
                    Icons.speed,
                    'Improve AI performance',
                    Colors.orange,
                  ),
                  _buildBenefitItem(
                    Icons.people_outline,
                    'Reach more people worldwide',
                    Colors.teal,
                  ),
                ],
              ),
            ),

            // Support Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ways to Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // One-time Donation
                  _buildSupportCard(
                    context,
                    title: 'One-Time Support',
                    description: 'Make a one-time contribution',
                    icon: Icons.card_giftcard,
                    color: const Color(0xFF6C63FF),
                    onTap: () => _showDonationOptions(context),
                  ),

                  const SizedBox(height: 16),

                  // Monthly Support
                  _buildSupportCard(
                    context,
                    title: 'Monthly Support',
                    description: 'Become a monthly supporter',
                    icon: Icons.favorite,
                    color: const Color(0xFFFF6B6B),
                    badge: 'Popular',
                    onTap: () => _showMonthlyOptions(context),
                  ),

                  const SizedBox(height: 16),

                  // Share App
                  _buildSupportCard(
                    context,
                    title: 'Share WealthPath',
                    description: 'Tell your friends about us',
                    icon: Icons.share,
                    color: const Color(0xFF4ECDC4),
                    onTap: () => _shareApp(context),
                  ),

                  const SizedBox(height: 16),

                  // Rate App
                  _buildSupportCard(
                    context,
                    title: 'Rate Us',
                    description: 'Leave a review on the app store',
                    icon: Icons.star,
                    color: const Color(0xFFFFD93D),
                    onTap: () => _rateApp(context),
                  ),

                  const SizedBox(height: 16),

                  // Follow on Social Media
                  _buildSupportCard(
                    context,
                    title: 'Follow Us',
                    description: 'Stay updated on social media',
                    icon: Icons.group,
                    color: const Color(0xFF95E1D3),
                    onTap: () => _showSocialMedia(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Thank You Section
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_emotions,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Thank You!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your support helps us empower people worldwide to achieve financial freedom.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                color: Color(0xFF2D3142),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showDonationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['5€', '10€', '20€', '50€', '100€', 'Custom']
                  .map((amount) => _buildAmountChip(amount, context))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showMonthlyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Monthly Support Plans',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            _buildPlanTile(context, '2€/month', 'Coffee Supporter'),
            _buildPlanTile(context, '5€/month', 'Bronze Supporter'),
            _buildPlanTile(context, '10€/month', 'Silver Supporter'),
            _buildPlanTile(context, '20€/month', 'Gold Supporter'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for supporting with $amount!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildPlanTile(BuildContext context, String price, String tier) {
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.red),
      title: Text(
        tier,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(price),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for choosing $tier!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your support! Redirecting to app store...'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSocialMedia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Follow Us On',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: const Text('Facebook'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.purple),
              title: const Text('Instagram'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email, color: Colors.lightBlue),
              title: const Text('Twitter'),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
