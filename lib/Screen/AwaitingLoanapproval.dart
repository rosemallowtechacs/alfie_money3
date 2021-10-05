import 'dart:io';

import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
class LoanApproval extends StatefulWidget {
  const LoanApproval({Key key,this.status}) : super(key: key);

  final String status;

  @override
  _LoanApprovalState createState() => _LoanApprovalState();
}

class _LoanApprovalState extends State<LoanApproval> {

  bool status=false;
  @override
  void initState() {

    super.initState();
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Constants.messageExit),
        content: new Text(Constants.messageExit1),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 30),
          new GestureDetector(
            onTap: () => exit(0),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    //String status= widget.status;
    return Container(
      color: Rmlightblue,
      child: SafeArea(child: WillPopScope(
        onWillPop: _onBackPressed,child:Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child:Row(children: [
                  IconButton( icon: Icon(Icons.arrow_back_ios, color: Rmlightblue) ,onPressed: (){
                    Navigator.of(context).pop();
                   /* Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Home()));*/
                  },),


                ],)),
            new Image.asset(
              Constants.developerLogo,
              width: 100,
              height: 100,
            ),
            Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
                child:Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width/1,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Align(child: Container(
                        color: Rmlightblue,
                        padding: EdgeInsets.only(left: 10),

                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child:Text("Loan Status",style: TextStyle(color: Colors.white,fontSize: 18),)
                    ),alignment: Alignment.topCenter,
                    ),*/
                      SizedBox(height: 20,),
                      /* Align(child:Container(
                      margin: EdgeInsets.only(top: 20),
                      child:Text(widget.status,style: TextStyle(fontSize: 18),textAlign: TextAlign.center),

                      alignment: Alignment.center,),
                    ),*/
                    Column(children: [
                      FadeAnimation(1.6,
                          Text("Awaiting", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
                      ),
                      FadeAnimation(1.6,
                          Text("Loan", style: TextStyle(color: Rmlightblue, fontSize: 25, fontWeight: FontWeight.bold),)
                      ),
                      FadeAnimation(1.6,
                          Text("approval", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
                      ),

                      ],),


                      //Text(status?"Loan Approved Awaiting Disbursement":"Awaiting Loan approval.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center),

                      SizedBox(height: 20,),

                      /*"Loan Approved Awaiting Disbursement"*/
                    ],),)
            ),
            SizedBox(height: 50,),

          ],
        ),),
      ),)),
    );
  }
}

/*
Column(children: [
Text("Loan Approved",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
SizedBox(height: 10,),
Text("Awaiting",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
SizedBox(height: 10,),
Text("Disbursement",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
],):*/
