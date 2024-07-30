import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  //----------------------- Celular -----------------------
  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Bienvenido Coffee Lover!",
      body:
          "Desliza para ver algunos consejos útiles sobre cómo preparar café con nuestra app.",
      image: _buildImage('intro1', imageSize: 90),
      decoration: const PageDecoration(
        bodyPadding: EdgeInsets.all(20),
        titlePadding: EdgeInsets.symmetric(horizontal: 20),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 40,
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
        imagePadding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        bodyPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 35,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    PageViewModel(
      title: "Activa tu timbre",
      body:
          "Recibe notificaciones sobre los próximos pasos de tu preparación. Útil cuando usas recetas largas y no quieres mirar tu teléfono todo el tiempo.",
      image: _buildImage('intro3', isGif: true), // Replace with your image path
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(bottom: 24, top: 100),
        bodyPadding: EdgeInsets.symmetric(horizontal: 20),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 40,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
    )
  ];
  //----------------------- iPad -----------------------
  final List<PageViewModel> listPagesViewModelIpad = [
    PageViewModel(
      title: "Bienvenido Coffee Lover!",
      body:
          "Desliza para ver algunos consejos útiles sobre cómo preparar café con nuestra app.",
      image: _buildImage('intro1', imageSize: 115),
      decoration: const PageDecoration(
        titlePadding: EdgeInsets.symmetric(horizontal: 140),
        bodyPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 110),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 70,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 30, color: Colors.white),
      ),
    ),
    PageViewModel(
      title: "Prepara todo el café que necesites",
      body:
          "Ajusta los valores en la página de recetas y obtén todas las recetas personalizadas a tu preferencia.",
      image: _buildImage('intro2', isGif: true), // Replace with your image path
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(bottom: 24, top: 30),
        bodyPadding: EdgeInsets.symmetric(horizontal: 70),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 50,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 30, color: Colors.white),
      ),
    ),
    PageViewModel(
      title: "Activa tu timbre",
      body:
          "Recibe notificaciones sobre los próximos pasos de tu preparación. Útil cuando usas recetas largas y no quieres mirar tu teléfono todo el tiempo.",
      image: _buildImage('intro3', isGif: true), // Replace with your image path
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
        bodyPadding: EdgeInsets.symmetric(horizontal: 70),
        titleTextStyle: TextStyle(
            color: Color(0xFFD75A72),
            fontSize: 50,
            fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 30, color: Colors.white),
      ),
    ),
  ];

  static Widget _buildImage(String assetName, {double imageSize = 80, bool isGif = false}) {
    if (isGif) {
      return Image.asset('assets/onboarding/gifs/$assetName.gif',
          fit: BoxFit.contain);
    } else {
      // Set different image paths for iOS and Android
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
        assetName = 'assets/onboarding/ios/$assetName.png';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        assetName = 'assets/onboarding/android/$assetName.png';
      }
      // return Image.asset(assetName, height: 80);
      return Image.asset(assetName, height: imageSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIpad() {
      final data = MediaQuery.of(context);
      return data.size.width < 600 ? false :true;
    }
    List<PageViewModel> listToUse = listPagesViewModel;
    double fontHeight = 17.0;
    if(isIpad()){
      fontHeight = 25.0;
      listToUse = listPagesViewModelIpad;
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 14, 36),
      body: SafeArea(
        child: IntroductionScreen(
          pages: listToUse,
          onDone: () {
            // Go to home screen when done button is pressed
            context.router.replaceNamed('/');
          },
          onSkip: () {
            // Go to home screen when skip button is pressed
            context.router.replaceNamed('/');
          },
          showSkipButton: true,
          skip: Text('Saltar',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: fontHeight)),
          next: Text('Siguiente',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: fontHeight)),
          done: Text('Empezar!',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: fontHeight)),
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
