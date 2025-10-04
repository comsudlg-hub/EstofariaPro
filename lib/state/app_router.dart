import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart'; // Assumindo que este caminho está correto
import '../../features/auth/register_screen.dart'; // Correção: Caminho para a tela de registro
import '../../presentation/screens/dashboard/estofaria_dashboard.dart';
import '../../presentation/screens/dashboard/my_profile_screen.dart';
import '../../presentation/screens/dashboard/change_password_screen.dart';
import '../../presentation/common_widgets/pedido_orcamento_form.dart';
import '../../presentation/screens/workshop/sales/enviar_orcamento_screen.dart'; // Adicionado: Import para a tela de orçamento

class AppRouter {
  final AuthProvider authProvider;

  AppRouter({required this.authProvider});

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      // Rotas autenticadas
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const EstofariaDashboard();
        },
        routes: [
          GoRoute(
            path: 'estofaria-dashboard/pedido-orcamento',
            builder: (context, state) {
              // Extrai os parâmetros passados durante a navegação
              final extra = state.extra as Map<String, dynamic>?;
              final docId = extra?['docId'] as String?;
              final pedidoIdCompleto = extra?['pedidoIdCompleto'] as String?;
              return PedidoOrcamentoForm(
                docId: docId,
                pedidoIdCompleto: pedidoIdCompleto,
              );
            },
          ),
          GoRoute(
            path: 'enviar-orcamento/:docId', // Adicionado: Rota para enviar orçamento
            builder: (context, state) {
              final docId = state.pathParameters['docId']!;
              return EnviarOrcamentoScreen(docId: docId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const MyProfileScreen();
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordScreen();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authProvider.currentUser != null;
      final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!loggedIn && !isLoggingIn) {
        return '/login'; // Redireciona para o login se não estiver logado e não estiver na tela de login/registro
      }
      if (loggedIn && isLoggingIn) {
        return '/'; // Redireciona para o dashboard se já estiver logado e tentar acessar login/registro
      }
      return null; // Nenhuma ação de redirecionamento necessária
    },
  );
}