import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/widgets/editProfileDialog.dart';
import 'package:kms/src/widgets/changePasswordDialog.dart';
import 'package:kms/src/screens/models/profile/privacyPolicy.dart';
import 'package:kms/src/screens/models/profile/termsOfService.dart';
import 'package:kms/src/screens/models/profile/aboutApp.dart';
import 'package:kms/src/screens/models/profile/sendFeedback.dart';
import 'package:kms/src/screens/models/profile/helpSupport.dart';
import 'package:kms/src/gateway/profile-service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userRole = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('full_name') ?? 'User';
        _userEmail = prefs.getString('email') ?? '';
        _userPhone = prefs.getString('phone') ?? '';
        _userRole = prefs.getString('role_name') ?? 'Member';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle Edit Profile
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        currentName: _userName,
        currentEmail: _userEmail,
        currentPhone: _userPhone,
        onSave: _updateProfile,
      ),
    );
  }

  // Handle Change Password
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordDialog(
        onChangePassword: _changePassword,
      ),
    );
  }

  // Update Profile
  Future<void> _updateProfile(String name, String email, String phone) async {
    try {
      final profileService = ProfileService();
      final response = await profileService.updateProfile(
        context,
        fullName: name,
        email: email,
        phone: phone,
      );

      if (response['success'] == true) {
        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('full_name', name);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);

        // Update UI
        setState(() {
          _userName = name;
          _userEmail = email;
          _userPhone = phone;
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Change Password
  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    try {
      final profileService = ProfileService();
      final response = await profileService.changePassword(
        context,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  // Navigate to Privacy Policy
  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
    );
  }

  // Navigate to Terms of Service
  void _navigateToTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfService()),
    );
  }

  // Navigate to About App
  void _navigateToAboutApp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutApp()),
    );
  }

  // Navigate to Send Feedback
  void _navigateToSendFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SendFeedback()),
    );
  }

  // Navigate to Help & Support
  void _navigateToHelpSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpSupport()),
    );
  }

  // Edit specific field
  void _editField(String fieldName, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $fieldName'),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $fieldName',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update the field
              setState(() {
                switch (fieldName.toLowerCase()) {
                  case 'full name':
                    _userName = controller.text;
                    break;
                  case 'email':
                    _userEmail = controller.text;
                    break;
                  case 'phone':
                    _userPhone = controller.text;
                    break;
                }
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$fieldName updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 32),

              // Profile Information
              _buildProfileInfo(),
              const SizedBox(height: 32),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 32),

              // Settings & Support
              _buildSettingsSection(),
              const SizedBox(height: 32),

              // Logout Button
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConst.primary, AppConst.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          Text(
            _userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // User Role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppConst.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _userRole,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConst.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              _buildInfoItem(Icons.person_outline, 'Full Name', _userName,
                  () => _editField('Full Name', _userName)),
              const Divider(height: 1),
              _buildInfoItem(
                  Icons.email_outlined,
                  'Email',
                  _userEmail.isEmpty ? 'Not provided' : _userEmail,
                  () => _editField('Email', _userEmail)),
              const Divider(height: 1),
              _buildInfoItem(
                  Icons.phone_outlined,
                  'Phone',
                  _userPhone.isEmpty ? 'Not provided' : _userPhone,
                  () => _editField('Phone', _userPhone)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      IconData icon, String label, String value, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConst.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppConst.primary,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.edit_outlined,
        color: Colors.grey[400],
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(
                    'Edit Profile', Icons.edit, _showEditProfileDialog)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionCard(
                    'Change Password', Icons.lock, _showChangePasswordDialog)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child:
                    _buildActionCard('Notifications', Icons.notifications, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Notifications settings coming soon!')),
              );
            })),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionCard(
                    'Help & Support', Icons.help, _navigateToHelpSupport)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConst.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppConst.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              _buildSettingsItem(Icons.privacy_tip_outlined, 'Privacy Policy',
                  _navigateToPrivacyPolicy),
              const Divider(height: 1),
              _buildSettingsItem(Icons.description_outlined, 'Terms of Service',
                  _navigateToTermsOfService),
              const Divider(height: 1),
              _buildSettingsItem(
                  Icons.info_outline, 'About App', _navigateToAboutApp),
              const Divider(height: 1),
              _buildSettingsItem(Icons.feedback_outlined, 'Send Feedback',
                  _navigateToSendFeedback),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showLogoutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[700],
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[200]!),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
