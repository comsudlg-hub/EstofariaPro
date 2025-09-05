import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
          headlineSmall: GoogleFonts.playfairDisplay(
            color: const Color(0xFF2f4653),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: GoogleFonts.zenAntiqueSoft(
            color: const Color(0xFF42585c),
            fontSize: 18,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo padrão Material 3
            Icon(Icons.chair, size: 80, color: const Color(0xFF9C8158)),

            const SizedBox(height: 16),

            // Marca EstofariaPro
            Text(
              "EstofariaPro",
              style: GoogleFonts.zenAntiqueSoft(
                color: const Color(0xFF42585c),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Slogan oficial
            Text(
              "A medida certa para sua estofaria",
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF2f4653),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
