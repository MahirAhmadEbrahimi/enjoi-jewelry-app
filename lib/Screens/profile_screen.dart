import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLogin = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  File? image;

  final auth = AuthService();

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  void submit() async {
    if (isLogin) {
      final error = await auth.login(
        emailController.text.trim(),
        passController.text.trim(),
      );

      if (error != null) {
        showMsg(error);
      } else {
        showMsg("Login Success ✅");
      }
    } else {
      if (passController.text != confirmController.text) {
        showMsg("Passwords not match");
        return;
      }

      final error = await auth.signUp(
        nameController.text.trim(),
        emailController.text.trim(),
        passController.text.trim(),
      );

      if (error != null) {
        showMsg(error);
      } else {
        showMsg("Signup Success ✅");
      }
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isLogin)
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: image != null ? FileImage(image!) : null,
                  child: image == null ? const Icon(Icons.camera_alt) : null,
                ),
              ),

            const SizedBox(height: 20),

            if (!isLogin)
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            if (!isLogin)
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: submit,
              child: Text(isLogin ? "Login" : "Sign Up"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin ? "Create Account" : "Already have account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
