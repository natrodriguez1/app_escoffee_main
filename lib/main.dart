import 'dart:async'; // Import for StreamSubscription
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart'; // Import for In-App Purchase
import './models/brewing_method.dart';
import './providers/recipe_provider.dart';
import './app_router.dart';
import './app_router.gr.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import './models/recipe.dart';
import 'package:flutter/services.dart';
// import './purchase_manager.dart'; // Import PurchaseManager

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize In-App Purchase
  InAppPurchase.instance.restorePurchases();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

  List<BrewingMethod> brewingMethods = await loadBrewingMethodsFromAssets();

  final appRouter = AppRouter();
  usePathUrlStrategy();

  if (kIsWeb) {
    runApp(CoffeeTimerApp(
      brewingMethods: brewingMethods,
      appRouter: appRouter,
    ));
  } else {
    runApp(CoffeeTimerApp(
      brewingMethods: brewingMethods,
      appRouter: appRouter,
      initialRoute: isFirstLaunch ? '/firstlaunch' : '/firstlaunch',
    ));

    if (isFirstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }
  }
}

class CoffeeTimerApp extends StatelessWidget {
  final AppRouter appRouter;
  final List<BrewingMethod> brewingMethods;
  final String? initialRoute;

  const CoffeeTimerApp(
      {Key? key,
      required this.appRouter,
      required this.brewingMethods,
      this.initialRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeProvider>(
          create: (context) => RecipeProvider(),
        ),
        Provider<List<BrewingMethod>>(create: (_) => brewingMethods),
      ],
      child: MaterialApp.router(
        routerDelegate: appRouter.delegate(
          initialDeepLink: initialRoute,
        ),
        routeInformationParser: appRouter.defaultRouteParser(),
        builder: (_, router) {
          return QuickActionsManager(
            child: router!,
            appRouter: appRouter,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'EScoffee',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFD75A72),
            onPrimary: Color.fromARGB(255, 255, 255, 255),
            secondary: Color.fromARGB(255, 255, 255, 255),
            onSecondary: Color.fromRGBO(157, 17, 43, 1),
            error: Colors.red,
            onError: Colors.white,
            background: Color.fromARGB(255, 133, 14, 36),
            onBackground: Colors.white,
            surface: Color.fromARGB(255, 97, 8, 25),
            onSurface: Color.fromARGB(255, 255, 255, 255),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

Future<List<BrewingMethod>> loadBrewingMethodsFromAssets() async {
  String jsonString =
      await rootBundle.loadString('assets/data/brewing_methods.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList
      .map((json) => BrewingMethod.fromJson(json))
      .toList()
      .cast<BrewingMethod>();
}

class QuickActionsManager extends StatefulWidget {
  final Widget child;
  final AppRouter appRouter;

  QuickActionsManager({Key? key, required this.child, required this.appRouter})
      : super(key: key);

  @override
  _QuickActionsManagerState createState() => _QuickActionsManagerState();
}

class _QuickActionsManagerState extends State<QuickActionsManager> {
  QuickActions quickActions = QuickActions();
  StreamSubscription<List<PurchaseDetails>>? _subscription; // In-App Purchase

  // Deliver Product
  void _deliverProduct(PurchaseDetails purchaseDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Gracias!"),
          content: const Text(
              "¡Realmente aprecio su apoyo! ¡Te deseo muchas buenos filtrados! ☕️"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleError(IAPError error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content:
              const Text("Error al procesar la compra, inténtalo de nuevo."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize quick actions
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_last_recipe',
          localizedTitle: 'Open last recipe',
          icon: 'icon_coffee_cup'),
    ]);

    quickActions.initialize((shortcutType) async {
      if (shortcutType == 'action_last_recipe') {
        RecipeProvider recipeProvider =
            Provider.of<RecipeProvider>(context, listen: false);
        Recipe? mostRecentRecipe = await recipeProvider.getLastUsedRecipe();
        if (mostRecentRecipe != null) {
          widget.appRouter.push(RecipeDetailRoute(
              brewingMethodId: mostRecentRecipe.brewingMethodId,
              recipeId: mostRecentRecipe.id));
        }
      }
    });

    // Initialize In-App Purchase
    _subscription = InAppPurchase.instance.purchaseStream.listen((purchases) {
      for (var purchase in purchases) {
        final PurchaseDetails purchaseDetails = purchase;
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          _deliverProduct(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  @override
  void dispose() {
    // Unsubscribe from the In-App Purchase Stream
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
    );
    return widget.child;
  }
}
