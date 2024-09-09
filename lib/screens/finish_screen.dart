// lib/screens/finish_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advanced_in_app_review/advanced_in_app_review.dart'; // Replaced in_app_review
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:auto_route/auto_route.dart';
import '../app_router.gr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/foundation.dart';
import '../utils/method_utils.dart';

class FinishScreen extends StatefulWidget {
  final String brewingMethodName;
  final String brewingMethodId;

  const FinishScreen({super.key, required this.brewingMethodName, required this.brewingMethodId});

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  late Future<String> coffeeFact;

  final AdvancedInAppReview advancedInAppReview =
      AdvancedInAppReview(); // Replaced InAppReview

  Future<String> getRandomCoffeeFact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String coffeeFactsString =
        await rootBundle.loadString('assets/data/coffee_facts.json');
    final List<String> coffeeFactsList =
        List<String>.from(jsonDecode(coffeeFactsString));

    List<int> shownFactsIndices =
        (prefs.getStringList('shownFactsIndices') ?? [])
            .map(int.parse)
            .toList();

    if (shownFactsIndices.length == coffeeFactsList.length) {
      shownFactsIndices = [];
    }

    List<int> unseenFactsIndices =
        List<int>.generate(coffeeFactsList.length, (i) => i)
          ..removeWhere((index) => shownFactsIndices.contains(index));

    final int nextFactIndex =
        unseenFactsIndices[Random().nextInt(unseenFactsIndices.length)];
    shownFactsIndices.add(nextFactIndex);

    prefs.setStringList('shownFactsIndices',
        shownFactsIndices.map((i) => i.toString()).toList());

    return coffeeFactsList[nextFactIndex];
  }

  Future<void> requestReview() async {
    if (Platform.isIOS && !kIsWeb) {
      advancedInAppReview
          .setMinDaysBeforeRemind(7)
          .setMinDaysAfterInstall(2)
          .setMinLaunchTimes(2)
          .setMinSecondsBeforeShowDialog(4);
      advancedInAppReview.monitor();
    }
  }

  @override
  void initState() {
    super.initState();

    WakelockPlus.enabled.then((bool wakelockEnabled) {
      if (wakelockEnabled) {
        WakelockPlus.disable();
      }
    });

    coffeeFact = getRandomCoffeeFact();
    requestReview();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
        child: getImageByBrewingMethod(widget.brewingMethodId, 200)),
            Padding(padding: const EdgeInsets.only(top: 10, right: 40, left: 40),
            child: Text(
              '¡Gracias por preparar tu café con EScoffee, disfruta de tu ${widget.brewingMethodName}!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: coffeeFact,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    margin: const EdgeInsets.all(25),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Dato curioso de café: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: '${snapshot.data}',
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                context.router.push(const HomeRoute());
              },
              child: const Text('Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
