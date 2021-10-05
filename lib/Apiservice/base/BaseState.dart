import 'dart:io';

import 'package:creditscore/Common/Colors.dart';
import 'package:flutter/material.dart';

import 'AlertService.dart';
import 'BaseView.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver implements BaseView{
  AlertService mAlertService;
  BuildContext buildContext;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var primaryColor;


  @override
  void initState() {
    mAlertService = AlertService();
    primaryColor = Rmlightblue;
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }



  @override
  void onNetworkUnavailable() {
    mAlertService.showAlert(context, "No Internet Connection !",
        "We are having trouble to connect with the internet. Please check your internet connection and try again.");
  }

  @override
  void onNetworkCallStarted(String loadingMsg) {
    print("STARTED>>>>>>>");
    AlertService.sharedInstance.showLoadingDialog(context, loadingMsg);
  }

  @override
  void onNetworkCallEnded() {
    print("ENDED>>>>>>>>>>");
    Navigator.of(context).pop();
  }



  @override
  void onTimeOutError() {
    mAlertService.showAlert(context, "TIME OUT ERROR",
        "We are having trouble to connect with server. Please try again later.");
  }

  @override
  void onServerError() {
    mAlertService.showAlert(context, "SERVER ERROR",
        "Could not connect with server. Please try agian later.");
  }

  @override
  void onExpectationFailed() {}

  void changeFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void showSnackBar(String msg, {Color backColor = Colors.red}) {
    final snackBar = SnackBar(
      backgroundColor: backColor,
      content: Text(msg),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed(){}
  void onPaused(){}
  void onInactive(){}
  void onDetached(){}
}
