import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Bienvenido Coffee Lover!",
      body:
          "Desliza para ver algunos consejos útiles sobre cómo preparar café con esta app.",
      image: _buildImage('intro1'), // Replace with your image path
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 234, 75, 94),
            fontSize: 28,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    PageViewModel(
      title: "Prepara todo el café que necesites",
      body:
          "Ajusta los valores en la página de recetas y obtén todas las recetas personalizadas a tu preferencia.",
      image: _buildImage('intro2', isGif: true), // Replace with your image path
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 234, 75, 94),
            fontSize: 28,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    PageViewModel(
      title: "Activa tu timbre",
      body:
          "Recibe notificaciones sobre los próximos pasos de tu preparación. Útil cuando usas recetas con pasos de preparación largos y no quieres mirar tu teléfono todo el tiempo.",
      image: _buildImage('intro3', isGif: true), // Replace with your image path
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 234, 75, 94),
            fontSize: 28,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    // PageViewModel(
    //   title: "Comparte recetas con amigos",
    //   body:
    //       "Envíales el enlace de la receta. Podrán abrirlo y preparar café incluso si no tienen la aplicación instalada.",
    //   image: _buildImage('intro4'), // Replace with your image path
    //   decoration: const PageDecoration(
    //     titleTextStyle: TextStyle(
    //         color: Color.fromARGB(255, 234, 75, 94),
    //         fontSize: 28,
    //         fontWeight: FontWeight.bold),
    //     bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
    //   ),
    // ),
    // Add as many pages as you require
  ];

  static Widget _buildImage(String assetName, {bool isGif = false}) {
    if (isGif) {
      return Image.asset('assets/onboarding/gifs/$assetName.gif',
          fit: BoxFit.cover);
    } else {
      // Set different image paths for iOS and Android
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
        assetName = 'assets/onboarding/ios/$assetName.png';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        assetName = 'assets/onboarding/android/$assetName.png';
      }
      return Image.asset(assetName, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 14, 36),
      body: SafeArea(
        child: IntroductionScreen(
          pages: listPagesViewModel,
          onDone: () {
            // Go to home screen when done button is pressed
            context.router.replaceNamed('/');
          },
          onSkip: () {
            // Go to home screen when skip button is pressed
            context.router.replaceNamed('/');
          },
          showSkipButton: true,
          skip: const Text('Saltar',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          next: const Text('Siguiente',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          done: const Text('Empezar!',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          dotsDecorator: const DotsDecorator(
            size: Size.square(10.0),
            activeColor: Color.fromRGBO(255, 255, 255, 1),
            activeSize: Size.square(20.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
          ),
        ),
      ),
    );
  }
}
