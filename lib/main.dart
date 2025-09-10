import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart'; // <- gerado pelo flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EstofariaApp());
}

class EstofariaApp extends StatelessWidget {
  const EstofariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Estofaria Pro',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
