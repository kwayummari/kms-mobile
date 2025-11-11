import 'package:kms/src/provider/login-provider.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:kms/src/gateway/login-services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool dont_show_password = true;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);

    return Scaffold(
      backgroundColor: AppConst.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight,
                  ),
                  child: Column(
                    children: [
                      // Top spacing
                      const SizedBox(height: 60),

                      // Logo section
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppConst.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppConst.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppConst.black.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username field
                            Container(
                              decoration: BoxDecoration(
                                color: AppConst.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppConst.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: username,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    color: AppConst.grey.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Password field
                            Container(
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
                                obscureText: dont_show_password,
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
                                        dont_show_password =
                                            !dont_show_password;
                                      });
                                    },
                                    icon: Icon(
                                      dont_show_password
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppConst.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Login button
                            _LoadingButton(
                              isLoading: myProvider.myLoging,
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                loginService().login(
                                  context,
                                  username.text,
                                  password.text,
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 50),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConst.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.registration,
                                  ),
                                  child: Text(
                                    'Sign Up',
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

                            // Terms
                            Text(
                              'By continuing you agree to our Terms and Conditions',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConst.grey.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
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
