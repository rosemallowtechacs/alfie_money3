import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Country_Code.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'forgot_contract.dart';

class Forgotpassword extends StatefulWidget {
  @override
  _RequestForgotPasswordOtpPageState createState() =>
      _RequestForgotPasswordOtpPageState();
}

class _RequestForgotPasswordOtpPageState extends BaseState<Forgotpassword> implements ForgotView {

  bool isLoading = false;
  final _contactEditingController = TextEditingController();
  TextEditingController emailid = TextEditingController();

  var _dialCode = '';
  String phoneNumber = "+91";
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formGlobalKey1 = GlobalKey <FormState>();
  ForgotPresenterImpl _mPresenter;
  @override
  void dispose() {
    emailid.dispose();

    super.dispose();
  }

  @override
  void initState() {

    _mPresenter = ForgotPresenterImpl(this);
    super.initState();
  }

  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      final responseMessage =
      await Navigator.pushNamed(context, '/otpScreen',
          arguments: '$_dialCode${_contactEditingController.text}');
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }

  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: kCommonBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        child: Container(
            color: Rmlightblue,
            child: SafeArea(child: Scaffold(
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
                  "Forgot password",
                  style: TextStyle(
                    color: Rmlightblue,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ),
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[

                  SafeArea(
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30.h,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 48.0,
                              ),
                              child: Image.asset(
                                Constants.developerLogo,

                                height: 30.h,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 32.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 32.0,
                                        bottom: 16.0,
                                      ),
                                      child: Text(
                                        "Enter Email Id",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Form(
                                    key: formGlobalKey1,
                                    child: buildTextFormField(
                                      controller: emailid,

                                      hint: "Email Id",
                                      inputType: TextInputType.emailAddress,
                                      validation: "Enter Email Id",
                                      icon: Icon(
                                        Icons.email,
                                        color: Color(0xFF02AEFF),
                                      ),
                                    ),),

                                  SizedBox(
                                    height: 32.h,
                                  ),


                                  Container(
                                    height: 50.h,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          submitBtnDidTapped();

                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)),
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
                                            borderRadius: BorderRadius.circular(
                                                20.0)
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 300.w, minHeight: 50.h),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                "Submit",
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
                                                    borderRadius: BorderRadius
                                                        .circular(35.0)),
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
                                  SizedBox(
                                    height: 32.h,
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),),
                  ),

                ],
              ),
            ),))
    );
  }



  Widget buildTextFormField({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
    String validation,

  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 5
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
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
              prefixIcon: icon != null ? icon : SizedBox.shrink()

            ),
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return validation;
              }

              return null;
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    VoidCallback onPressCallback,
    Color backgroundColor,
    String title,
  }) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 48.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: onPressCallback,
      color: backgroundColor,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  @override
  void registrationDidFailed(String invalidFields) {
    showAlert(context, "Forgot Password",invalidFields);
  }

  @override
  void registrationDidSucceed(String msg) {
    showAlert(context, "Forgot Password",msg);
  }

  @override
  void submitBtnDidTapped() {
    if (formGlobalKey1.currentState
        .validate()) {

      _mPresenter.doForgot({'email':emailid.text.toString().trim()});

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
              content: Text(contentMsg,style: TextStyle(fontSize: 12.sp),),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close")),
              ]
          );
        }
    );
  }
}