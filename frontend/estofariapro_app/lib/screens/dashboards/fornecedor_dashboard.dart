import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FornecedorDashboard extends StatelessWidget {
  const FornecedorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebe7dc),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42585c)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Painel do Fornecedor',
          style: GoogleFonts.zenAntiqueSoft(
            color: const Color(0xFF42585c),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFebe7dc),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 80, color: const Color(0xFF9C8158)),
            const SizedBox(height: 20),
            Text(
              "Bem-vindo, Fornecedor!",
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF2f4653),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Área exclusiva para fornecedores da plataforma",
              style: GoogleFonts.roboto(
                color: const Color(0xFF2f4653),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
