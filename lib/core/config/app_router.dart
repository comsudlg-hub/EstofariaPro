import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/reset_password_screen.dart';
import '../../presentation/screens/auth/summary_screen.dart';
import '../../presentation/screens/dashboard/client_dashboard.dart';
import '../../presentation/screens/dashboard/estofaria_dashboard.dart';
import '../../presentation/screens/dashboard/fornecedor_dashboard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/reset-password', builder: (context, state) => const ResetPasswordScreen()),
    GoRoute(path: '/summary', builder: (context, state) => const SummaryScreen()),
    GoRoute(path: '/client-dashboard', builder: (context, state) => const ClientDashboard()),
    GoRoute(path: '/estofaria-dashboard', builder: (context, state) => const EstofariaDashboard()),
    GoRoute(path: '/fornecedor-dashboard', builder: (context, state) => const FornecedorDashboard()),
  ],
);
