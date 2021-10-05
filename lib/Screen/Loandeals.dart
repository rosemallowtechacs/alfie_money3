
import 'dart:convert';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/Responce/ApplyloanResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Common/AlertDialogeBox.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Model/Radiobutton.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';
import 'Landingpage.dart';
import 'Loan_contract.dart';
import 'bankDetails/BankDetails.dart';
import 'register/Register.dart';

class Loanprocess extends StatefulWidget {
  Loanprocess(
      {Key key,
        this.loanmax})
      : super(key: key);
  final double loanmax;

  @override
  _LoanprocessState createState() => _LoanprocessState();
}

class _LoanprocessState extends State<Loanprocess> {
  double _loanAmount = 1000;
  double _months=3;
  double _interestRate=1.5;
  ProgressDialog pr;
  bool redmi=false;
  var totalamount;
  double totalamount1,a,b;
  double resultEMi=0;
  double totalResult=0;
  double _profitAmt=0;
  bool option1=false,option2=false,option3=false,option4=false;
  final TextEditingController _principalAmount = TextEditingController(text: "0");
  final TextEditingController _interestRate1 = TextEditingController(text: "0");
  final TextEditingController _tenure = TextEditingController(text: "0");
  int id = 1;
  String productType = 'BNPL';
  double loanfees=0;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => "${match[1]}";
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

    setState(() {

      // 1.5% x tenure x total loan amount
      double num=_loanAmount/100*_interestRate;
      _profitAmt=num*_months ;
      double fee=_loanAmount/100*1;
      loanfees=fee ;
      if(productType=="BNPL"){
        totalResult=_loanAmount+loanfees+_profitAmt;
      /*[(Profit rate x tenure) + loan amount) + Fees]/ Tenure*/
       // resultEMi=totalResult/_months;
      }else{
        totalResult=_loanAmount+loanfees;
        //resultEMi=totalResult/_months;
      }
      double step1 = _interestRate*_months;
      double step2 = step1+_loanAmount;
      double step3 =  step2 +loanfees;
      double step4 = step3 /_months;

      resultEMi=step4;
    });
  }

  Future bankDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
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

        /* Fluttertoast.showToast(
             msg: loanId,
             timeInSecForIosWeb: 1,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             backgroundColor: Rmlightblue,
             textColor: Colors.white,
             fontSize: 16.0);*/

            if( productType=="BNPL"){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BankDetails(loanId: loanId)));
            }else{
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Loancontract(loanId: loanId,)));
            }



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
            fontSize: 16.0);
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
            fontSize: 16.0);
      });
    }

  }
  Future covid19Question_Upload() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();


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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();

    var body = jsonEncode({ 'questionCovid':{
      'incomeLoss': option1,
      'familyLoss': option2,
      'healthImpact': option3,
      'safer': option4,
    }});

    print(body);
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    print(token);
    var postUri = Uri.parse(APIS.covidQuestions+userId);
    print(postUri);
    var response = await http.put(postUri, headers: {
      "Authorization":token,
      "Content-Type":"application/json"
    }, body: body);

    if (response.statusCode == 200) {
      print('ramesh' + response.body);
      setState(() {
        pr.hide();
        // Navigator.of(context).pop();

        bankDetails();
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
            fontSize: 16.0);
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
            fontSize: 16.0);
      });
    }

  }
  Future<void> CovidQuestions(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              /* backgroundColor: bgColor,*/
              content: Container(
                  height: 250,
                  child:Column(children: [
                    Text("Q. Have you been affected by the COVID19 pandemic?"),

                    Row(children: [Checkbox(

                      value: option1,
                      onChanged: (bool value) {
                        setState(() {
                          option1 = value;
                        });
                      },
                    ),
                      Text("Loss of income or reduction in pay",style: TextStyle(fontSize: 11),),
                    ],),
                    Row(children: [
                      Checkbox(
                        value: option2,
                        onChanged: (bool value) {
                          setState(() {
                            option2 = value;
                          });
                        },
                      ),
                      Text("Loss of family member(s)",style: TextStyle(fontSize: 11)),
                    ],),
                    Row(children: [
                      Checkbox(
                        value: option3,
                        onChanged: (bool value) {
                          setState(() {
                            option3 = value;
                          });
                        },
                      ),
                      Text("Personal health impact",style: TextStyle(fontSize: 11)),
                    ],),
                    Row(children: [
                      Checkbox(
                        value: option4,
                        onChanged: (bool value) {
                          setState(() {
                            option4 = value;
                          });
                        },
                      ),
                      Text("I am safe - no impact",style: TextStyle(fontSize: 11),),
                    ],),


                  ],)),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    setState(() {
                      covid19Question_Upload();
                    });
                    /*if (_formKey.currentState.validate()) {
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }*/
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height > 765) {
      redmi = true;

    } else {
      redmi = false;
    }
    return Container(
        color: Rmlightblue,
        child: SafeArea(child:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(offerpage?"Product Selection":"Apply for Loan",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
          ),
          body:offerpage?new SingleChildScrollView(child:Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 1.0,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height:100,
                ),
              ),
            ),
            Center(child:Text('Select a product',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),

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

                        Text("In collaboration with: ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black),),
                        new Image.asset(
                          data.logo,
                          width: 50,
                          height: 30,
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

            SizedBox(height: 20,),
            Container(
              height: 50.0,
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
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
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
                            fontSize: 17.0,
                          ),
                        ),
                        Spacer(),
                        Card(
                          //color: Color(0xCDA3C5EC),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          child: SizedBox(
                            width: 35.0,
                            height: 35.0,
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
            /* Container(
              height: 65,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              width: MediaQuery.of(context).size.width,
              child: NeumorphicButton(
                  padding: const EdgeInsets.all(18.0),
                  onPressed: () {
                    setState(() {
                      offerpage=false;
                    });

                  },
                  style: NeumorphicStyle(
                    color: Rmlightblue,
                    shape: NeumorphicShape.concave,
                    boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                  ),
                  child: Center(child:redmi?Text('Next',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)):Text('Next',style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)) ,)
              ),
            ),*/
          ],)):SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Container(
                    padding: EdgeInsets.all(10),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 1.0,
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 50,
                              height:50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15,right: 15
                          ),child: Card(child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(children: [
                            Text("Q. Have you been affected by the COVID19 pandemic?"),

                            Row(children: [Checkbox(

                              value: option1,
                              onChanged: (bool value) {
                                setState(() {
                                  option1 = value;
                                });
                              },
                            ),
                              Text("Loss of income or reduction in pay",style: TextStyle(fontSize: 11),),
                            ],),
                            Row(children: [
                              Checkbox(
                                value: option2,
                                onChanged: (bool value) {
                                  setState(() {
                                    option2 = value;
                                  });
                                },
                              ),
                              Text("Loss of family member(s)",style: TextStyle(fontSize: 11)),
                            ],),
                            Row(children: [
                              Checkbox(
                                value: option3,
                                onChanged: (bool value) {
                                  setState(() {
                                    option3 = value;
                                  });
                                },
                              ),
                              Text("Personal health impact",style: TextStyle(fontSize: 11)),
                            ],),
                            Row(children: [
                              Checkbox(
                                value: option4,
                                onChanged: (bool value) {
                                  setState(() {
                                    option4 = value;
                                  });
                                },
                              ),
                              Text("I am safe - no impact",style: TextStyle(fontSize: 11),),
                            ],),
                          ],),),),),


                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            redmi? Text("How much do you want to borrow \nand for how long?", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),):Text("How much do you want to borrow \nand for how long?", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10,),
                        Container(
                          // width: 100,
                            height: 50,
                            padding: EdgeInsets.all(5),
                            child:  productType=="Qard Hasan"? FlutterSlider(
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
                                  /* child:   new Image.asset(
                      'assets/images/ringgit.png',
                    ),*/
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
                              min: 500,
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
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 1.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(10),
                                  child:   new Image.asset(
                                    'assets/images/ringgit.png',
                                  ),
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
                              },)

                        ),
                        SizedBox(height: 10,),
                        /*FadeAnimation(1.6,
              Text("Amount"+" : "+"N$_lowerValue", style: TextStyle(color: Colors.grey),)
          ),*/


                        FadeAnimation(1.6,
                            Text("Amount"+" : "+"RM${value.format(_loanAmount)}", style: TextStyle(color: Colors.grey),)
                        ),
                        SizedBox(height: 10,),
                        Container(
                          // width: 100,
                          height: 50,
                          padding: EdgeInsets.all(5),
                          child:  productType=="Qard Hasan"? FlutterSlider(
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
                                /* child:   new Image.asset(
                      'assets/images/ringgit.png',
                    ),*/
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
                                /* child:   new Image.asset(
                      'assets/images/ringgit.png',
                    ),*/
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

                          ), /*FlutterSlider(
                              values: [_months],
                              max: productType=="Qard Hasan"?6:9,
                              min: productType=="Qard Hasan"?3:3,
                              trackBar: FlutterSliderTrackBar(
                                activeTrackBarHeight: 5,
                                activeTrackBar: BoxDecoration(color: Rmlightblue),
                              ),

                              handler: FlutterSliderHandler(
                                decoration: BoxDecoration(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 1.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(10),
                                  child:   new Image.asset(
                                    'assets/images/months.png',color: Colors.black,

                                  ),
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
                              },)*/

                        ),

                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            Text(" Months : "+"${ _months.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey),)
                        ),

                        SizedBox(height: 20,),
                        FadeAnimation(1.6,
                            redmi?  Text("Equated Monthly Installments(EMI)\nRM ${value.format(resultEMi)}", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),textAlign: TextAlign.center,):Text("Equated Monthly Installments(EMI)\nRM${value.format(resultEMi)}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child:Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                           elevation: 5,
                           // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),

                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                child: productType=="BNPL"?FittedBox(child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FadeAnimation(1.6,
                                        Text("PROFIT RATE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                                    ),
                                    SizedBox(height: 10,),
                                    FadeAnimation(1.6,
                                        Text("RM ${value.format(_profitAmt)}"+"(1.5% p.m.)", style: TextStyle(color: Colors.grey),)
                                    ),
                                  ],),

                                SizedBox(width: 10.h,),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10.h,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FadeAnimation(1.6,
                                        Text("PROCESSING FEE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                                    ),
                                    SizedBox(height: 10,),
                                    FadeAnimation(1.6,
                                        Text("RM ${value.format(loanfees)} (1%)", style: TextStyle(color: Colors.grey),)
                                    ),
                                  ],),
                                SizedBox(width: 10.h,),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black,
                                ),

                                SizedBox(width: 10.h,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FadeAnimation(1.6,
                                        Text("TOTAL DUE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                                    ),
                                    SizedBox(height: 10,),
                                    FadeAnimation(1.6,
                                        Text("RM ${value.format(totalResult)}", style: TextStyle(color: Colors.grey),)
                                    ),
                                  ],)

                              ],
                            )):Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FadeAnimation(1.6,
                                        Text("PROCESSING FEE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                                    ),
                                    SizedBox(height: 10,),
                                    FadeAnimation(1.6,
                                        Text("RM ${value.format(loanfees)}", style: TextStyle(color: Colors.grey),)
                                    ),
                                    FadeAnimation(1.6,
                                        Text("(1% of the total amount)", style: TextStyle(color: Colors.grey,fontSize: 8),)
                                    ),

                                  ],),

                                Spacer(),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FadeAnimation(1.6,
                                        Text("TOTAL DUE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                                    ),
                                    SizedBox(height: 10,),
                                    FadeAnimation(1.6,
                                        Text("RM ${value.format(totalResult)}", style: TextStyle(color: Colors.grey),)
                                    ),
                                  ],)

                              ],
                            )
                          ) ,),),
                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10,top: 10),
                          child: RaisedButton(
                            onPressed: () async {
                              setState(() {
                                covid19Question_Upload();
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
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                   /* Spacer(),
                                    productType=="BNPL"?FadeAnimation(1.6,
                                        Text("RM ${value.format(loanfees)} (1%)", style: TextStyle(color: Colors.white),)
                                    ):Container(),*/
                                    /*Spacer(),*/
                                    Spacer(),
                                    Text(
                                      "Next",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Card(
                                      //color: Color(0xCDA3C5EC),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(35.0)),
                                      child: SizedBox(
                                        width: 35.0,
                                        height: 35.0,
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
                        /*Container(
                          height: 65,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          width: MediaQuery.of(context).size.width,
                          child: NeumorphicButton(
                              padding: const EdgeInsets.all(18.0),

                              onPressed: () {

                                setState(() {
                                  covid19Question_Upload();
                                  // offerpage=true;
                                 //  bankDetails();
                                 // CovidQuestions(context);

                                });
                                *//* Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Loancontract()));*//*
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                color: Rmlightblue,
                                boxShape:
                                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                              ),
                              child: Center(child:redmi?Text('Get my offer',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)):Text('Get my offer',style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)) ,)
                          ),
                        ),*/

                      ],

                    )),

                // SizedBox(height: 10,),

              ],
            ) ,)
          ,
          floatingActionButton: new FloatingActionButton(
              elevation: 5.0,
              child: new Icon(Icons.exit_to_app),
              backgroundColor: Colors.red,
              onPressed: (){
                setState(() {
                  var dialog = CustomAlertDialog(
                      title: "Logout",
                      message: "Are you sure, do you want to logout?",
                      onPostivePressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      positiveBtnText: 'Yes',
                      negativeBtnText: 'No');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog);
                });
              }
          ),
        )));
  }
}
