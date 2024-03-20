import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../models/brewing_method.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';
import 'about_screen.dart';
import 'package:auto_route/auto_route.dart';
import '../app_router.gr.dart';
import "package:universal_html/html.dart" as html;
import '../purchase_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/method_utils.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:carousel_slider/carousel_slider.dart';



@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kIsWeb) {
      html.document.title = 'EScoffee App';
    }
    // Initialize the purchase manager and set up the callback
    PurchaseManager().initialize();
    PurchaseManager().deliverProductCallback = (details) {
      _showThankYouPopup(details);
    };
  }

  // Method to show the popup
  void _showThankYouPopup(PurchaseDetails details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thank You!"),
          content: const Text(
              "I really appreciate your support! Wish you a lot of great brews! ☕️"),
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && kIsWeb) {
      html.document.title = 'Escoffee App';
    }
  }
  List<Container> menuItem (List<BrewingMethod> methods){
    List<Container> lista =  <Container>[];
    for(BrewingMethod method in methods){
      lista.add(Container(
              decoration: BoxDecoration(
                    color: const Color.fromRGBO(157, 17, 43, 1),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                      onTap: () {
                      context.router.push(RecipeListRoute(
                          brewingMethodId: method.id));
                    },
                    highlightColor: const Color.fromARGB(255, 234, 75, 94),
                    borderRadius: BorderRadius.circular(17),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: 
                      [Padding(padding: const EdgeInsets.all(20),
                                child: getImageByBrewingMethod(method.id, 100)), Text(method.name, style: const TextStyle(fontWeight: FontWeight.w900),)], 
                      )
                            
                )
              )
      )
                        ); //add
    }
    return lista;
  }
  bool isIpad() {
      if(Device.get().isTablet){
        return true;
      }
  return false;
}

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final brewingMethods = Provider.of<List<BrewingMethod>>(context);

    int crossAxisCount;
    double mainAxisSpacing;
    double crossAxisSpacing;

    if(isIpad()){
      crossAxisCount = 3;
      mainAxisSpacing = crossAxisSpacing = 20;
    } else{
      crossAxisCount = 2;
      mainAxisSpacing = crossAxisSpacing = 10;
    }

    return Scaffold(
      appBar: buildPlatformSpecificAppBar(),
      body: FutureBuilder<Recipe?>(
        future: recipeProvider.getLastUsedRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Recipe? mostRecentRecipe = snapshot.data;

          return Column(
            children:[
              Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: CarouselSlider(
                  options: CarouselOptions(height: 220.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true),
                  items: [["assets/visuals/banner.png", 'https://escoffee.com/shop/'],["assets/visuals/banner2.png", "https://escoffee.com/shop/70-maquina-de-espresso?order=product.position.asc"],["assets/visuals/banner3.png", 'https://escoffee.com/shop/121-blends-de-origenes']].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return  InkWell(
                        onTap: () => _launchURL(i[1]),
                        highlightColor: const Color.fromARGB(255, 234, 75, 94),
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(i[0], fit: BoxFit.fitWidth)
                      );
                      },
                    );
                  }).toList(),
                )
              ),

              Expanded(child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, mainAxisSpacing: mainAxisSpacing,  crossAxisSpacing: crossAxisSpacing),
                                padding:  const EdgeInsets.all(15),
                                children: menuItem(brewingMethods))),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 30),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Cambia el color a tu preferencia
              //     ),
              //     child: const Text('Educare: tips para preparar tu café'),
              //     onPressed: () {
              //       context.router.push(const CoffeeTipsRoute());
              //     },
              //   ),
              // )
              ]
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  PreferredSizeWidget buildPlatformSpecificAppBar() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 105,
          child: CupertinoNavigationBar(
        leading: Padding(padding: const EdgeInsets.fromLTRB(16, 6, 7, 12),
                      child: Image.asset('assets/logoapp.png', fit: BoxFit.fitWidth)),
        backgroundColor: const Color.fromARGB(255, 97, 8, 25),
        trailing: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            context.router.push(const AboutRoute());
          },
        ),
      )
        )
      );
    } else {
      return AppBar(
        title: Image.asset('assets/logoapp.png', height: 25),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      );
    }
  }
}
