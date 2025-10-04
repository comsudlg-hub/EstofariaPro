import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final _pages = const [
    Center(child: Text("Usuários")),
    Center(child: Text("Supervisão do Sistema")),
    Center(child: Text("Perfil")),
  ];

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Administração")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Usuários"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Sistema"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
