import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animação de fade-in e scale
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.forward();
    
    // Verificar autenticação após a animação
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Aguardar a animação completar
    await Future.delayed(const Duration(milliseconds: 2000));
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = await authService.checkAuthStatus();
    
    // Navegar para a tela apropriada baseado no status de autenticação
    if (mounted) {
      if (isLoggedIn) {
        // Navigator.pushReplacementNamed(context, '/dashboard');
        print('Usuário autenticado - redirecionando para dashboard');
      } else {
        // Navigator.pushReplacementNamed(context, '/login');
        print('Usuário não autenticado - redirecionando para login');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: EstofariaColors.primaryGradient,
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone de Sofá usando Material Icons (já incluído no Flutter)
                const Icon(
                  Icons.chair, // Ícone de cadeira/sofá
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                
                // Nome da Marca - EstofariaPro
                Text(
                  'EstofariaPro',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                
                // Copyright Compersonalite
                const SizedBox(height: 100),
                Text(
                  '© 2024 Compersonalite Soluções Estratégicas',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
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
