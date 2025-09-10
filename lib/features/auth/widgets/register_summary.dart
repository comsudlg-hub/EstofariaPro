import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class RegisterSummary extends StatelessWidget {
  final Map<String, String> data;

  const RegisterSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirme seus dados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: data.entries.map((e) => ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(e.key),
                  subtitle: Text(e.value),
                )).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final auth = AuthService();
                try {
                  await auth.register(data['E-mail']!, data['Senha']!);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar: \')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
