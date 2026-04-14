import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  bool isLoading = false;

  /// ================= SEND MESSAGE =================
  Future<void> sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final url = Uri.parse(
      "https://jewelryapp-69ec8-default-rtdb.firebaseio.com/jewelryapp/contact.json",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "message": messageController.text.trim(),
          "time": DateTime.now().toString(),
        }),
      );

      if (response.statusCode == 200) {
        nameController.clear();
        emailController.clear();
        messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Message Sent Successfully ✅",
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error sending message ❌")));
    }

    setState(() => isLoading = false);
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F3),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// ICON
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xff8BA37E),
                  child: Icon(Icons.call, color: Colors.white, size: 30),
                ),

                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2F4F2F),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "We’re here to help you with any questions or concerns.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 30),

                /// FORM CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _input(
                        controller: nameController,
                        hint: "Your Name",
                        validator: (v) => v!.isEmpty ? "Enter name" : null,
                      ),

                      const SizedBox(height: 15),

                      _input(
                        controller: emailController,
                        hint: "Your Email",
                        validator: (v) {
                          if (v!.isEmpty) return "Enter email";
                          if (!v.contains("@")) return "Invalid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      _input(
                        controller: messageController,
                        hint: "Your Message...",
                        maxLines: 4,
                        validator: (v) => v!.isEmpty ? "Enter message" : null,
                      ),

                      const SizedBox(height: 25),

                      /// SEND BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isLoading ? null : sendMessage,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Send Message →",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// CONTACT INFO
                _info(Icons.phone, "+1 234 567 890"),
                _info(Icons.email, "support@enjoi.jewelry"),
                _info(Icons.location_on, "123 Jewelry Lane, City, Country"),

                const SizedBox(height: 20),

                const Text(
                  "Follow Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(child: Icon(Icons.phone)),
                    SizedBox(width: 15),
                    CircleAvatar(child: Icon(Icons.facebook)),
                    SizedBox(width: 15),
                    CircleAvatar(child: Icon(Icons.camera_alt)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= INPUT FIELD =================
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffF3F4F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// ================= INFO TILE =================
  Widget _info(IconData icon, String text) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xffDCE5D8),
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(text),
    );
  }
}
