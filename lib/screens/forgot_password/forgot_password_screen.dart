import 'package:flutter/material.dart';
import '../../services/firebase_auth_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _loading = false;

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    String? result = await _authService.resetPassword(_emailController.text.trim());
    setState(() => _loading = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Instruções de recuperação enviadas para seu email.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.weekend, size: 80, color: AppColors.primary),
                SizedBox(height: 12),
                Text("EstofariaPro",
                    style: AppTypography.title.copyWith(color: AppColors.primary)),
                Text("A medida certa para tapeçar sua empresa",
                    style: AppTypography.subtitle.copyWith(color: Color(0xFF42585C))),
                SizedBox(height: 32),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Digite seu e-mail",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Informe seu email" : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                _loading
                    ? CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text("RECUPERAR ACESSO",
                              style: AppTypography.button.copyWith(color: Colors.white)),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
