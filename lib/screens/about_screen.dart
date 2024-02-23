import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:auto_route/auto_route.dart';
import '../app_router.gr.dart';
import 'dart:io';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> loadContributors() async {
    return await rootBundle.loadString('assets/CONTRIBUTORS.md');
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ExpansionTile(
                title: const Text('Acerca de'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Somos la marca referente en cafés especiales, creando valor para nuestros artesanos y clientes, educando a través de cada sorbo. En EScoffee, seleccionamos las mejores cerezas de café de la mano con nuestros productores para poder entregarte un café vibrante con elegante fragancia y sabores únicos.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('Política de privacidad'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      kIsWeb
                          ? '''
Política de Privacidad de EsCoffee (Versión Web)

1. INTRODUCCIÓN

EsCoffee respeta la privacidad de sus usuarios y se compromete a protegerla en todos los aspectos. Esta política explicará cómo Coffee Timer utiliza los datos personales que recopilamos de usted cuando utiliza nuestra aplicación web.

2. RECOPILACIÓN Y USO DE DATOS

El script de seguimiento agrega la siguiente información estadística:

    El día de la semana (Como en: lunes, martes,...)
    El dispositivo de su usuario (como en teléfono, tableta o computadora)
    La fecha de la visita.
    Desde qué otro sitio web se originó la visita.
    El navegador del usuario (como en: Firefox, Chrome, Microsoft Edge, ...)
    El componente horario de la hora actual de un día.
    Un país asignado a la dirección IP de los usuarios.
    El sistema operativo del usuario (como en: Windows o Mac)
    Información sobre el tamaño de pantalla de los usuarios.
    El idioma preferido de los usuarios.
    Páginas visitadas

3. GALLETAS

EsCoffee utiliza cookies para recopilar datos anónimos para mejorar la experiencia del usuario y con fines analíticos.

4. SEGURIDAD

Valoramos su confianza al proporcionarnos su información personal, por lo que nos esforzamos por utilizar medios comercialmente aceptables para protegerla. Pero recuerde que ningún método de transmisión a través de Internet o método de almacenamiento electrónico es 100% seguro y confiable, y no podemos garantizar su seguridad absoluta.

5. POLÍTICAS DE PRIVACIDAD DE OTROS SITIOS WEB

La aplicación EsCoffee contiene enlaces a otros sitios web. Nuestra política de privacidad se aplica sólo a nuestra aplicación, por lo que si hace clic en un enlace a otro sitio web o servicio, debe leer su política de privacidad.

6. CAMBIOS A NUESTRA POLÍTICA DE PRIVACIDAD

Podemos actualizar nuestra Política de Privacidad de vez en cuando. Por lo tanto, se recomienda revisar esta página periódicamente para detectar cualquier cambio. Le notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página. Estos cambios entran en vigor inmediatamente después de su publicación en esta página.

7. CONTÁCTENOS

Para cualquier pregunta o aclaración sobre la Política de Privacidad, por favor contáctenos en support@EsCoffee

8. CÓMO CONTACTAR A LA AUTORIDAD CORRESPONDIENTE

Si desea presentar una queja o si cree que EsCoffee no ha abordado su inquietud de manera satisfactoria, puede comunicarse con su autoridad local de protección de datos.

9. MARCAS COMERCIALES

Todas las marcas comerciales, marcas de servicio, nombres comerciales, imágenes comerciales, nombres de productos y logotipos que aparecen en la aplicación son propiedad de sus respectivos dueños.
'''
                          : '''
Política de privacidad para EsCoffee

1. INTRODUCCIÓN

EsCoffee respeta la privacidad de sus usuarios y se compromete a protegerla en todos los aspectos. Esta política explicará cómo EsCoffee utiliza los datos personales que recopilamos de usted cuando utiliza nuestra aplicación.

2. RECOPILACIÓN Y USO DE DATOS

EsCoffee no recopila ningún dato personal. No procesamos ninguna información de identificación personal ni recopilamos datos indirectamente de otras fuentes. Como no recopilamos ningún dato personal, no tenemos datos para compartir, vender o utilizar de ninguna manera.

3. GALLETAS

EsCoffee no utiliza cookies.

4. SEGURIDAD

Valoramos su confianza al proporcionarnos su información personal, por lo que nos esforzamos por utilizar medios comercialmente aceptables para protegerla. Pero recuerde que ningún método de transmisión a través de Internet o método de almacenamiento electrónico es 100% seguro y confiable, y no podemos garantizar su seguridad absoluta.

5. POLÍTICAS DE PRIVACIDAD DE OTROS SITIOS WEB

La aplicación EsCoffee contiene enlaces a otros sitios web. Nuestra política de privacidad se aplica sólo a nuestra aplicación, por lo que si hace clic en un enlace a otro sitio web o servicio, debe leer su política de privacidad.

6. CAMBIOS A NUESTRA POLÍTICA DE PRIVACIDAD

Podemos actualizar nuestra Política de Privacidad de vez en cuando. Por lo tanto, se recomienda revisar esta página periódicamente para detectar cualquier cambio. Le notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página. Estos cambios entran en vigor inmediatamente después de su publicación en esta página.

7. CONTÁCTENOS

Para cualquier pregunta o aclaración sobre la Política de Privacidad, por favor contáctenos en support@EsCoffee

8. CÓMO CONTACTAR A LA AUTORIDAD CORRESPONDIENTE

Si desea presentar una queja o si cree que EsCoffee no ha abordado su inquietud de manera satisfactoria, puede comunicarse con su autoridad local de protección de datos.

9. MARCAS COMERCIALES

Todas las marcas comerciales, marcas de servicio, nombres comerciales, imágenes comerciales, nombres de productos y logotipos que aparecen en la aplicación son propiedad de sus respectivos dueños.
''',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.0, // space between buttons
                runSpacing: 2.0, // space between lines
                children: [
                  if (kIsWeb ||
                      !Platform
                          .isIOS) // Existing condition for non-iOS platforms
                    ElevatedButton.icon(
                      onPressed: () => _launchURL('https://escoffee.com/shop/'),
                      icon: const Icon(Icons.web),
                      label: const Text('Página Web'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        // Otras propiedades de estilo pueden ir aquí...
                      ),
                    ),
                  if (!kIsWeb &&
                      Platform.isIOS) // New condition specifically for iOS
                    ElevatedButton.icon(
                      onPressed: () {
                        context.router
                            .push(const DonationRoute()); // Your routing logic
                      },
                      icon: const Icon(Icons.web),
                      label: const Text('Página Web'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        // Otras propiedades de estilo pueden ir aquí...
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: getVersionNumber(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'App Version: ${snapshot.data}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.grey),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
