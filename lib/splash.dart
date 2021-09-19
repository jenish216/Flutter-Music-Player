import 'package:flutter/material.dart';
import 'package:musicapp/homeView.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            // image: DecorationImage(
            //     image: AssetImage("assets/images/splash_bg1.jpg"),
            //     fit: BoxFit.fill)
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo1.jpg',
                    height: 400,
                    width: 400,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Feel The Music",
                  style: GoogleFonts.pinyonScript(
                    color: Colors.black,
                    fontSize: 40,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
