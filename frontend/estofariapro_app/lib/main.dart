import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import das telas
import 'screens/common/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/cadastro_screen.dart';
import 'screens/auth/recuperar_senha_screen.dart';
import 'screens/dashboards/estofaria_dashboard.dart';
import 'screens/dashboards/fornecedor_dashboard.dart';
import 'screens/dashboards/cliente_dashboard.dart';
import 'screens/dashboards/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EstofariaProApp());
}

class EstofariaProApp extends StatelessWidget {
  const EstofariaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EstofariaPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C8158),
          background: const Color(0xFFebe7dc),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/recuperar-senha': (context) => const RecuperarSenhaScreen(),
        '/dashboard-estofaria': (context) => const EstofariaDashboard(),
        '/dashboard-fornecedor': (context) => const FornecedorDashboard(),
        '/dashboard-cliente': (context) => const ClienteDashboard(),
        '/dashboard-admin': (context) => const AdminDashboard(),
      },
    );
  }
}