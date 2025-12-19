import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'What is WealthPath?',
      'answer':
          'WealthPath is an AI-powered financial coaching app that provides personalized financial advice, budgeting tools, and goal tracking to help you achieve financial freedom.',
    },
    {
      'question': 'Is WealthPath free to use?',
      'answer':
          'Yes! WealthPath offers a free tier with essential features. Premium features may be available in future updates.',
    },
    {
      'question': 'How does the AI coach work?',
      'answer':
          'Our AI coach uses advanced natural language processing to understand your financial situation and provide personalized advice. You can interact with it through text or voice.',
    },
    {
      'question': 'Which languages are supported?',
      'answer':
          'WealthPath currently supports French, English, Arabic (Darija), and Spanish. More languages will be added in future updates.',
    },
    {
      'question': 'Is my financial data secure?',
      'answer':
          'Absolutely! We use industry-standard encryption to protect your data. Your information is never shared with third parties without your consent.',
    },
    {
      'question': 'Can I use voice commands?',
      'answer':
          'Yes! WealthPath features voice recognition technology. Simply tap the microphone button and speak to interact with your financial coach.',
    },
    {
      'question': 'How do I set financial goals?',
      'answer':
          'You can set goals during the onboarding process or update them anytime in your profile settings. The AI coach will help you create actionable plans to achieve them.',
    },
    {
      'question': 'Can I track multiple currencies?',
      'answer':
          'Yes, you can select your preferred currency in the settings. Support for multiple currencies simultaneously is coming soon.',
    },
    {
      'question': 'How do I reset my conversation?',
      'answer':
          'Tap the refresh icon in the top-right corner of the chat screen to reset your current conversation. This helps start fresh when discussing new topics.',
    },
    {
      'question': 'How do I contact support?',
      'answer':
          'You can reach us through the "Help & Feedback" section in your profile, or email us directly at support@wealthpath.com.',
    },
    {
      'question': 'Can I use WealthPath offline?',
      'answer':
          'Currently, WealthPath requires an internet connection for AI features. We\'re working on offline capabilities for basic functions.',
    },
    {
      'question': 'How often should I update my profile?',
      'answer':
          'We recommend updating your profile whenever your financial situation changes significantly (new job, major purchase, etc.) to receive more accurate advice.',
    },
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
          'FAQ',
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
                  Icons.help_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Frequently Asked Questions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find answers to common questions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                final faq = _faqs[index];
                final isExpanded = _expandedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isExpanded
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300]!,
                        width: isExpanded ? 2 : 1,
                      ),
                      boxShadow: isExpanded
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? null : index;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.question_answer,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    faq['question']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isExpanded
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: const Color(0xFF2D3142),
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  faq['answer']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey[700],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Help Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Still have questions?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Contact our support team',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help-feedback');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Contact',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
