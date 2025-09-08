import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'services/auth_service.dart';
import 'modules/auth/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Provider para gerenciamento de estado global (Auth)
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const EstofariaProApp(),
    ),
  );
}

class EstofariaProApp extends StatelessWidget {
  const EstofariaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EstofariaPro',
      debugShowCheckedModeBanner: false,
      
      // Tema global Couro Moderno - modo claro como padrão
      theme: EstofariaTheme.lightTheme,
      darkTheme: EstofariaTheme.darkTheme,
      themeMode: ThemeMode.system, // Seguir preferência do sistema
      
      home: const SplashScreen(), // Tela inicial = Splash
    );
  }
}
