import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
          'Privacy Policy',
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
                    'Privacy Policy',
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
              '1. Information We Collect',
              [
                'Personal Information: We collect your name, email address, phone number, and national ID when you register for our services.',
                'Financial Information: We collect information about your savings, loans, shares, and transactions to provide our financial services.',
                'Device Information: We may collect information about your device, including device model, operating system, and unique device identifiers.',
                'Usage Information: We collect information about how you use our app, including pages visited and features used.',
              ],
            ),

            _buildSection(
              '2. How We Use Your Information',
              [
                'Service Provision: To provide and maintain our financial services including savings, loans, and share management.',
                'Account Management: To manage your account, process transactions, and provide customer support.',
                'Communication: To send you important updates about your account and our services.',
                'Security: To protect against fraud, unauthorized access, and other security threats.',
                'Legal Compliance: To comply with applicable laws and regulations.',
              ],
            ),

            _buildSection(
              '3. Information Sharing',
              [
                'We do not sell, trade, or rent your personal information to third parties.',
                'We may share your information with trusted partners who assist us in operating our services, such as payment processors.',
                'We may disclose information when required by law or to protect our rights and safety.',
                'We may share aggregated, non-personal information for research and analytics purposes.',
              ],
            ),

            _buildSection(
              '4. Data Security',
              [
                'We implement industry-standard security measures to protect your personal information.',
                'All financial transactions are encrypted using secure protocols.',
                'We regularly update our security systems and conduct security audits.',
                'Access to your personal information is restricted to authorized personnel only.',
              ],
            ),

            _buildSection(
              '5. Your Rights',
              [
                'Access: You have the right to access your personal information we hold.',
                'Correction: You can request corrections to inaccurate or incomplete information.',
                'Deletion: You can request deletion of your personal information, subject to legal requirements.',
                'Portability: You can request a copy of your data in a portable format.',
                'Opt-out: You can opt-out of marketing communications at any time.',
              ],
            ),

            _buildSection(
              '6. Data Retention',
              [
                'We retain your personal information for as long as necessary to provide our services.',
                'Financial records are retained as required by applicable laws and regulations.',
                'We securely delete or anonymize personal information when it is no longer needed.',
              ],
            ),

            _buildSection(
              '7. Third-Party Services',
              [
                'Our app may integrate with third-party services for payment processing and other features.',
                'These third parties have their own privacy policies, which we encourage you to review.',
                'We are not responsible for the privacy practices of third-party services.',
              ],
            ),

            _buildSection(
              '8. Children\'s Privacy',
              [
                'Our services are not intended for children under 13 years of age.',
                'We do not knowingly collect personal information from children under 13.',
                'If we discover that we have collected information from a child under 13, we will delete it immediately.',
              ],
            ),

            _buildSection(
              '9. Changes to This Policy',
              [
                'We may update this Privacy Policy from time to time.',
                'We will notify you of any material changes through the app or by email.',
                'Your continued use of our services after changes constitutes acceptance of the new policy.',
              ],
            ),

            _buildSection(
              '10. Contact Us',
              [
                'If you have any questions about this Privacy Policy, please contact us:',
                'Email: privacy@kikoba.com',
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
                'This Privacy Policy is effective as of December 2024 and governs your use of the Kikoba Management System mobile application.',
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
