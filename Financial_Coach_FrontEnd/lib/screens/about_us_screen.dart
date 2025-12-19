import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            const Center(
              child: Text(
                'WealthPath',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF2D3142),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Mission Section
            _buildSectionTitle('Our Mission', Icons.flag),
            const SizedBox(height: 12),
            _buildContentText(
              'WealthPath is your personal AI-powered financial coach designed to help you achieve financial freedom. '
              'We believe everyone deserves access to professional financial guidance, regardless of their income level.',
            ),

            const SizedBox(height: 24),

            // What We Do Section
            _buildSectionTitle('What We Do', Icons.lightbulb_outline),
            const SizedBox(height: 12),
            _buildContentText(
              'Our intelligent AI assistant provides personalized financial advice, helps you create budgets, '
              'track expenses, plan savings, and achieve your financial goals. We support multiple languages '
              'including French, English, and Arabic (Darija).',
            ),

            const SizedBox(height: 24),

            // Features Section
            _buildSectionTitle('Key Features', Icons.star_outline),
            const SizedBox(height: 12),
            _buildFeatureItem('24/7 AI Financial Coach', Icons.psychology),
            _buildFeatureItem('Voice-Enabled Conversations', Icons.mic),
            _buildFeatureItem('Personalized Financial Plans', Icons.auto_graph),
            _buildFeatureItem('Multi-Language Support', Icons.language),
            _buildFeatureItem('Secure & Private', Icons.security),
            _buildFeatureItem('Goal Tracking & Analytics', Icons.insights),

            const SizedBox(height: 24),

            // Team Section
            _buildSectionTitle('Our Team', Icons.groups),
            const SizedBox(height: 12),
            _buildContentText(
              'WealthPath is developed by a passionate team of financial experts, AI engineers, '
              'and designers committed to democratizing financial education and empowerment.',
            ),

            const SizedBox(height: 24),

            // Contact Section
            _buildSectionTitle('Contact Us', Icons.email_outlined),
            const SizedBox(height: 12),
            _buildContactItem(Icons.email, 'support@wealthpath.com'),
            _buildContactItem(Icons.language, 'www.wealthpath.com'),
            _buildContactItem(Icons.location_on, 'Morocco, Casablanca'),

            const SizedBox(height: 32),

            // Social Media
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.facebook, context),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.mail, context),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.link, context),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            Center(
              child: Text(
                '© 2025 WealthPath. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 3, 63, 130), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.grey[700],
        fontFamily: 'Poppins',
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(238, 26, 18, 171),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 255, 255, 255), size: 24),
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

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 3, 63, 130), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(156, 3, 62, 130),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          // Handle social media links
        },
      ),
    );
  }
}
