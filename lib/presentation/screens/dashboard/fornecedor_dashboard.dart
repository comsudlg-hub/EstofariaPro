import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/product_provider.dart';
import '../../../state/order_provider.dart';

class FornecedorDashboard extends StatefulWidget {
  const FornecedorDashboard({super.key});

  @override
  State<FornecedorDashboard> createState() => _FornecedorDashboardState();
}

class _FornecedorDashboardState extends State<FornecedorDashboard> {
  int _currentIndex = 0;

  final _pages = const [
    Center(child: Text("Meus Produtos")),
    Center(child: Text("Pedidos de Estofarias")),
    Center(child: Text("Perfil")),
  ];

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Fornecedor")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Produtos"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Pedidos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
