
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/RegisterResponce.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/password/password_contract.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creditscore/Screen/login/Login.dart';

class PasswordPage extends StatefulWidget {
  @override
  _RequestForgotPasswordOtpPageState createState() =>
      _RequestForgotPasswordOtpPageState();
}

class _RequestForgotPasswordOtpPageState extends BaseState<PasswordPage> implements PasswordView {
  // TextEditingController _emailController;
  PasswordPresenterImpl _mPresenter;

  bool isLoading = false;
  final _contactEditingController = TextEditingController();
  TextEditingController password=TextEditingController();
  bool _isHidePassword = true;
  var _dialCode = '';
  ProgressDialog pr;
  String phoneNumber = "+91";
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final formGlobalKey1 = GlobalKey < FormState > ();
  String mobilenumber="";
  String code="";
  @override
  void dispose() {
    password.dispose();

    super.dispose();
  }

  @override
  void initState() {
    getDetails();
    _mPresenter = PasswordPresenterImpl(this);

    super.initState();
  }

  getDetails() async {
     mobilenumber= "${await PreferenceManager.sharedInstance.getInt(
         Keys.MOBILE_NUM.toString())}";

     code=await PreferenceManager.sharedInstance.getString(
        Keys.COUNTRY_CODE.toString());

     print(code+mobilenumber);
  }

  void register() async {
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
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.w600));
    pr.show();
    print(preferences.getInt("mobilenumber"));
    print(preferences.getInt("cuntrycode"));
    var body = jsonEncode({ 'mobile':preferences.getInt("mobilenumber"),'password':password.text,'countryCode':preferences.getInt("cuntrycode")} );
    print(body);

    var response = await http.post(APIS.register_user, headers: {
      "Content-Type": "application/json",
    }, body: body);
    if (response.statusCode == 200) {
      print('ramesh' + response.body);
      setState(()  {
        var responseJSON = json.decode(response.body);

        Registerusers  registerusers_responce = Registerusers.fromJson(responseJSON);
        preferences.setString("userid", registerusers_responce.id);
        preferences.setInt("mobile", registerusers_responce.mobile);
        pr.hide();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));

      });
    } if (response.statusCode == 500) {
      print('ramesh' + response.body);
      setState(() {
        pr.hide();
        var responseJSON = json.decode(response.body);
        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Rmlightblue,
            textColor: Colors.white,
            fontSize: 16.sp);
        print('ramesh' + response.body);
      });
    }

  }


  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      final responseMessage =
      await Navigator.pushNamed(context, '/otpScreen', arguments: '$_dialCode${_contactEditingController.text}');
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }

  //callback function of country picker
  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  //Alert dialogue to show error and response
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
  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
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
            child: SafeArea(child:Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color:Rmlightblue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  "New password",
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
                          SizedBox(height: 20.h,),
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
                                        "Set Password",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Form(
                                    key: formGlobalKey1,child:buildTextFormField(
                                    controller: password,
                                    hint: "Password",
                                    inputType: TextInputType.visiblePassword,
                                    validation: "Set Password",
                                    icon: Icon(
                                      Icons.lock,
                                      color: Rmlightblue,
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
                                        submitBtnDidTapped();

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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
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
      padding: const EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0,vertical: 5
          ),
          child: TextFormField(
            obscureText: _isHidePassword,
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

              suffixIcon: icon != null ? GestureDetector(
                onTap: () {
                  _togglePasswordVisibility();
                },
                child: Icon(
                  _isHidePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color:
                  _isHidePassword ? Colors.grey : Rmblue,
                  size:20,
                ),
              ) : SizedBox.shrink(),
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
    // TODO: implement registrationDidFailed
  }

  @override
  void registrationDidSucceed() {
    // TODO: implement registrationDidSucceed
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));


  }

  @override
  submitBtnDidTapped()  {
    // TODO: implement submitBtnDidTapped

    if(formGlobalKey1.currentState.validate()){
     _mPresenter.doRegistration({"password":password.text.toString().trim(),"mobile":mobilenumber,"countryCode":code});

    }
  }





}
