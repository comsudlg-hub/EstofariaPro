import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecuperarSenhaScreen extends StatelessWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebe7dc),
      appBar: AppBar(
        title: Text(
          "Recuperar Senha",
          style: GoogleFonts.zenAntiqueSoft(
            color: const Color(0xFF42585c),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFebe7dc),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42585c)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Icon(Icons.chair, size: 60, color: const Color(0xFF9C8158)),
              const SizedBox(height: 16),
              Text(
                "EstofariaPro",
                style: GoogleFonts.zenAntiqueSoft(
                  color: const Color(0xFF42585c),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Recupere sua senha",
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFF2f4653),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "Informe seu email para receber instruções de recuperação de senha",
                style: GoogleFonts.roboto(
                  color: const Color(0xFF2f4653),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: GoogleFonts.roboto(color: const Color(0xFF42585c)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9C8158)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9C8158), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Simulação de envio de email
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Email de recuperação enviado!",
                        style: GoogleFonts.roboto(),
                      ),
                      backgroundColor: const Color(0xFF9C8158),
                    ),
                  );
                  
                  // Volta para login após 2 segundos
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF9C8158),
                ),
                child: Text(
                  "Enviar Email",
                  style: GoogleFonts.zenAntiqueSoft(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
