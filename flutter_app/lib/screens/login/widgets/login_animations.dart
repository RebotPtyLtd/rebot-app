import 'package:flutter/material.dart';

class LoginAnimations {
  final TickerProvider vsync;

  late AnimationController bubbleController;
  late Animation<double> bubbleAnimation;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  late AnimationController slideController;
  late Animation<double> slideAnimation;
  late Animation<double> delayAnimation;
  late Animation<double> delaySubAnimation;

  LoginAnimations(this.vsync) {
    fadeController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);

    bubbleController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
    bubbleAnimation = Tween<double>(begin: 50.0, end: 60.0).animate(
      CurvedAnimation(parent: bubbleController, curve: Curves.easeInOut),
    );

    bubbleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bubbleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        bubbleController.forward();
      }
    });

    slideController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    );

    slideAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: slideController, curve: Curves.fastOutSlowIn),
    );
    delaySubAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: slideController,
        curve: const Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    delayAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: slideController,
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fadeController.forward();
      }
    });
  }

  void dispose() {
    bubbleController.dispose();
    fadeController.dispose();
    slideController.dispose();
  }
}
