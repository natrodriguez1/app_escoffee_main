// lib/screens/coffee_tips_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class CoffeeTipsScreen extends StatelessWidget {
  const CoffeeTipsScreen({super.key});

  final List<Map<String, String>> brewingTips = const [
    {
      'title': 'Usa café fresco: ',
      'content':
          'Haz tus filtrados con café recientemente tostado. La mejor ventana para filtrar es de 7 a 30 días después de la fecha de tueste.',
    },
    {
      'title': 'Compra café de especialidad de Ecuador: ',
      'content':
          'El café de especialidad de las distintas zonas cafetaleras del Ecuador, como el café EScoffee, puede mejorar la calidad de tu bebida.',
    },
    {
      'title': 'Entender el proceso del café: ',
      'content':
          'Los procesos post-cosecha del café pueden impactar su sabor. Experimenta con diferentes procesos y encuentra tu favorito! Inténtalo con los microlotes de origen único Nanolot by EScoffee, donde te indican el proceso post-cosecha y más datos sobre el café que consumes.',
    },
    {
      'title': 'Utiliza el molino correcto: ',
      'content':
          'Usa un molino de café que coincida con el método de filtrado. La calidad del molino puede afectar significativamente el sabor del café. Escoge un molino con muelas de acero si es posible.',
    },
    {
      'title': 'Ajusta el tamaño de molienda: ',
      'content':
          'El tamaño de molienda de tu café juega un rol muy importante en tu extracción y tiempo de filtrado. Ajusta tu tamaño de molienda si tu tiempo de filtrado es más rápido o lento que el de la receta.',
    },
    {
      'title': 'Mide tu café: ',
      'content':
          'Utilza una balanza para trabajar con medidas exactas, ya que el peso del café puede variar según su grado de tueste.',
    },
    {
      'title': 'Utiliza agua de calidad: ',
      'content':
          'Debido a que el agua conforma el 99% de tu bebida, su calidad impacta significativamente el sabor del filtrado. Evita el uso de agua dura, de la llave; en su lugar, opta por agua embotellada.',
    },
    {
      'title': 'Entender las temperaturas de filtrado: ',
      'content':
          'La temperatura del agua utilizada para preparar el café influye considerablemente en su sabor. Experimenta con diferentes temperaturas para encontrar la que mejor se adapte a tu tueste preferido.',
    },
    {
      'title': 'Mantén tu equipo limpio: ',
      'content':
          'Limpia regularmente tu equipo de preparación para evitar la contaminación por aceites residuales del café. Esto es especialmente importante cuando se cambia a una nueva cafetera.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consejos para preparar café'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: brewingTips.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: brewingTips[index]['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: brewingTips[index]['content']),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
