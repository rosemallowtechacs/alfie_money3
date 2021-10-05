import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/Dashboard2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool status ;
  bool agree=true;
  bool stage=false;
  bool loading=true;
  bool PreApprovedCredit1=false;
  static const platform = const MethodChannel('heartbeat.fritz.ai/native');
  SharedPreferences sharedPreferences;
  SharedPreferences preferences;
  String registerDate;
  List data = List();
  @override
  void initState() {
    getDisposedLoan();
    loaddata();
    super.initState();
  }

  loaddata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> map = await PreferenceManager.sharedInstance
        .getMap(Keys.PROFILE_MAP.toString());
    setState(() {
      if(sharedPreferences.getBool("agree")!=null){
        agree=sharedPreferences.getBool("agree");
      }
      if(sharedPreferences.getBool("stage1")!=null){
        stage=sharedPreferences.getBool("stage1");
      }
      // registerDate=preferences.getString(Constants.dateTime);
      registerDate= map[ProfileKeys.REG_DATETIME.toString()];
      print("DDDDhh");
      print(registerDate);
    });
    print(stage);
  }

  Future<String> getDisposedLoan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var res = await http
        .get(Uri.parse(APIS.disposementLoan+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    var resBody = json.decode(res.body);

    setState(() {
      loading=false;
      data = resBody["loans"];
      if(data.isNotEmpty){
        sharedPreferences.setBool("stage1", true);
      }
    });
    print(data);
    return "Success";
  }


  Future<void> responseFromNativeCode() async {
    int mobilenumber=await PreferenceManager.sharedInstance.getInt(Keys.MOBILE_NUM.toString());

    try {

      final String result = await platform.invokeMethod('ActivityStart',{"mobilenumber":"$mobilenumber"});

    } on PlatformException catch (e) {
    }

  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void showSnackBar(String msg, {Color backColor = Colors.red}) {
    final snackBar = SnackBar(
      backgroundColor: backColor,
      content: Text(msg),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:Scaffold(
          key:scaffoldKey ,
          body: loading==true?Center(child: CircularProgressIndicator(),):stage==true?RepaymentDashboard():PreApprovedCredit1==true?PreApprovedCredit(): SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              Padding(padding: EdgeInsets.all(5),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text(
                          "Alternative credit score",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 14.sp),
                        ),
                        SizedBox(height: 10.h,),
                        Align(child:CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 13.0,
                          animation: true,
                          animationDuration: 3000,
                          percent: 0.6,
                          animateFromLastPercent: true,
                          center: Text(
                            "7/10",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),

                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor:Rmlightblue ,

                        ),alignment: Alignment.center,),
                        SizedBox(height: 10.h,),
                        Text(
                          "Estimated credit limit",
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        Row(
                          children: [
                            Text(
                              "RMx",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 17.sp),
                            ),
                            Spacer(),
                            Align(child: RaisedButton(
                              onPressed: () async {
                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                setState(() {
                                  // registerDate
                                  registerDate=preferences.getString(Constants.dateTime);
                                  List<String> result = registerDate.split(' ');
                                  List<String> result1 = result[0].split('-');
                                  List<String> result2 = result[1].split(':');
                                  int year = int.parse(result1[0]);
                                  int monthh = int.parse(result1[1]);
                                  int datee = int.parse(result1[2]);
                                  int hourss = int.parse(result2[0]);
                                  int minitess = int.parse(result2[1]);
                                  final createdOn = DateTime(year, monthh, datee,hourss,minitess);
                                  final date2 = DateTime.now();
                                  final difference = daysBetween(createdOn, date2);

                                  if(difference>3){
                                    PreApprovedCredit1=true;
                                    preferences.setBool(Constants.dataCollection, false);
                                    responseFromNativeCode();
                                  }else{
                                    preferences.setBool(Constants.dataCollection, true);
                                    PreApprovedCredit1=true;

                                    //showSnackBar("${3-difference}"+"  More days to go!");
                                  }
                                  // responseFromNativeCode();
                                });

                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 90,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Rmlightblue,
                                          Rmpick
                                        ],),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                                  ),
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child:  Center(child:Text(
                                    'Go',
                                    style: TextStyle(fontSize:14.sp),textAlign: TextAlign.center,
                                  ),)
                              ),
                            ),alignment: Alignment.bottomRight,)
                          ],
                        )
                      ],
                    ),),
                ),),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.access_time),
                    trailing: Icon(Icons.arrow_right),
                    title: Text("Transaction History",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.payments_outlined),
                    trailing: Icon(Icons.arrow_right),
                    title: Text("Financial tips and tricks",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold)),
                  ),
                ),
              ),


            ],),),
        ));
  }



}
