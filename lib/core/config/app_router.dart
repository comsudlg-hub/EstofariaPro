import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/reset_password_screen.dart';
import '../../presentation/screens/auth/summary_screen.dart';
import '../../presentation/screens/dashboard/client_dashboard.dart';
import '../../presentation/screens/dashboard/estofaria_dashboard.dart';
import '../../presentation/screens/dashboard/fornecedor_dashboard.dart';
import '../../presentation/screens/dashboard/admin_dashboard.dart';

// Novas telas do submenu Vendas (Estofaria)
import '../../presentation/screens/workshop/sales/pedido_orcamento_screen.dart';
import '../../presentation/screens/workshop/sales/enviar_orcamento_screen.dart';
import '../../presentation/screens/workshop/sales/agendar_visita_screen.dart';
import '../../presentation/screens/workshop/sales/ordem_servico_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/reset-password', builder: (context, state) => const ResetPasswordScreen()),
    GoRoute(path: '/summary', builder: (context, state) => const SummaryScreen()),

    // Dashboards
    GoRoute(path: '/client-dashboard', builder: (context, state) => const ClientDashboard()),
    GoRoute(path: '/estofaria-dashboard', builder: (context, state) => const EstofariaDashboard()),
    GoRoute(path: '/fornecedor-dashboard', builder: (context, state) => const FornecedorDashboard()),
    GoRoute(path: '/admin-dashboard', builder: (context, state) => const AdminDashboard()),

    // Submenu Vendas da Estofaria
    GoRoute(
      path: '/estofaria-dashboard/pedido-orcamento',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final docId = extra?['docId'] ?? '';
        final pedidoIdCompleto = extra?['pedidoIdCompleto'] ?? ''; // Ajuste solicitado: Corrigido para ler o parâmetro correto.
        return PedidoOrcamentoScreen(
          docId: docId,
          pedidoIdCompleto: pedidoIdCompleto, // Ajuste solicitado: Corrigido para passar o parâmetro com o nome correto.
          fromPanel: 'estofaria', // ✅ parâmetro já tratado no Screen
        );
      },
    ),
    GoRoute(
      path: '/client-dashboard/pedido-orcamento',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final docId = extra?['docId'] ?? '';
        final pedidoIdCompleto = extra?['pedidoIdCompleto'] ?? ''; // Ajuste solicitado: Corrigido para ler o parâmetro correto.
        return PedidoOrcamentoScreen(
          docId: docId,
          pedidoIdCompleto: pedidoIdCompleto, // Ajuste solicitado: Corrigido para passar o parâmetro com o nome correto.
          fromPanel: 'cliente', // ✅ parâmetro já tratado no Screen
        );
      },
    ),
    GoRoute(
      path: '/estofaria-dashboard/enviar-orcamento',
      builder: (context, state) => const EnviarOrcamentoScreen(),
    ),
    GoRoute(
      path: '/estofaria-dashboard/agendar-visita',
      builder: (context, state) => const AgendarVisitaScreen(),
    ),
    GoRoute(
      path: '/estofaria-dashboard/ordem-servico',
      builder: (context, state) => const OrdemServicoScreen(),
    ),
  ],
);
