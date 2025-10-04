import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/order_provider.dart';
import '../../../state/budget_provider.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  int _currentIndex = 0;

  final _pages = const [
    Center(child: Text("Meus Pedidos")),
    Center(child: Text("Meus Orçamentos")),
    Center(child: Text("Perfil")),
  ];

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final budgetProvider = context.watch<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cliente")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Pedidos"),
          BottomNavigationBarItem(icon: Icon(Icons.request_quote), label: "Orçamentos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
