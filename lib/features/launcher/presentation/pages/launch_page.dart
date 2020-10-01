import 'dart:async';
import 'package:ceinture/features/launcher/presentation/pages/bluetooth_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/hom_page.dart';
import 'package:flutter/material.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/utils.dart';
import 'package:splashscreen/splashscreen.dart';



class SplashPage extends StatefulWidget {
  @override
  PageState createState() => PageState();
}

class PageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
   // Timer(
     //   Duration(seconds: 3),
       //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
         //   builder: (BuildContext context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:SplashScreen(
       seconds: 5,
       navigateAfterSeconds:HomePage(),
        image: new Image.asset('assets/img/loading.gif'),
       backgroundColor: primaryColor,
       title:Text('Ceinture App', style: TextStyle(fontSize: 30, color: Colors.white),),
       styleTextUnderTheLoader: new TextStyle(),
       photoSize: 150.0,
       onClick: () => print("Flutter"),
       loaderColor: Colors.green,
     ),
      //backgroundColor: primaryColor,
     // body: Center(
       //child: Text('Ceinture App', style: TextStyle(fontSize: 30, color: Colors.white),),
      //),
   );
  }
}
