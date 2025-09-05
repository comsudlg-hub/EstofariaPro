import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstofariaDashboard extends StatefulWidget {
  const EstofariaDashboard({super.key});

  @override
  State<EstofariaDashboard> createState() => _EstofariaDashboardState();
}

class _EstofariaDashboardState extends State<EstofariaDashboard> {
  String _menuAtivo = 'Vendas';

  Color _getCorStatus(String status) {
    switch (status) {
      case 'Aguardando':
        return const Color(0xFFFFA726);
      case 'Precificando':
        return const Color(0xFF42A5F5);
      case 'Aprovado':
        return const Color(0xFF66BB6A);
      default:
        return Colors.grey;
    }
  }

  void _mostrarDetalhesPedido() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Pedido'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cliente: Maria Silva'),
              Text('Serviço: Reforma de Sofá 3 lugares'),
              Text('Status: Aguardando'),
              SizedBox(height: 16),
              Text('Histórico:'),
              Text('- Pedido criado em 05/09/2025'),
              Text('- Orçamento enviado em 06/09/2025'),
              SizedBox(height: 16),
              Text('Valor: R\$ 1.250,00'),
              Text('Prazo: 15 dias úteis'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

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
          'Painel de Controle EstofariaPro',
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
            Icon(Icons.chair, size: 80, color: const Color(0xFF9C8158)),
            const SizedBox(height: 20),
            Text(
              "Bem-vindo à EstofariaPro!",
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF2f4653),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Dashboard para estofarias",
              style: GoogleFonts.roboto(
                color: const Color(0xFF2f4653),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _mostrarDetalhesPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C8158),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Ver Detalhes de Exemplo'),
            ),
          ],
        ),
      ),
    );
  }
}
