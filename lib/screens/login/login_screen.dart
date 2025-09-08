import 'package:flutter/material.dart';
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
      // TODO: Redirecionar para dashboard
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logotipo
                Icon(Icons.weekend, size: 80, color: AppColors.primary),
                SizedBox(height: 12),
                Text("EstofariaPro",
                    style: AppTypography.title.copyWith(color: AppColors.primary)),
                Text("A medida certa para tapeçar sua empresa",
                    style: AppTypography.subtitle.copyWith(color: Color(0xFF42585C))),
                SizedBox(height: 32),

                // Caixa de login
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Digite seu e-mail ou login",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe seu login ou email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Digite sua senha",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe sua senha";
                          }
                          if (value.length < 6) {
                            return "Senha deve ter ao menos 6 caracteres";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: Text("Recuperar Acesso",
                              style: TextStyle(color: AppColors.accent)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Botão Entrar
                _loading
                    ? CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text("ENTRAR",
                              style: AppTypography.button
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                SizedBox(height: 16),

                // Cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Não tem conta?",
                        style: AppTypography.body
                            .copyWith(color: AppColors.textSecondary)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text("CRIE AGORA",
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Rodapé
                Text("© Copyright",
                    style: AppTypography.body
                        .copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
