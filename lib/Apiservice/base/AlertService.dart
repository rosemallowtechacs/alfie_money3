import 'package:creditscore/Common/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class AlertService {

  static final sharedInstance = AlertService();


  void showSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }


  Future<Null> showLoadingDialog(BuildContext context,
      String loadingMsg) async {
    return await showDialog<Null>(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Rmlightblue)),
                  SizedBox(width: 20.0),
                  Text(loadingMsg, style: TextStyle(fontSize: 16.0))
                ],
              ),
            ),
          );
        });
  }

  Future<Null> showAlert(BuildContext context,
      String contentTitle,
      String contentMsg) async {
    return await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(contentTitle),
              content: Text(contentMsg),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay")),
              ]
          );
        }
    );
  }

  Future<ConfirmAction> showConfirmationAlert(BuildContext context,
      String contentTitle, String contentMsg,
      {String negativeBtnText = "Cancel", String positiveBtnText = "Confirm"}) async {
    return await showDialog<ConfirmAction>(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(contentTitle),
              content: Text(contentMsg),
              actions: <Widget>[
                negativeBtnText != null ? FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.CANCEL);
                    },
                    child: Text(negativeBtnText)
                ) : Container(),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    },
                    child: Text(positiveBtnText)
                )
              ]
          );
        });
  }


  Future<String> showInputDialog(BuildContext context) async {
    String amount = "";
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Tell us Why ?'),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                          autofocus: true,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              labelText: '',
                              labelStyle: TextStyle(fontSize: 18),
                              hintText: '',
                              hintStyle: TextStyle(fontSize: 18)),
                          onChanged: (userInput) {
                            amount = userInput;
                          }
                      ))
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('DONE'),
                    onPressed: () {
                      Navigator.of(context).pop(amount);
                    }
                )
              ]
          );
        });
  }
}
