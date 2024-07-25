import 'package:flutter/material.dart';

Image getImageByBrewingMethod(String? brewingMethodId, double height) {
  Map<String, Image> images= {
    "aeropress":Image.asset('assets/visuals/aeropress.png',height: height, fit: BoxFit.contain,),
    "chemex": Image.asset('assets/visuals/chemex.png',height: height, fit: BoxFit.contain,),
    "clever_dripper": Image.asset('assets/visuals/switch.png',height: height, fit: BoxFit.contain,),
    "french_press": Image.asset('assets/visuals/prensa.png',height: height, fit: BoxFit.contain,),
    "hario_v60": Image.asset('assets/visuals/hario.png',height: height, fit: BoxFit.contain,),
    "origami": Image.asset('assets/visuals/origami.png',height: height, fit: BoxFit.contain,),
    "syphon": Image.asset('assets/visuals/syphon.png',height: height*1.25, fit: BoxFit.contain,)
  };

  return images[brewingMethodId] ?? Image.asset("assets/logoapp.png");
}
