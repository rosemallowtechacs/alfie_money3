import 'dart:convert';

import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/DisposementLoanResponce.dart';
import 'package:creditscore/Apiservice/Responce/GetLoanDetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/LoanDetails.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/AvailedLoanScreen2.dart';
import 'package:creditscore/Screen/repayment/Repayment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'AvailedLoanScreen1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ActiveLoans extends StatefulWidget {
  @override
  _ActiveLoansState createState() => _ActiveLoansState();
}

class _ActiveLoansState extends State<ActiveLoans> {


  Future<LoanDetails> loandetails;
  final value = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {

    loandetails = getDetails();

    super.initState();
  }
  Future<LoanDetails> getDetails() async {
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response = await http.get(Uri.parse(APIS.LaondetalsApi+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);

        return LoanDetails.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to load ');
    }


  }


  @override
  Widget build(BuildContext context) {
    return  Container(
        color: Rmlightblue,
        child:SafeArea(
        child: Scaffold(
        /*appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
    onPressed: () => Navigator.of(context).pop(),
    ),
    title:  FadeAnimation(1.6,
    Text("Active Loans", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,),*/
          body:Center(child: FutureBuilder<LoanDetails>(
            future: loandetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.activeLoans.isEmpty?Container(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Image.asset(
                      Constants.activeLoans_im,
                      width: 30.w,
                      height: 30.w,
                    ),
                    SizedBox(height: 10,),
                  Text("No Active Loans")
                ],),):Container(

                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  height:MediaQuery.of(context).size.height,child:ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height/2.5,


                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Rmlightblue, //                   <--- border color
                                width: 1.0,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),

                            ),
                            margin: EdgeInsets.symmetric(horizontal: 18,vertical: 10),


                            child: Stack(children: [ Container(child:

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10,),

                                 ListTile(
                                  title: Text("Loan Id  "+snapshot.data.activeLoans[index].id,style: TextStyle(fontSize: 12)),
                                  subtitle:FittedBox(child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Text("Loan Amount :",style: TextStyle(fontSize: 14),),
                                          Text("Rm500",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("Loan Tenure :",style: TextStyle(fontSize: 14),),
                                          Text("4 months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("Product Type :",style: TextStyle(fontSize: 14),),
                                          Text("BNPL",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("Late Payments:",style: TextStyle(fontSize: 14),),
                                          Text("Yes",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                        ],),

                                      SizedBox(width: 50,),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Text("Loan Date :",style: TextStyle(fontSize: 14),),
                                          Text("21-09-2021",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("ACS Score :",style: TextStyle(fontSize: 14),),
                                          Text("7/10",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("Repayment Status:",style: TextStyle(fontSize: 14),),
                                          Text("2 of 4",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text("Defaults:",style: TextStyle(fontSize: 14),),
                                          Text("Yes",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),


                                        ],)
                                    ],),fit: BoxFit.contain,),
                                  /* leading: CircleAvatar(

                            backgroundColor: Colors.blue,
                            child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                          ),*/),
                                //trailing: Text("31-07-2021")),


                                SizedBox(height: 10,),

                                Spacer(),
                                GestureDetector(child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,

                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Rmlightblue,
                                          Rmpick,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text("Pay",style: TextStyle(color: Colors.white,fontSize: 12),)
                                    ],),),onTap: (){

                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Repayment(screen: true,)));

                                  /* Navigator.push(
                             context, MaterialPageRoute(builder: (context) => SelectAccountPage()));*/

                                },),
                              ],
                            ),),
                              /*Align(child:IconButton(icon: Icon(Icons.info,color: Colors.black,), onPressed: (){

                  }) ,alignment: Alignment.topRight,)*/
                            ],),
                          ),



                        ],
                      );
                    }),);
              } else if (snapshot.hasError) {
                return Container(child: Center(child: Text("No Data found !!"),),);
              }
              return const CircularProgressIndicator();
            },
          ),)
      ),)
    );
  }
}