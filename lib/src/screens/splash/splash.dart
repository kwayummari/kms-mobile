// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:kms/src/functions/splash.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _vibrateController;
  late AnimationController _scaleController;
  late Animation<double> _vibrateAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _vibrateController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Initialize vibration animation
    _vibrateAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _vibrateController,
      curve: Curves.easeInOut,
    ));

    // Initialize scale animation (grows from 1.0 to 2.0)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _vibrateController.repeat(reverse: true);
    _scaleController.forward();

    // Navigate after animation completes
    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SplashFunction().navigatorToHome(context);
      }
    });
  }

  @override
  void dispose() {
    _vibrateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area with vibrating and scaling logo
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([_vibrateAnimation, _scaleAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_vibrateAnimation.value, 0),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Privacy text at bottom
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Privacy & Data Protection',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConst.black.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
