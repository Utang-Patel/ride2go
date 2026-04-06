import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/header_logo.dart';
import 'package:ride2go/screens/main_shell.dart';
import 'package:ride2go/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validate() {
    setState(() {
      _isButtonEnabled = _identifierController.text.isNotEmpty &&
          _passwordController.text.length >= 6;
    });
  }

  @override
  void initState() {
    super.initState();
    _identifierController.addListener(_validate);
    _passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final loginId = _identifierController.text.trim();
    final loginPwd = _passwordController.text.trim();

    bool isSuccess = false;

    if (UserData.registeredEmail != null && UserData.registeredPhone != null) {
      if ((loginId == UserData.registeredEmail || loginId == UserData.registeredPhone) &&
          loginPwd == UserData.registeredPassword) {
        isSuccess = true;
      }
    }

    if (isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Please register first or check your details.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFF113469),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // Modular Responsive Header
              HeaderLogo(height: size.height * 0.35),

              // Form content
              Positioned(
                top: size.height * 0.3,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to continue your journey",
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Email or Phone Field
                      CustomTextField(
                        controller: _identifierController,
                        hint: 'Email ID or Phone Number',
                        icon: Icons.account_circle_outlined,
                      ),
                      const SizedBox(height: 16),
                      
                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      
                      const Spacer(),
                      
                      // Login Button
                      PrimaryButton(
                        text: 'Login',
                        isEnabled: _isButtonEnabled,
                        onPressed: _handleLogin,
                      ),
                      
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.outfit(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF113469),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
