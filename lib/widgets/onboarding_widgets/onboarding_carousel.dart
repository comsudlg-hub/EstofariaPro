import 'package:flutter/material.dart';
import 'onboarding_step.dart';

class OnboardingCarousel extends StatelessWidget {
  final List<OnboardingStep> steps;
  final int currentIndex;
  final Function(int) onPageChanged;

  const OnboardingCarousel({
    Key? key,
    required this.steps,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: steps.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(step.imagePath, height: 250),
            SizedBox(height: 24),
            Text(
              step.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              step.description,
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
