import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

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
          'Terms of Service',
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
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Last updated: December 2024',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content
            _buildSection(
              '1. Acceptance of Terms',
              [
                'By downloading, installing, or using the Kikoba Management System mobile application, you agree to be bound by these Terms of Service.',
                'If you do not agree to these terms, please do not use our application.',
                'We reserve the right to modify these terms at any time, and your continued use constitutes acceptance of the modified terms.',
              ],
            ),

            _buildSection(
              '2. Description of Service',
              [
                'The Kikoba Management System is a mobile application that provides financial services including:',
                '• Savings account management',
                '• Loan application and management',
                '• Share trading and management',
                '• Transaction history and reporting',
                '• Payment processing through USSD',
                'We provide these services in partnership with registered financial institutions and Vikoba organizations.',
              ],
            ),

            _buildSection(
              '3. User Eligibility',
              [
                'You must be at least 18 years old to use our services.',
                'You must be a legal resident of Tanzania.',
                'You must have a valid phone number and email address.',
                'You must provide accurate and complete information during registration.',
                'You must comply with all applicable laws and regulations.',
              ],
            ),

            _buildSection(
              '4. Account Registration',
              [
                'You are responsible for maintaining the confidentiality of your account credentials.',
                'You must provide accurate, current, and complete information during registration.',
                'You must notify us immediately of any unauthorized use of your account.',
                'You are responsible for all activities that occur under your account.',
                'We reserve the right to refuse service or terminate accounts at our discretion.',
              ],
            ),

            _buildSection(
              '5. Financial Services',
              [
                'All financial transactions are subject to the terms and conditions of the respective financial institutions.',
                'Interest rates, fees, and terms are subject to change without prior notice.',
                'We act as an intermediary and are not responsible for the financial decisions of Vikoba organizations.',
                'All transactions are final once processed, subject to applicable dispute resolution procedures.',
              ],
            ),

            _buildSection(
              '6. User Responsibilities',
              [
                'Use the application only for lawful purposes and in accordance with these terms.',
                'Maintain the security of your account and report any suspicious activity.',
                'Provide accurate information and update it as necessary.',
                'Comply with all applicable laws and regulations.',
                'Do not attempt to gain unauthorized access to our systems.',
                'Do not use the application to engage in fraudulent activities.',
              ],
            ),

            _buildSection(
              '7. Prohibited Activities',
              [
                'Creating fake accounts or providing false information.',
                'Attempting to hack, disrupt, or damage our systems.',
                'Using the application for illegal activities or money laundering.',
                'Sharing your account credentials with others.',
                'Attempting to reverse engineer or copy our application.',
                'Spamming or sending unsolicited communications.',
              ],
            ),

            _buildSection(
              '8. Privacy and Data Protection',
              [
                'Your privacy is important to us. Please review our Privacy Policy for information about how we collect, use, and protect your data.',
                'We implement security measures to protect your personal and financial information.',
                'We may collect and use your data as described in our Privacy Policy.',
              ],
            ),

            _buildSection(
              '9. Intellectual Property',
              [
                'The Kikoba Management System application and all its content are protected by copyright and other intellectual property laws.',
                'You may not copy, modify, distribute, or create derivative works without our permission.',
                'All trademarks and logos are the property of their respective owners.',
              ],
            ),

            _buildSection(
              '10. Limitation of Liability',
              [
                'We provide the application "as is" without warranties of any kind.',
                'We are not liable for any indirect, incidental, or consequential damages.',
                'Our liability is limited to the amount you have paid for our services.',
                'We are not responsible for the actions or decisions of Vikoba organizations.',
              ],
            ),

            _buildSection(
              '11. Service Availability',
              [
                'We strive to maintain high service availability but cannot guarantee uninterrupted access.',
                'We may perform maintenance that temporarily affects service availability.',
                'We are not liable for service interruptions due to circumstances beyond our control.',
              ],
            ),

            _buildSection(
              '12. Termination',
              [
                'You may terminate your account at any time by contacting customer support.',
                'We may terminate or suspend your account for violation of these terms.',
                'Upon termination, your right to use the application ceases immediately.',
                'We may retain certain information as required by law or for legitimate business purposes.',
              ],
            ),

            _buildSection(
              '13. Governing Law',
              [
                'These terms are governed by the laws of Tanzania.',
                'Any disputes will be resolved in the courts of Tanzania.',
                'If any provision of these terms is found to be invalid, the remaining provisions will remain in effect.',
              ],
            ),

            _buildSection(
              '14. Contact Information',
              [
                'For questions about these Terms of Service, please contact us:',
                'Email: legal@kikoba.com',
                'Phone: +255 XXX XXX XXX',
                'Address: Kikoba Management System, Tanzania',
              ],
            ),

            const SizedBox(height: 24),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'By using the Kikoba Management System, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...content.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppConst.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
