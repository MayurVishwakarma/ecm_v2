// ignore_for_file: use_build_context_synchronously

import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ConnectivityProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ConnectivityProvider>(
        builder: (context, ap, cp, child) {
          return !cp.isOnline
              ? Center(
                  child: Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/SeLogo.png', height: 120),
                          SizedBox(height: 16),
                          Text(
                            'Saisanket',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4FAD55),
                            ),
                          ),
                          Text(
                            'Erection Commission & Maintenance',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 32),
                          _buildTextFormField(
                            Icons.person,
                            'Username',
                            userIdController,
                            inputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildTextFormField(
                            Icons.lock,
                            'Password',
                            passwordController,
                            obscure: true,
                            ispassword: true,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  // Call the login function from AuthProvider
                                  await context
                                      .read<AuthProvider>()
                                      .getUserLogin(
                                        userIdController.text,
                                        passwordController.text,
                                        context,
                                      );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 2),

                                      content: Text(
                                        "Opps!!! something went wrong you cannot login in to ECM !",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4FAD55),
                              minimumSize: Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildTextFormField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool ispassword = false,
  }) {
    return TextFormField(
      obscureText: ispassword ? isObscure : obscure, // ✅ use toggle
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hint is required';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // ✅ Add show/hide password button
        suffixIcon: ispassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure; // toggle state
                  });
                },
              )
            : null,
      ),
    );
  }

  /*Widget _buildTextFormField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType inputType = TextInputType.text, // ✅ let user choose type
    List<TextInputFormatter>? inputFormatters, // ✅ optional formatters
    bool ispassword = false,
  }) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      keyboardType: inputType, // ✅ set keyboard type
      inputFormatters: inputFormatters, // ✅ apply restrictions if given
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hint is required';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        filled: true,

        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
*/
}
