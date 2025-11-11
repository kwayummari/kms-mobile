import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I create a savings account?',
      'answer':
          'To create a savings account, go to the Finance tab, select Savings, and click on "Open Account". You\'ll need to provide your personal details and choose a Vikoba organization to join.',
    },
    {
      'question': 'How do I make a deposit using USSD?',
      'answer':
          'Go to your savings account, click "Deposit", enter the amount and your phone number. You\'ll receive a USSD prompt on your phone to complete the payment.',
    },
    {
      'question': 'How do I apply for a loan?',
      'answer':
          'Navigate to the Finance tab, select Loans, and click "Apply Loan". Fill in the required information including loan amount, purpose, and term. Your application will be reviewed by your Vikoba organization.',
    },
    {
      'question': 'How do I buy shares?',
      'answer':
          'Go to the Shares section, select the Vikoba you want to invest in, click "Buy Shares", enter the quantity, and complete the USSD payment process.',
    },
    {
      'question': 'What should I do if I forgot my password?',
      'answer':
          'On the login screen, click "Forgot Password" and enter your email address. You\'ll receive a reset link to create a new password.',
    },
    {
      'question': 'How do I track my transactions?',
      'answer':
          'All your transactions are available in the respective sections (Savings, Loans, Shares). Each section has a "History" button to view detailed transaction records.',
    },
    {
      'question': 'Is my financial information secure?',
      'answer':
          'Yes, we use bank-level encryption and security protocols to protect your personal and financial information. All transactions are secured and monitored.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact us through the "Send Feedback" section in your profile, call our support line at +255 XXX XXX XXX, or email us at support@kikoba.com.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConst.primary, AppConst.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.help_outline,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'How Can We Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find answers to common questions or get in touch with our support team.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(),

            const SizedBox(height: 24),

            // FAQ Section
            _buildFAQSection(),

            const SizedBox(height: 24),

            // Contact Support
            _buildContactSupport(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Getting Started',
        'description': 'Learn how to use the app',
        'icon': Icons.play_circle_outline,
        'color': Colors.blue,
      },
      {
        'title': 'Account Setup',
        'description': 'Set up your profile',
        'icon': Icons.person_add,
        'color': Colors.green,
      },
      {
        'title': 'Security Guide',
        'description': 'Keep your account safe',
        'icon': Icons.security,
        'color': Colors.orange,
      },
      {
        'title': 'Troubleshooting',
        'description': 'Fix common issues',
        'icon': Icons.build,
        'color': Colors.red,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Help',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: () => _showActionDialog(action['title'] as String),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      action['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action['description'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ..._faqs.map((faq) => _buildFAQItem(faq['question'], faq['answer'])),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Still Need Help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
           Text(
            'Our support team is here to help you 24/7. Choose your preferred way to get in touch:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          _buildContactOption(
            Icons.email,
            'Email Support',
            'support@kikoba.com',
            'Get help via email',
            Colors.blue,
            () {},
          ),
          _buildContactOption(
            Icons.phone,
            'Phone Support',
            '+255 XXX XXX XXX',
            'Call us directly',
            Colors.green,
            () {},
          ),
          _buildContactOption(
            Icons.chat,
            'Live Chat',
            'Available 24/7',
            'Chat with our agents',
            Colors.orange,
            () {},
          ),
          _buildContactOption(
            Icons.feedback,
            'Send Feedback',
            'Share your thoughts',
            'Help us improve',
            Colors.purple,
            () {
              Navigator.pushNamed(context, '/send-feedback');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showActionDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(
          'This feature will provide detailed guidance on $title. The full guide will be available in the next app update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
