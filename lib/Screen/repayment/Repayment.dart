import 'dart:convert';

import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/GetLoanDetailsResponce.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Repayment_contract.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Repayment extends StatefulWidget {
  const Repayment({Key key,this.screen}) : super(key: key);
  final bool screen;
  @override
  _RepaymentState createState() => _RepaymentState();
}

class _RepaymentState extends BaseState<Repayment> implements RepaymentView {
  RepaymentPresenterImpl _mPresenter;

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

  Projectlistdetails _projectItem;
  String datee_time;
  List data = List();
  String _myLoanId;
  bool loading=true;

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

    print(resBody);

    return "Success";
  }
  @override
  void initState() {
    getLoanId();
    this.getDisposedLoan();
    _mPresenter=RepaymentPresenterImpl(this);
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
      throw Exception('Failed to load album');
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
  @override
  Widget build(BuildContext context) {

    return  Container(
        color: Rmlightblue,
        child:SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
            appBar:widget.screen==true?AppBar(
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title:  FadeAnimation(1.6,
                    Text("Loan Repayment", style: TextStyle(color: Rmlightblue, fontSize: 18.sp, fontWeight: FontWeight.bold),)
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,):null,
              body:loading==true?Center(child: CircularProgressIndicator(),):SingleChildScrollView(child:Container(
                  padding: EdgeInsets.all(10.0),

                  child: Stack(

                    children: [
                      Form(
                        key:formGlobalKey,
                        child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 1.0,
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 50.w,
                                height:50.h,
                              ),
                            ),
                          ),
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
                              _EMIAmount.text=_projectItem.emiAmount.toStringAsFixed(0);
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
                                        title: Text("${t.text}",style: TextStyle(fontSize: 14.sp)),
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
                          Padding(
                              padding: const EdgeInsets.fromLTRB(25.0, 1.0, 22.0, 1.0),
                              child:Text("Add Remark",style: TextStyle(fontWeight: FontWeight.bold),)),

                          Padding(
                              padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
                              child: Card(child: Container (
                                padding: EdgeInsets.all(10),child: TextFormField(
                                maxLines: 4,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Enter remark",
                                ),

                                controller: _remarktext,

                              ),))),


                          Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 10),
                            child: RaisedButton(
                              onPressed: () async {
                               setState(() {
                                 submitBtnDidTapped();
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

                    ],)

              ),)
          ),)
    );
  }

  @override
  void repaymentDidFailed(String invalidFields) {
    // TODO: implement loginDidFailed
    setState(() {
      showSnackBar(invalidFields);
    });
  }

  @override
  void repaymentDidSucceed(String amount) {

    setState(() {
      showAlert(context, "Repayment","Successfully Paid !!");

    });
  }

  @override
  void submitBtnDidTapped() {

    if(_EMIAmount.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Select Loan Id",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp);
    }else{
      _mPresenter.doRepayment({ 'loanId':_myLoanId,
        'paymentDateTime':datee_time.toString().trim(),
        'emiAmount':_EMIAmount.text,
        'paymentMode':_currText.toString().trim(),
        'remarks':_remarktext.text.toString().trim(),
      });
    }
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
              content: Text(contentMsg,style: TextStyle(fontSize: 16.sp),),
              actions: <Widget>[
              Align(child: Container(
                      height: 30.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10),
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Home()));
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
                            constraints: BoxConstraints(maxWidth: 100.w, minHeight: 30.h),
                            alignment: Alignment.center,
                            child:Text(
                              "Done",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),alignment: Alignment.bottomRight,),
              ]
          );
        }
    );
  }
}


Widget buildTextFormField({
  TextEditingController controller,
  String hint,
  TextInputType inputType,
  int maxLength,
  Icon icon,
  String validation,
  bool focus,
  bool showtext
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(22.0, 1.0, 22.0, 1.0),
    child: Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: TextFormField(
          enabled: showtext,
          obscureText: inputType == TextInputType.visiblePassword,
          autofocus: focus != null ? focus : false,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: inputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: 16.0,
            ),
            hintStyle: TextStyle(
              color: kSecondaryTextColor,
            ),
            hintText: hint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            suffixIcon: icon != null ? icon : SizedBox.shrink(),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return validation;
            }
            if(maxLength==10){
              if (value.length != 10)
                return 'Mobile Number must be of 10 digit';
            }


            return null;
          },
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
        ),
      ),
    ),
  );
}
class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}