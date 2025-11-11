import 'package:kms/src/provider/login-provider.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:kms/src/gateway/registration-services.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  // Form controllers
  TextEditingController username = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  // Form state
  bool obscure = true;
  int currentStep = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Step data
  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Welcome!',
      'subtitle': 'Let\'s create your account',
      'fields': ['username', 'fullname'],
    },
    {
      'title': 'Contact Info',
      'subtitle': 'How can we reach you?',
      'fields': ['email', 'phone'],
    },
    {
      'title': 'Secure Account',
      'subtitle': 'Create a strong password',
      'fields': ['password'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        currentStep++;
      });
      _slideController.reset();
      _slideController.forward();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _slideController.reset();
      _slideController.forward();
    }
  }

  bool _validateCurrentStep() {
    final currentStepData = steps[currentStep];
    final fields = currentStepData['fields'] as List<String>;

    for (String field in fields) {
      switch (field) {
        case 'username':
          if (username.text.isEmpty) {
            _showError('Username is required');
            return false;
          }
          if (username.text.length < 3 || username.text.length > 50) {
            _showError('Username must be between 3 and 50 characters');
            return false;
          }
          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username.text)) {
            _showError(
                'Username can only contain letters, numbers, and underscores');
            return false;
          }
          break;
        case 'fullname':
          if (fullname.text.isEmpty) {
            _showError('Full name is required');
            return false;
          }
          if (fullname.text.length > 100) {
            _showError('Full name cannot exceed 100 characters');
            return false;
          }
          break;
        case 'email':
          if (email.text.isNotEmpty &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(email.text)) {
            _showError('Please provide a valid email address');
            return false;
          }
          break;
        case 'phone':
          if (phone.text.isEmpty) {
            _showError('Phone number is required');
            return false;
          }
          if (phone.text.length < 9 || phone.text.length > 20) {
            _showError('Phone number must be between 9 and 20 characters');
            return false;
          }
          if (!RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(phone.text)) {
            _showError('Please provide a valid phone number');
            return false;
          }
          break;
        case 'password':
          if (password.text.isEmpty) {
            _showError('Password is required');
            return false;
          }
          if (password.text.length < 8) {
            _showError('Password must be at least 8 characters');
            return false;
          }
          if (!RegExp(r'\d').hasMatch(password.text)) {
            _showError('Password must contain at least one number');
            return false;
          }
          if (!RegExp(r'[A-Z]').hasMatch(password.text)) {
            _showError('Password must contain at least one uppercase letter');
            return false;
          }
          break;
      }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _submitRegistration() {
    if (_validateCurrentStep()) {
      // Update the registration service call to include username
      registrationService().registration(
        context,
        username.text,
        password.text,
        password.text, // confirm password
        fullname.text,
        email.text,
        phone.text,
      );
    }
  }

  Widget _buildField(String fieldType) {
    switch (fieldType) {
      case 'username':
        return _buildInputField(
          controller: username,
          hint: 'Username',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username is required';
            }
            if (value.length < 3 || value.length > 50) {
              return 'Username must be between 3 and 50 characters';
            }
            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
              return 'Username can only contain letters, numbers, and underscores';
            }
            return null;
          },
        );
      case 'fullname':
        return _buildInputField(
          controller: fullname,
          hint: 'Full Name',
          icon: Icons.badge_outlined,
        );
      case 'email':
        return _buildInputField(
          controller: email,
          hint: 'Email Address (Optional)',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        );
      case 'phone':
        return _buildInputField(
          controller: phone,
          hint: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        );
      case 'password':
        return _buildPasswordField();
      default:
        return Container();
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppConst.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConst.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppConst.grey.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: AppConst.grey.withOpacity(0.7),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: AppConst.black,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppConst.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConst.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: password,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
            color: AppConst.grey.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppConst.grey.withOpacity(0.7),
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscure = !obscure;
              });
            },
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppConst.grey.withOpacity(0.7),
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: AppConst.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    final currentStepData = steps[currentStep];

    return Scaffold(
      backgroundColor: AppConst.white,
      appBar: AppBar(
        backgroundColor: AppConst.white,
        elevation: 0,
        leading: currentStep == 0
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppConst.black,
                  size: 20,
                ),
              )
            : IconButton(
                onPressed: _previousStep,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppConst.black,
                  size: 20,
                ),
              ),
        title: Text(
          'Step ${currentStep + 1} of ${steps.length}',
          style: TextStyle(
            color: AppConst.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Progress indicator
                      Row(
                        children: List.generate(steps.length, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(
                                right: index < steps.length - 1 ? 8 : 0,
                              ),
                              decoration: BoxDecoration(
                                color: index <= currentStep
                                    ? AppConst.primary
                                    : AppConst.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 40),

                      // Step title and subtitle
                      Text(
                        currentStepData['title'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppConst.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        currentStepData['subtitle'],
                        style: TextStyle(
                          fontSize: 16,
                          color: AppConst.black.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Form fields for current step
                      Expanded(
                        child: Column(
                          children: [
                            ...(currentStepData['fields'] as List<String>)
                                .map((field) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: _buildField(field),
                                    ))
                                .toList(),

                            const Spacer(),

                            // Action button
                            _LoadingButton(
                              isLoading: myProvider.myLoging,
                              onPressed: currentStep == steps.length - 1
                                  ? _submitRegistration
                                  : _nextStep,
                              child: Text(
                                currentStep == steps.length - 1
                                    ? 'Create Account'
                                    : 'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Terms and conditions
                            Text(
                              'By creating an account, you agree to our Terms and Conditions and Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConst.grey.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                            // Sign in link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConst.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.login,
                                  ),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppConst.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;

  const _LoadingButton({
    required this.isLoading,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConst.primary,
          foregroundColor: AppConst.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppConst.white),
                ),
              )
            : child,
      ),
    );
  }
}
