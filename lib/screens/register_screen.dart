import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/header_logo.dart';
import 'package:ride2go/screens/login_screen.dart';

class UserData {
  static String? registeredEmail = 'admin@test.com';
  static String? registeredPhone = '1234567890';
  static String? registeredPassword = 'password123';
  static String? registeredName = 'Test Admin';
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isButtonEnabled = false;

  void _validate() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.length == 10 &&
          _passwordController.text.length >= 6;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validate);
    _emailController.addListener(_validate);
    _phoneController.addListener(_validate);
    _passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        "Create Account",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join our community and start riding!",
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Name Field
                      CustomTextField(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      
                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        hint: 'Email ID',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone Field
                      CustomTextField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
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
                      
                      // Register Button
                      PrimaryButton(
                        text: 'Register',
                        isEnabled: _isButtonEnabled,
                        onPressed: () {
                          // Store "mock" registration data (with trimming)
                          UserData.registeredName = _nameController.text.trim();
                          UserData.registeredEmail = _emailController.text.trim().toLowerCase();
                          UserData.registeredPhone = _phoneController.text.trim();
                          UserData.registeredPassword = _passwordController.text.trim();
                          
                          // Navigate to Login
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.outfit(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              "Login",
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
