import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kGreenDark = Color(0xFF1B5E20);
  static const Color kGreenLight = Color(0xFFE8F5E9);

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  File? image;
  XFile? _pickedX;
  final auth = AuthService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedX = picked;
        image = File(picked.path);
      });
    }
  }

  Future<void> _saveUserToDb({
    required String uid,
    required String name,
    required String email,
  }) async {
    String? imageBase64;
    if (_pickedX != null) {
      try {
        final bytes = await _pickedX!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      } catch (_) {
        imageBase64 = null;
      }
    }

    final url = Uri.parse(
      "https://jewelryapp-69ec8-default-rtdb.firebaseio.com/jewelryapp/users/$uid.json",
    );

    await http.put(
      url,
      body: jsonEncode({
        "uid": uid,
        "name": name,
        "email": email,
        "image": imageBase64,
        "createdAt": DateTime.now().toIso8601String(),
      }),
    );
  }

  void _clearInputs() {
    nameController.clear();
    emailController.clear();
    passController.clear();
    confirmController.clear();
    _formKey.currentState?.reset();
    setState(() {
      image = null;
      _pickedX = null;
    });
  }

  String? _validateName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your name';
    if (value.length < 2) return 'Name must be at least 2 characters';
    if (value.length > 40) return 'Name is too long (max 40 characters)';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!isLogin) {
      final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
      final hasNumber = RegExp(r'[0-9]').hasMatch(value);
      if (!hasLetter || !hasNumber) {
        return 'Password must include both letters and numbers';
      }
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if ((v ?? '').isEmpty) return 'Please confirm your password';
    if (v != passController.text) return 'Passwords do not match';
    return null;
  }

  void submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      showMsg('Please fix the errors above', isError: true);
      return;
    }

    setState(() => isLoading = true);

    String? error;
    String? newUid;
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (isLogin) {
      error = await auth.login(email, passController.text.trim());
    } else {
      final result = await auth.signUp(name, email, passController.text.trim());
      error = result.error;
      newUid = result.uid;
    }

    if (!mounted) return;

    if (error == null && !isLogin && newUid != null) {
      try {
        await _saveUserToDb(uid: newUid, name: name, email: email);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => isLoading = false);

    if (error != null) {
      showMsg(error, isError: true);
    } else {
      showMsg(
        isLogin ? 'Welcome back! ✓' : 'Account created successfully ✓',
        isError: false,
      );
      _clearInputs();
    }
  }

  void showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFD32F2F) : kGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kGreen),
      suffixIcon: suffix,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade100, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kGreen, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 1.8),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFD32F2F),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _toggleTab(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final wantLogin = label == 'Login';
          if (wantLogin != isLogin) {
            setState(() {
              isLogin = wantLogin;
              _formKey.currentState?.reset();
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : kGreenDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: !isLogin ? pickImage : null,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.white,
                              backgroundImage: image != null
                                  ? FileImage(image!)
                                  : null,
                              child: image == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 46,
                                      color: kGreen,
                                    )
                                  : null,
                            ),
                            if (!isLogin)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: kGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isLogin ? 'Welcome Back' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kGreenDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLogin
                            ? 'Sign in to continue shopping'
                            : 'Join us and discover beautiful jewelry',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _toggleTab('Login', isLogin),
                      _toggleTab('Sign Up', !isLogin),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (!isLogin) ...[
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                    decoration: _inputDecoration(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: _inputDecoration(
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                  ),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: passController,
                  obscureText: obscurePass,
                  textInputAction: isLogin
                      ? TextInputAction.done
                      : TextInputAction.next,
                  validator: _validatePassword,
                  decoration: _inputDecoration(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePass ? Icons.visibility_off : Icons.visibility,
                        color: kGreen,
                      ),
                      onPressed: () =>
                          setState(() => obscurePass = !obscurePass),
                    ),
                  ),
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: confirmController,
                    obscureText: obscureConfirm,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirm,
                    decoration: _inputDecoration(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kGreen,
                        ),
                        onPressed: () =>
                            setState(() => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.green.shade200,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            isLogin ? 'Login' : 'Create Account',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? "Don't have an account?"
                          : 'Already have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          _formKey.currentState?.reset();
                        });
                      },
                      style: TextButton.styleFrom(foregroundColor: kGreen),
                      child: Text(
                        isLogin ? 'Sign Up' : 'Login',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
