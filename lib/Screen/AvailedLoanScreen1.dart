import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AvailedLoanScreen1 extends StatefulWidget {
  const AvailedLoanScreen1({Key key,this.loanId,this.amount,this.datee,this.interestRate,this.loanFees,this.emiAmount,this.status,this.tenure,this.productType}) : super(key: key);
   final String loanId;
  final int amount;
  final DateTime datee;
  final double interestRate;
  final double loanFees;
  final double emiAmount;
  final int tenure;
  final String status;
  final String productType;


  @override
  _AvailedLoanScreen1State createState() => _AvailedLoanScreen1State();
}

class _AvailedLoanScreen1State extends State<AvailedLoanScreen1> {
  final value = new NumberFormat("#,##0", "en_US");
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(child:  new Image.asset(
            Constants.developerLogo,
            width: 50,
            height: 50,
          ),alignment: Alignment.topCenter,),
          Text("Loan ID:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("${widget.loanId??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("Loan Date:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("${DateFormat("yyyy-MM-dd hh:mm:ss").format(widget.datee)??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("Amount:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("RM ${value.format(widget.amount)??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          widget.productType=="BNPL"? Text("Profit Rate:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)):Container(),
          SizedBox(height: 5,),
          widget.productType=="BNPL"?FittedBox(child:Text("${widget.interestRate}"+"% per month ",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,):Container(),
          SizedBox(height: 5,),
          Text("Fees:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("RM${value.format(widget.loanFees)??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("EMI Amount:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("RM${value.format(widget.emiAmount)??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("Tenure:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("${widget.tenure??""}"+" Months",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("Loan Status:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("${widget.status??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),
          SizedBox(height: 5,),
          Text("Product Type:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          FittedBox(child:Text("${widget.productType??""}",style: TextStyle(color: Colors.black,fontSize: 12)) ,
            fit:BoxFit.contain,),

        ],
      ),),),),),);
  }
}
