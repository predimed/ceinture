import 'dart:async';
import 'package:ceinture/features/launcher/presentation/pages/bluetooth_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/hom_page.dart';
import 'package:flutter/material.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/utils.dart';
import 'package:ceinture/features/launcher/presentation/pages/root_page.dart';


class SplashPage extends StatefulWidget {
  @override
  PageState createState() => PageState();
}

class PageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text('Ceinture App', style: TextStyle(fontSize: 30, color: Colors.white),),
      ),
    );
  }
}
