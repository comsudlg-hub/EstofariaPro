import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/onboarding_widgets/onboarding_carousel.dart';
import '../../widgets/onboarding_widgets/onboarding_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  final List<OnboardingStep> steps = [
    OnboardingStep(
      title: "Bem-vindo ao EstofariaPro",
      description: "Gerencie sua estofaria de forma simples e eficiente.",
      imagePath: "assets/images/onboarding/welcome.png",
    ),
    OnboardingStep(
      title: "Controle de Pedidos",
      description: "Acompanhe seus pedidos, orçamentos e entregas.",
      imagePath: "assets/images/onboarding/orders.png",
    ),
    OnboardingStep(
      title: "Gestão de Materiais",
      description: "Organize seu estoque e mantenha tudo sob controle.",
      imagePath: "assets/images/onboarding/materials.png",
    ),
    OnboardingStep(
      title: "Notificações e Alertas",
      description: "Receba atualizações em tempo real e mantenha sua equipe informada.",
      imagePath: "assets/images/onboarding/notifications.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.couroPrimary, AppColors.couroSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: OnboardingCarousel(
                  steps: steps,
                  currentIndex: currentIndex,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    steps.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: currentIndex == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.couroPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  onPressed: () {
                    // Navegar para próximo módulo ou dashboard
                  },
                  child: Text(
                    currentIndex == steps.length - 1 ? "Começar" : "Próximo",
                    style: AppTypography.button.copyWith(color: Colors.white),
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
