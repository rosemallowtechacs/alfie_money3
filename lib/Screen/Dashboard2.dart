import 'dart:convert';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ApplyloanResponce.dart';
import 'package:creditscore/Apiservice/Responce/DisposementLoanResponce.dart';
import 'package:creditscore/Apiservice/Responce/GetLoanDetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/LoginModel.dart';
import 'package:creditscore/Apiservice/Responce/RepaymentResponce.dart';
import 'package:creditscore/Apiservice/Responce/ViewBankResponce.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/StreamBackStackSupport.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Model/Radiobutton.dart';
import 'package:creditscore/Screen/AvailedLoanList.dart';
import 'package:creditscore/Screen/Loan_contract.dart';
import 'package:creditscore/Screen/Loandeals.dart';
import 'package:creditscore/Screen/repayment/Repayment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'bankDetails/BankDetails.dart';



class PreApprovedCredit extends StatefulWidget {
  const PreApprovedCredit({Key key}) : super(key: key);

  @override
  _PreApprovedCreditState createState() => _PreApprovedCreditState();
}



class _PreApprovedCreditState extends State<PreApprovedCredit> {
  SharedPreferences sharedPreferences;
  double _loanAmount = 1000;
  double _months=3;
  double _weeks=0;
  double _interestRate=1.5;
  double _upperValue = 180;
  ProgressDialog pr;
  var _emiResult="";
  bool redmi=false;
  var totalamount;
  String _persentage="";
  double totalamount1,a,b;
  String _miResult = "";
  double resultEMi=0;
  double totalResult=0;
  String _interestAmount = "";
  double _profitAmt=0;


  String _tcResult = "";
  bool option1=false,option2=false,option3=false,option4=false;

  int id = 1;
  String productType = 'BNPL';
  double loanfees=0;
  List<Radiobuttonlist> nList = [
    Radiobuttonlist(
      index: 1,
      number: "BNPL",
      Des: "Buy now, pay later (BNPL) is a microfinance product that offers you an unsecured cash advance loan of up to RM15,000 over a maximum period of 9 months.  ",
      logo:"assets/images/mrpay.png"
    ),
    Radiobuttonlist(
        index: 2,
        number: "Qard Hasan",
        Des:"Qard Hasan (benevolent loans) under GlobalSadaqah support eligible B40 Malaysians with seed funding to start an online micro business.\n\nAmount: RM1,500 to RM2,500 \nTenure: 3 months to 6 months",
        logo:"assets/images/globalSadaqah.png"
    ),

  ];

  int key = 0;
  bool offerpage=true;
  final value = new NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _handleCalculation();
  }
  void _handleCalculation() {

    NumberFormat format = NumberFormat('#,###,###.00');
    setState(() {

      // 1.5% x tenure x total loan amount
      double num=_loanAmount/100*_interestRate;
      _profitAmt=num*_months ;
      double fee=_loanAmount/100*1;
      loanfees=fee ;

      if(productType=="BNPL"){
        totalResult=_loanAmount+loanfees+_profitAmt;
       // resultEMi=totalResult/_months;
      }else{
        totalResult=_loanAmount+loanfees;
       // resultEMi=totalResult/_months;
      }
      double step1 = _interestRate*_months;
      double step2 = step1+_loanAmount;
      double step3 =  step2 +loanfees;
      double step4 = step3 /_months;
      print(step1);
      print(step2);
      print(step3);
      print(step4.toInt().roundToDouble());
      resultEMi=step4;

    });
  }


  Future bankDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();

    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
      showLogs: true,
    );
    pr.style(
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Color(0xffE5E5E5),
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.bounceInOut,
        progress: 1.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.w600));
    pr.show();

    var body = jsonEncode({
      'loanAmount': _loanAmount.toStringAsFixed(0),
      'profit': _profitAmt.toStringAsFixed(0),
      'emiAmount':resultEMi.toStringAsFixed(0),
      'interestRate':_interestRate,
      'totalDue': totalResult.toStringAsFixed(0),
      'loanFees': loanfees.toStringAsFixed(0),
      'tenure':_months.toStringAsFixed(0),
      'productType': productType
    });

    print(body);
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());

    print(token);
    var response = await http.post(
        APIS.applyloan, headers: {
      "Authorization":token,
      "Content-Type":"application/json"
    }, body: body);

    if (response.statusCode == 200) {
      print('ramesh' + response.body);
      setState(() {
        pr.hide();
        var responseJSON = json.decode(response.body);
        ApplyloanResponce registerusers_responce = ApplyloanResponce
            .fromJson(responseJSON);
        print(responseJSON);

        String loanId = registerusers_responce.id;
        String Status = registerusers_responce.loanStatus;
        preferences.setString(Constants.loanStatus, registerusers_responce.loanStatus);
        preferences.setString(Constants.loanId, registerusers_responce.id);
        preferences.setString(Constants.productType, registerusers_responce.productType);
        preferences.setString(Constants.tenureMonth, registerusers_responce.tenure.toString());
        preferences.setInt(Constants.loanFeess, registerusers_responce.loanFees.toInt());
        preferences.setInt(Constants.loanAmount, registerusers_responce.loanAmount);
        preferences.setDouble(Constants.profitRate, registerusers_responce.profit.toDouble());
        preferences.setDouble(Constants.interestRate, registerusers_responce.interestRate);
        preferences.setString(Constants.loanStatus, registerusers_responce.loanStatus);



        if( productType=="BNPL"){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BankDetails(loanId: loanId)));
        }else{
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Loancontract(loanId: loanId,)));
        }

        setState(() {
          sharedPreferences.setBool("stage1", true);
        });


      });
    }
    if (response.statusCode == 401) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);
        //var rest = responseJSON["errors"] as List;
        String message = responseJSON["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }
    if (response.statusCode == 500) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);

        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: offerpage?new SingleChildScrollView(child:Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 1.0,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 100.w,
                height:100.h,
              ),
            ),
          ),
          Center(child:Text('Select a product',style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.bold),)),

          Container(
              height: MediaQuery.of(context).size.height/1.8,
              alignment: Alignment.topCenter,
              child:Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  nList.map((data) => RadioListTile(
                    title: Text("${data.number}"),
                    subtitle: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Text("${data.Des}",style: TextStyle(fontSize: 10),),

                      Text("In collaboration with: ",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold,color: Colors.black),),
                      new Image.asset(
                        data.logo,
                        width: 50.w,
                        height: 30.h,
                      ),
                    ],),
                    groupValue: id,
                    value: data.index,
                    onChanged: (val) {

                      setState(() {
                        productType = data.number ;
                        id = data.index;
                        print(productType);
                        if(productType=="BNPL"){
                          _loanAmount = 1000;
                          _months=3;
                          _handleCalculation();
                        }else{
                          _loanAmount = 1500;
                          _months=3;
                          _handleCalculation();
                        }

                      });
                    },
                  )).toList(),
                ),)
          ),

          SizedBox(height: 20.h,),
          Container(
            height: 50.h,
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  offerpage=false;
                });

              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(0.0),
              color: Rmpick,
              splashColor: Rmpick,
              child: Ink(
                decoration: BoxDecoration(

                  // color: Color(0xff0066ff),
                    gradient: LinearGradient(
                      colors: [
                        Rmlightblue,
                        Rmpick,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        "Next",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                        ),
                      ),
                      Spacer(),
                      Card(
                        //color: Color(0xCDA3C5EC),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0)),
                        child: SizedBox(
                          width: 35.w,
                          height: 35.h,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Rmpick,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],)):SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top:10,left: 10),child:Text(
              "Loan amount",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 14.sp),
            ),),
            Padding(padding: EdgeInsets.all(5),
                child: Card(
                  margin: EdgeInsets.all(5),
                  elevation: 1,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RM${value.format(_loanAmount)}",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                          ),

                          productType=="Qard Hasan"? FlutterSlider(
                            values: [_loanAmount],
                            max: 2500,
                            min: 1500,
                            step: FlutterSliderStep(
                                step: 1, // default
                                isPercentRange: true, // ranges are percents, 0% to 20% and so on... . default is true
                                rangeList: [
                                  FlutterSliderRangeStep(from: 0, to: 500, step: 500),
                                  FlutterSliderRangeStep(from: 500, to: 500, step: 15000),
                                ]
                            ),

                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 5,
                              activeTrackBar: BoxDecoration(color: Rmlightblue),
                            ),

                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 1.0,
                                    ),],
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),

                              ),
                            ),

                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                            ),
                            disabled: false,

                            onDragging:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _loanAmount = lowerValue;
                                _handleCalculation();
                              });
                            },
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _loanAmount = lowerValue;
                                _handleCalculation();
                              });
                            },

                          ):FlutterSlider(
                            values: [_loanAmount],
                            max: 15000,
                            min: 1000,
                            step: FlutterSliderStep(
                                step: 1, // default
                                isPercentRange: true, // ranges are percents, 0% to 20% and so on... . default is true
                                rangeList: [
                                  FlutterSliderRangeStep(from: 0, to: 1000, step: 1000),
                                  FlutterSliderRangeStep(from: 1000, to: 1000, step: 15000),
                                ]
                            ),

                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 5,
                              activeTrackBar: BoxDecoration(color: Rmlightblue),
                            ),

                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 1.0,
                                    ),],
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),

                              ),
                            ),

                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                            ),
                            disabled: false,

                            onDragging:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _loanAmount = lowerValue;
                                _handleCalculation();
                              });
                            },
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _loanAmount = lowerValue;
                                _handleCalculation();
                              });
                            },

                          ),

                          SizedBox(height: 10.h,),
                          Text(
                              'Preferred tenure',
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 14.sp)
                          ),
                          SizedBox(height: 10.h,),
                          Text(
                            "${ _months.toStringAsFixed(0)}"+" months",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                          ),
                          productType=="Qard Hasan"? FlutterSlider(
                            values: [_months],
                            max: 6,
                            min: 3,

                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 5,
                              activeTrackBar: BoxDecoration(color: Rmlightblue),
                            ),

                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 1.0,
                                    ),],
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),

                              ),
                            ),

                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                            ),
                            disabled: false,

                            onDragging:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _months = lowerValue;


                                _handleCalculation();
                              });
                            },
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {

                                _months = lowerValue;
                                _handleCalculation();
                              });
                            },

                          ):FlutterSlider(
                            values: [_months],
                            max: 9,
                            min: 3,

                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 5,
                              activeTrackBar: BoxDecoration(color: Rmlightblue),
                            ),

                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 1.0,
                                    ),],
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),

                              ),
                            ),

                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                            ),
                            disabled: false,

                            onDragging:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _months = lowerValue;


                                _handleCalculation();
                              });
                            },
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) {
                              setState(() {

                                _months = lowerValue;
                                _handleCalculation();
                              });
                            },

                          ),

                          Divider(color: Colors.black,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Total amount payable',
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                                  ),
                                  Text(
                                    "RM ${value.format(totalResult)}",
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                                  ),
                                ],),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Monthly repayment',
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                                  ),
                                  Text(
                                    "${value.format(resultEMi)}",
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                                  ),
                                ],),
                            ],),
                          SizedBox(height: 10.h,),
                          productType=="Qard Hasan"?Container():Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Total interest payable',
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                                  ),
                                  Text(
                                    "RM ${value.format(_profitAmt)}",
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                                  ),
                                ],),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Effective profit rate',
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                                  ),
                                  Text(
                                    "1.5% p.m",
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                                  ),
                                ],),

                            ],),

                          Container(
                            margin: EdgeInsets.only(left: 20,top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Total fees',
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                                ),
                                Text(
                                  "RM ${ value.format(loanfees)}",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                                ),
                              ],),),

                          Align(child: RaisedButton(
                            onPressed: () async {


                              setState(() {

                                bankDetails();


                              });

                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                            child: Container(
                                alignment: Alignment.center,
                                width: 90.w,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Rmlightblue,
                                        Rmpick
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50.0))
                                ),
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child:  Center(child:Text(
                                  'Go',
                                  style: TextStyle(fontSize: 14.sp),textAlign: TextAlign.center,
                                ),)
                            ),
                          ),alignment: Alignment.bottomCenter,)




                        ],)),)),
          ],),)
    );
  }
}


class RepaymentDashboard extends StatefulWidget {
  const RepaymentDashboard({Key key}) : super(key: key);

  @override
  _RepaymentDashboardState createState() => _RepaymentDashboardState();
}

class _RepaymentDashboardState extends State<RepaymentDashboard> {


  TextEditingController _Loanid=TextEditingController();
  TextEditingController _datee=TextEditingController();
  TextEditingController _EMIAmount = new TextEditingController();
  TextEditingController _Amount=TextEditingController();
  TextEditingController _remarktext=TextEditingController();
  final formGlobalKey = GlobalKey < FormState > ();
  int _currVal = 1;
  String _currText = 'Online Banking';
  DateTime selectedDate=DateTime.now().subtract(Duration(days: 1));
  List<GroupModel> _group = [
    GroupModel(
      text: "Online Banking",
      index: 1,
    ),
    GroupModel(
      text: "Wallet",
      index: 2,
    ),

  ];

  List<Projectlistdetails> _disposedLoan=[];
  Future<GetDisposementLoan> BankList;

  List list = [];
  Projectlistdetails _projectItem;
  String datee_time;
  List data = List();
  String _myLoanId;
  bool loading=true;
  bool progress=true;
  ProgressDialog pr;
  Future<GetLoanDetails1> loandetails;

  Future<String> getDisposedLoan() async {
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

    });
    print("working");
    print(data);

    return "Success";
  }
  final value = new NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    getLoanId();
    BankList = getDetails();
    this.getDisposedLoan();
    selectedDate=DateTime.now();
    datee_time=DateFormat('MM-dd-yyyy').format(selectedDate);
    print(datee_time);
    super.initState();
  }
  @override
  void dispose() {
    _Loanid.dispose();
    _datee.dispose();
    _EMIAmount.dispose();
    _Amount.dispose();
    _remarktext.dispose();
    super.dispose();
  }

  Future<GetDisposementLoan> getDetails() async {
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response = await http.get(Uri.parse(APIS.disposementLoan+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);
        var responseJSON = json.decode(response.body);
        setState(() {
          progress=false;
        });
        list = responseJSON["loans"];

        return GetDisposementLoan.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to load ');
    }
  }
  getLoanId() async{
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response= await http.get(Uri.parse(APIS.disposementLoan+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });


    if (response.statusCode == 200) {
      print('ramesh' + response.body);

      _disposedLoan = LoanList.fromJson(json.decode(response.body)).projectlistdetails;
      print("rrrrrrrr");
      print(_disposedLoan.length);


    }
    else {
      throw Exception('Failed to load ');
    }

  }


  Future repayment(String url, Map formData) async {

    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
      showLogs: true,
    );
    pr.style(
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Color(0xffE5E5E5),
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.bounceInOut,
        progress: 1.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.w600));
    pr.show();
    try {
      var responseJSON;
      String msg;
      String token = await PreferenceManager.sharedInstance
          .getString(Keys.ACCESS_TOKEN.toString());
      var response = (await http.post(url, headers: {
        'Authorization':token,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, body: json.encode(formData)));
      print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        responseJSON = json.decode(response.body);
        RepaymentPage forgotResponse = RepaymentPage.fromJson(responseJSON);
        pr.hide();
        Fluttertoast.showToast(
            msg: "Successfully Paid",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Rmlightblue,
            textColor: Colors.white,
            fontSize: 16.sp);
        Navigator.of(context).pop();
        return BaseApiResponse.onSuccessRepayment(responseJSON);
      }else if(response.statusCode==401){
        responseJSON = json.decode(response.body);
        // responseJSON = loginFromJson(response.body);
        msg= responseJSON["msg"];
        print(msg);
        Fluttertoast.showToast(
            msg: msg,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
        pr.hide();
        return BaseApiResponse.onFailedRepayment(msg);
      }else if(response.statusCode==500){
        responseJSON = json.decode(response.body);
        responseJSON = loginFromJson(response.body);
        msg= responseJSON.errors[0].msg;
        print(responseJSON.errors[0].msg);
        Fluttertoast.showToast(
            msg: msg,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
        pr.hide();
        return BaseApiResponse.onFailedRepayment(msg);
      }

    } on DioError catch (error) {
      pr.hide();
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        pr.hide();
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        pr.hide();
        return BaseApiResponse.onDioError(error);
      }
    }
  }
  DropdownMenuItem<Projectlistdetails> buildDropdownMenuItem(Projectlistdetails item) {
    return DropdownMenuItem(
      value: item, // you must provide a value
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(item.id ?? ""),
      ),
    );
  }
  Widget _horizontalListView() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height/3.8,
      child:ListView.builder(
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return   Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              child: Card(child:Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current repayment amount",style: TextStyle(fontSize: 14.sp),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(child:Text(
                            "RM${data[index]["emiAmount"]}",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 17.sp),
                          ),),
                          Spacer(),
                          RaisedButton(
                            onPressed: (){
                              showModalBottomSheet<void>(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                builder: (BuildContext context) {

                                  return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

                                        return Container(
                                          height: MediaQuery.of(context).size.height/1,
                                          decoration: BoxDecoration(
                                              color:Colors.white,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),)
                                          ),
                                          child: loading==true?Center(child: CircularProgressIndicator(),):SingleChildScrollView(child:Container(
                                              padding: EdgeInsets.all(10.0),

                                              child: Stack(

                                                children: [
                                                  Form(
                                                    key:formGlobalKey,
                                                    child:
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
                                                          child:Text("Loan Id:"),),

                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
                                                          child:Card(
                                                            elevation: 2.0,
                                                            child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 10.0,
                                                                ),
                                                                child:Container (
                                                                  padding: EdgeInsets.all(10),
                                                                  child:  DropdownButton<Projectlistdetails>(
                                                                    elevation: 1,
                                                                    hint: Text("Select Loan Id"),
                                                                    isExpanded: true,
                                                                    items: _disposedLoan.map((item) => buildDropdownMenuItem(item)).toList(),
                                                                    value: _projectItem, // values should match
                                                                    onChanged: (Projectlistdetails item) {
                                                                      // setState(() => _projectItem = item);
                                                                      setState(() {
                                                                        _projectItem = item;
                                                                        _EMIAmount.text= value.format(_projectItem.emiAmount);
                                                                        _myLoanId=_projectItem.id;
                                                                        print(_projectItem.id);
                                                                        print(_projectItem.emiAmount.toStringAsFixed(0));
                                                                      });
                                                                    },
                                                                  ),)),),),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
                                                          child:Text("EMI Amount:"),),
                                                        buildTextFormField(
                                                          controller: _EMIAmount,
                                                          hint:"EMI Amount",
                                                          showtext:false,
                                                          inputType: TextInputType.number,
                                                          validation:"Enter EMI Amount",
                                                          icon: Icon(
                                                            Icons.payments,
                                                            color: Color(0xFFFEB71E),
                                                          ),
                                                        ),


                                                        Padding(
                                                            padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
                                                            child: Card(child: Container (
                                                              padding: EdgeInsets.all(10),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Payment Mode",style: TextStyle(fontWeight: FontWeight.bold),),

                                                                  Column(
                                                                    children: _group
                                                                        .map((t) => RadioListTile(
                                                                      title: Text("${t.text}",style: TextStyle(fontSize: 14)),
                                                                      groupValue: _currVal,
                                                                      value: t.index,
                                                                      onChanged: (val) {
                                                                        setState(() {
                                                                          _currVal = val;
                                                                          _currText = t.text;
                                                                          print(t.text);

                                                                        });
                                                                      },
                                                                    ))
                                                                        .toList(),
                                                                  )
                                                                ],),))),



                                                        Container(
                                                          height: 50.h,
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(bottom: 10),
                                                          child: RaisedButton(
                                                            onPressed: () async {

                                                              // Navigator.of(context).pop();
                                                              setState(() {
                                                                repayment(APIS.repayment,{ 'loanId':_myLoanId,
                                                                  'paymentDateTime':datee_time.toString().trim(),
                                                                  'emiAmount':_EMIAmount.text,
                                                                  'paymentMode':_currText.toString().trim(),
                                                                  'remarks':_remarktext.text.toString().trim(),
                                                                });
                                                              });

                                                            },
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                            padding: EdgeInsets.all(0.0),
                                                            color: Rmpick,
                                                            splashColor: Rmpick,
                                                            child: Ink(
                                                              decoration: BoxDecoration(
                                                                //color: Color(0xff0066ff),
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      Rmlightblue,
                                                                      Rmpick,
                                                                    ],
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(20.0)
                                                              ),
                                                              child: Container(
                                                                constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                                                                alignment: Alignment.center,
                                                                child:Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Spacer(),
                                                                    Text(
                                                                      "Pay",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 17.sp,
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    Card(
                                                                      //color: Color(0xCDA3C5EC),
                                                                      color: Colors.white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(35.0)),
                                                                      child: SizedBox(
                                                                        width: 35.w,
                                                                        height: 35.h,
                                                                        child: Icon(
                                                                          Icons.arrow_forward_ios,
                                                                          color: Rmpick,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),




                                                      ],),),
                                                  //Align(alignment: Alignment.,child: Text("Ramesh"),)

                                                ],))

                                          ),
                                        );});
                                },
                              );
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Rmlightblue,
                                      Rmpick
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child:  Text(
                                  'Pay now',
                                  style: TextStyle(fontSize: 14.sp)
                              ),
                            ),
                          ),



                        ],),
                      Divider(color: Colors.black,),
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Total loan approved',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                              ),
                              Text(
                                "RM${data[index]["totalDue"]}",
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                              ),
                            ],),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Repayment Done',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey, fontSize: 12.sp)
                              ),
                              Text(
                                "RM${data[index]["emiAmount"]} [2/4]",
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17.sp),
                              ),
                            ],),

                        ],),


                    ],)

              )));
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: progress==true?Center(child: CircularProgressIndicator(),):SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          data.isNotEmpty?_horizontalListView():Container(),
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
                      percent: 0.7,
                      animateFromLastPercent: true,
                      center: Text(
                        "7/10",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),

                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor:Rmlightblue ,

                    ),alignment: Alignment.center,),
                    SizedBox(height: 10.h,),

                   /* Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(25)),

                          child: Icon(Icons.account_tree_sharp,color: Colors.white,),
                        ),
                        SizedBox(width: 10.w,),

                        Text(
                          "+10% increase in score",
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),

                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(25)),

                          child: Icon(Icons.payments_outlined,color: Colors.white,),
                        ),
                        SizedBox(width: 10.w,),

                        Text(
                          "+2 On time repayment",
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),

                      ],
                    )*/
                  ],
                ),),
            ),),
          Container(
            height: 50.h,
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                setState(() {

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Loanprocess(loanmax:5000)));

                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(0.0),
              color: Rmpick,
              splashColor: Rmpick,
              child: Ink(
                decoration: BoxDecoration(

                  // color: Color(0xff0066ff),
                    color:Rmlightblue,

                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child: Text(
                    "Apply for Loan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),

          Container(
            height: 50.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: () {
                setState(() {

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AvailedLoanList()));

                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(0.0),
              color: Rmpick,
              splashColor: Rmpick,
              child: Ink(
                decoration: BoxDecoration(
                    color:Rmlightblue,

                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child: Text(
                    "Loan status",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h,),

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
         /* Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.payments_outlined),
                trailing: Icon(Icons.arrow_right),
                title: Text("Financial tips and tricks",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold)),
              ),
            ),
          ),*/


        ],),),
    );
  }
}



