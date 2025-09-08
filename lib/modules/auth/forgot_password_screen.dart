import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../services/firebase_auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _loading = false;

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    String? result = await _authService.resetPassword(_emailController.text.trim());
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result ?? 'Email enviado com sucesso!')),
    );
    if (result == null) Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Acesso'),
        backgroundColor: AppColors.primary,
        leading: IconButton(icon: Icon(Icons.close), onPressed: _cancel),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.lock_open, size: 80, color: AppColors.primary),
              SizedBox(height: 20),
              Text('EstofariaPro', style: AppTypography.title.copyWith(color: AppColors.primary)),
              SizedBox(height: 10),
              Text('Digite seu e-mail para recuperar a senha', style: AppTypography.subtitle.copyWith(color: AppColors.textSecondary)),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe seu e-mail';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Email inválido';
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Expanded(child: ElevatedButton(
                        onPressed: _resetPassword,
                        child: Text('ENVIAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 50),
                          textStyle: AppTypography.button,
                        ),
                      )),
                      SizedBox(width: 10),
                      Expanded(child: ElevatedButton(
                        onPressed: _cancel,
                        child: Text('CANCELAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: Size(double.infinity, 50),
                          textStyle: AppTypography.button,
                        ),
                      )),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
