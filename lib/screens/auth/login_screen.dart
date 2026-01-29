import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/widgets/field_custom.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:aplikasi_pinjam_ukk/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Clear semua error saat screen dibuka
    authController.emailError.value = '';
    authController.passwordError.value = '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await authController.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Sizes.xxl),
              Text(
                'CasHieR',
                style: TextStyle(
                  color: AppColors.Blue,
                  fontSize: Sizes.fontSizeB,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Sizes.xxl),
              
              // Email Field Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => CustomInputField(
                  controller: _emailController,
                  label: 'Email address',
                  hintText: 'EMAIL',
                  errorText: authController.emailError.value,
                  showError: authController.emailError.value.isNotEmpty,
                  enabled: !authController.isLoading.value,
                  keyboardType: TextInputType.emailAddress,
                  autoFocus: true,
                  onChanged: (value) {
                    if (authController.emailError.value.isNotEmpty) {
                      authController.emailError.value = '';
                    }
                  },
                )),
              ),
              
              const SizedBox(height: Sizes.lg),
              
              // Password Field Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => CustomInputField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'PASSWORD',
                  obscureText: _obscurePassword,
                  errorText: authController.passwordError.value,
                  showError: authController.passwordError.value.isNotEmpty,
                  enabled: !authController.isLoading.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      color: Colors.grey[500],
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  onChanged: (value) {
                    if (authController.passwordError.value.isNotEmpty) {
                      authController.passwordError.value = '';
                    }
                  },
                )),
              ),
              
              const SizedBox(height: Sizes.xxl),
              
              // Login Button
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.Blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: authController.isLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              color: AppColors.White,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                );
              }),
              
              SizedBox(height: Sizes.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
