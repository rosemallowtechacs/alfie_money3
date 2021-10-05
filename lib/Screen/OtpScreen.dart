
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/CountDown.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/size_config.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Screen/password/Password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key key,this.mobilenumber,this.verificationid}) : super(key: key);
final String mobilenumber;
  final String verificationid;
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  String otpWaitTimeLabel = "";
  String phoneNumber = "+91";
  String verificationId;
  FocusNode pin1FocusNode;
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  var _focusNodes = List.generate(6, (index) => FocusNode());
  TextEditingController otptext1 = new TextEditingController();
  TextEditingController otptext2 = new TextEditingController();
  TextEditingController otptext3 = new TextEditingController();
  TextEditingController otptext4 = new TextEditingController();
  TextEditingController otptext5 = new TextEditingController();
  TextEditingController otptext6 = new TextEditingController();
  final formGlobalKey = GlobalKey < FormState > ();
  int start=30;
  bool wait=false;
  @override
  void initState() {
    super.initState();
    startTimer();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode,bool first,last) {
    /*if (value.length == 1) {
      focusNode.requestFocus();
    }*/
    if (value.length == 1 && last == false) {
      FocusScope.of(context).nextFocus();
    }
    if (value.length == 0 && first == false) {
      FocusScope.of(context).previousFocus();
    }
  }
  Future<void> verifyPhone(phoneNo) async {
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


    PhoneVerificationFailed verificationFailed=(FirebaseException){
      showErrorDialog(context, FirebaseException.message);
    };
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homescreen()));*/
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        pr.hide();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OtpScreen(mobilenumber:phoneNo ,verificationid: verId,)));
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    print(phoneNumber+phoneNo,);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber+phoneNo,
        timeout: const Duration(seconds: 5),
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        verificationCompleted: verified,
        codeAutoRetrievalTimeout: autoTimeout);

  }
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PasswordPage()));
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => Kycform()));*/
  }
  signInWithOTP(smsCode, verId) async {
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
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verId, smsCode: smsCode))
          .then((value) async {
        if (value.user != null) {
          setState(() {

            pr.hide();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PasswordPage()));
          });
          ToastUtil.show("OTP Verification Successful");
        }
      });
    } catch (e) {
      pr.hide();
      FocusScope.of(context).unfocus();
      _scaffoldkey.currentState
          .showSnackBar(SnackBar(content: Text('invalid OTP Code')));
    }


  }

  void startTimer() {
    /*setState(() {
      _isResendEnable = false;
    });*/

    var sub = CountDown(new Duration(minutes: 2)).stream.listen(null);

    sub.onData((Duration d) {
      setState(() {
        int sec = d.inSeconds % 60;
        otpWaitTimeLabel = d.inMinutes.toString() + ":" + sec.toString();
      });
    });

    /* sub.onDone(() {
      setState(() {
        _isResendEnable = true;
      });
    });*/
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: Rmlightblue,
        child: SafeArea(child:Scaffold(
key: _scaffoldkey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(
              "OTP Verification",
              style: TextStyle(
                color: Rmlightblue,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(child:Form(
            key: formGlobalKey,
            child: Column(
              children: [

                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 48.0,
                    ),
                    child: Image.asset(
                      Constants.developerLogo,

                      height: 30,
                    ),
                  ),
                ),
                SizedBox(height: 30.h,),
                Text("Please Enter your verification code below",style: TextStyle(color: Colors.black,fontSize: 15.sp),),
                SizedBox(height: 20.h),
                SizedBox(height: 20.h),
                Text(otpWaitTimeLabel),
                Padding(padding: EdgeInsets.all(20),child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),
                      child: TextFormField(
                        autofocus: true,
                        obscureText: true,
                        focusNode: pin1FocusNode,
                        controller: otptext1,
                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {
                         nextField(value, pin2FocusNode,true,false);

                        },

                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),
                      child: TextFormField(
                        focusNode: pin2FocusNode,
                        autofocus: true,
                        obscureText: true,

                        controller: otptext2,
                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,

                        onChanged: (value) {

                          nextField(value, pin3FocusNode,false,false);

                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),
                      child: TextFormField(
                        focusNode: pin3FocusNode,
                        autofocus: true,
                        controller: otptext3,
                        obscureText: true,

                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        onChanged: (value) {

                          nextField(value, pin4FocusNode,false,false);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),
                      child: TextFormField(
                        focusNode: pin4FocusNode,
                        obscureText: true,
                        controller: otptext4,

                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) =>  nextField(value, pin5FocusNode,false,false),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),
                      child: TextFormField(
                        focusNode: pin5FocusNode,
                        obscureText: true,
                        controller: otptext5,

                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: otpInputDecoration,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) =>  nextField(value, pin6FocusNode,false,false),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(50),
                      height: getProportionateScreenWidth(100),

                      child: TextFormField(
                        focusNode: pin6FocusNode,
                        obscureText: true,
                        controller: otptext6,


                        style: TextStyle(fontSize: 24.sp),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,

                        decoration: otpInputDecoration, validator: (value) {
                        if (value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          /*if (value.length == 1) {
                            pin6FocusNode.unfocus();
                            // Then you need to check is the code is correct or not
                          }*/
                          nextField(value, pin3FocusNode,false,true);
                        },
                      ),
                    ),
                  ],
                ),),
                SizedBox(height: SizeConfig.screenHeight * 0.15),
                /* DefaultButton(
            text: "Continue",
            press: () {},
          ),*/

                Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      if(formGlobalKey.currentState.validate()){
                        setState(() {
// codeSent=false;
         signInWithOTP(otptext1.text+otptext2.text+otptext3.text+otptext4.text+otptext5.text+otptext6.text, widget.verificationid);
                        });
                      }


                    },

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Rmpick,
                    splashColor: Rmpick,
                    elevation: 10,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              "Submit OTP",
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

                SizedBox(height: 20.h,),

                GestureDetector(
                  onTap: () {
                    // OTP code resend
                    verifyPhone(widget.mobilenumber);
                  },
                  child: Text(
                    "Resend OTP Code",

                  ),
                )
              ],
            ),
          )),
        )));
  }
}

