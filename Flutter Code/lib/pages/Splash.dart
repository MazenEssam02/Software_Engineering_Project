 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expenso/pages/Dashboard.dart';
import 'package:expenso/pages/Onboarding.dart';
import 'package:expenso/pages/Signin.dart';
import 'package:expenso/theme/colors.dart';
 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation heartbeatAnimation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..repeat(reverse: true);
    heartbeatAnimation =
        Tween<double>(begin: 110.0, end: 220.0).animate(controller);
    controller.forward().whenComplete(() {
      controller.reverse();
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
   if(FirebaseAuth.instance.currentUser!=null)
   {

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);

   }else{

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Onboarding()),
          (route) => false);
   }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: heartbeatAnimation,
      builder: (context, widget) {
        return Scaffold(
          backgroundColor: white,
      
          body: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(),
                Image(
                  image: AssetImage("assets/logot.png"),
                  width: heartbeatAnimation.value,
                  height: heartbeatAnimation.value,
                ),
              ],
            ),
         
          ]),
        );
      },
    );
  }

 
}
 