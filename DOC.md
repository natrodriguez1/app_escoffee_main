# DOCUMENTACIÓN GENERAL
primer paso: 
$ flutter run
$ flutter pub add carousel_slider

Tareas ejecutadas:
- Home screen con íconos grandes en vez de lista.
- La altura del carrousel es 1/2.5 del tamaño de la pantalla (TODO: verificar si funciona en otras pantallas/SO/plataformas)
- La altura de las imagenes del menú principal son 1/7 del tamaño de la pantalla (TODO: verificar)
- Cambio de font a Poppins

Para compilar en xcode:
1. $ open ios/Runner.xcworkspace
2. $ cd ios
3. $ pod update

Para abrir simuladores:
- $ xcodebuild -downloadPlatform iOS
- $ open -a Simulator
- ó $ flutter run

Pasos para añadir un nuevo método:
- añadir .json con recetas en assets/data
- añadir imagen del vector en assets/visuals
- añadir referencia en assets/data/brewing_methods.json
- añadir referencia de la imagen del vector y .json en pubspec.yaml
- añadir referencia en lib/providers/recipe_provider.dart
- añadir icono en lib/utils/icon_utils.dart //TODO
- añadir referencia en método lib/utils/method_utils.dart