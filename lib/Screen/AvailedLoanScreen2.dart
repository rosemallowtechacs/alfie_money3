import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:flutter/material.dart';
class AvailedLoanScreen2 extends StatefulWidget {
  const AvailedLoanScreen2({Key key,this.loanId}) : super(key: key);
   final String loanId;
  @override
  _AvailedLoanScreen1State createState() => _AvailedLoanScreen1State();
}

class _AvailedLoanScreen1State extends State<AvailedLoanScreen2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Rmlightblue,
      child: SafeArea(child:
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title:  FadeAnimation(1.6,
              Text("Loan Details", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,),
        body: SingleChildScrollView(child: Container(
          padding: EdgeInsets.all(20),
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(child:  new Image.asset(
            Constants.developerLogo,
            width: 50,
            height: 50,
          ),alignment: Alignment.topCenter,),
          FittedBox(child:Text("Loan ID   :${widget.loanId}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),),
          SizedBox(height: 20,),
          /* FittedBox(child:Text("${loanid}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
                  fit:BoxFit.contain,),*/
          
          Card(
            elevation: 2,

            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(20),
              child: Column(children: [
            FadeAnimation(1.6,
                Text("Loan Approved", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
            ),
            FadeAnimation(1.6,
                Text("Awaiting", style: TextStyle(color: Rmlightblue, fontSize: 25, fontWeight: FontWeight.bold),)
            ),
            FadeAnimation(1.6,
                Text("Disbursement", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
            ),
          ],),),),
          
         

        ],
      ),),),),),);
  }
}
