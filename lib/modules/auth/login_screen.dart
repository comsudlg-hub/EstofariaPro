import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_auth_service.dart';
import '../register/register_screen.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    String? result = await _authService.signIn(
        _emailController.text.trim(), _passwordController.text.trim());
    setState(() => _loading = false);

    if (result == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login realizado com sucesso!')));
      // Navegue para a tela principal do app aqui
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  void _cancel() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.weekend, size: 80, color: AppColors.primary),
                SizedBox(height: 10),
                Text(
                  'EstofariaPro',
                  style: AppTypography.title.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 4),
                Text(
                  'A medida certa para sua estofaria',
                  style: AppTypography.subtitle.copyWith(color: AppColors.accent),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Digite seu e-mail ou login',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary)),
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: AppColors.secondary.withOpacity(0.2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Informe seu email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) return 'Email inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Digite sua senha',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary)),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: AppColors.secondary.withOpacity(0.2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Informe sua senha';
                    if (value.length < 6) return 'Senha deve ter ao menos 6 caracteres';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen())),
                    child: Text('Recuperar Acesso'),
                  ),
                ),
                SizedBox(height: 20),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('ENTRAR', style: TextStyle(letterSpacing: 1.5)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          textStyle: AppTypography.button,
                          elevation: 3,
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não tem conta?', style: TextStyle(color: Colors.grey[700])),
                    TextButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            ),
                        child: Text('CRIE AGORA', style: TextStyle(color: AppColors.primary))),
                  ],
                ),
                SizedBox(height: 16),
                Text('@ Copyright', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
