import 'dart:async';
import 'dart:convert';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/UserVerification.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/Login.dart';
import 'register/Register.dart';
import 'package:http/http.dart' as http;

const colorizeTextStyle = TextStyle(
  fontSize: 15.0,
  fontFamily: 'Horizon',

);
class SplashScreen extends StatefulWidget {

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  ProgressDialog pr;

  AnimationController animationController;
  Animation<double> animation;
  String _mobileNumber;
  bool loading=true;
  List<Color> colorizeColors = [
    Rmblue,
    Colors.black38,
  ];
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    bool status=await PreferenceManager.sharedInstance.getBoolean(
        Keys.REGISTERED_.toString());
    if(status==true){

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }else{

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegistrationPage()));
    }

  }


  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Rmlightblue,
      child: SafeArea(child:Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Constants.developerBy,
                style: TextStyle(

                    fontSize: 12.sp,

                    color: Rmlightblue),
              ),
              new Image.asset(
                Constants.developerLogo1,
               scale: 7,

              ),
             SizedBox(height: 10.w,)


            ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                Constants.developerLogo,
                width: 250.w,
                height: 250.h,
              ),
              SizedBox(height: 10.w,),
              loading==true? CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 5.w,

                valueColor: new AlwaysStoppedAnimation<Color>(Rmlightblue),
              ):Container(),

            ],
          ),

        ],
      ),
    )));
  }
}