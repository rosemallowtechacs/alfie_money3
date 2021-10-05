import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/AlertDialogeBox.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Country_Code.dart';
import 'package:creditscore/Common/size_config.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/Home.dart';
import 'package:creditscore/Screen/login/login_contract.dart';
import 'package:creditscore/Screen/profile/Profile.dart';
import 'package:creditscore/Screen/register/Register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creditscore/Screen/forgotPassword/Forgot.dart';

import '../KYCimage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> implements LoginView{

  TextEditingController _phonenumber=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  bool isLoading = false;
  bool checkValue = false;
  ProgressDialog pr;
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  bool redmi=false;
  bool _isHidePassword=true;
  SharedPreferences sharedPreferences;
  String countrycode="";
  final formGlobalKey = GlobalKey < FormState > ();

  LoginPresenterImpl _mPresenter;
  @override
  void initState() {
    _mPresenter = LoginPresenterImpl(this);
    getCredential();
    super.initState();
  }


 @override
  void dispose() {
    // TODO: implement dispose
   _phonenumber.dispose();
    super.dispose();
  }


  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      countrycode =  countryCode.toString();
      print(countrycode);
    });}
  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }
  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("phonenumer", _phonenumber.text);
      sharedPreferences.setString("password", _passwordController.text);
      sharedPreferences.commit();
    });
  }
  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _phonenumber.text = sharedPreferences.getString("phonenumer");
          _passwordController.text = sharedPreferences.getString("password");
        } else {
          _phonenumber.clear();
          _passwordController.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.of(context).size.height > 765) {
      redmi = true;

    } else {
      redmi = false;
    }
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: (){
      var dialog = CustomAlertDialog(
          title: "Exit",
          message: "Are you sure?, Do you want to exit an App",
          onPostivePressed: () {
            exit(0);
          },
          positiveBtnText: 'Yes',
          negativeBtnText: 'No');
      showDialog(
          context: context,
          builder: (BuildContext context) => dialog);
    },
    child:Container(
        color: Rmlightblue,
        child: SafeArea(child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              SafeArea(
                child:SingleChildScrollView(
                    child: Form(
                      key: formGlobalKey,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 48.0,
                              ),
                              child: Image.asset(
                                Constants.money3Logo,
                                scale: 11,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                            child:Text("AI/ML enabled microfinance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                            child:Text("Login to continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            ),),

                          SizedBox(
                            height: 30.h,
                          ),
                          buildTextFormField(
                            controller: _phonenumber,
                            hint: "Mobile number",
                            maxLength:10,
                            validation: "Enter Mobile number",
                            inputType: TextInputType.number,
                            icon: Icon(
                              Icons.phone_android_rounded,
                              color: Color(0xFF02AEFF),
                            ),
                          ),
                          buildpassword(
                            controller: _passwordController,
                            hint: "Password",
                            validation: "Enter Password ",
                            inputType: TextInputType.visiblePassword,
                            icon: Icon(
                              Icons.visibility_off,
                              color: Color(0xFF14BC9F),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(35.0, 2.0, 32.0, 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Center(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkValue =
                                            !checkValue;
                                            setState(() {
                                              print(checkValue);
                                              _onChanged();
                                            });
                                          });
                                        },
                                        child: Row(
                                          children: [

                                            Container(

                                              decoration: BoxDecoration(
                                                shape: BoxShape
                                                    .rectangle,
                                                color: Color(
                                                    0xffF2F2F2),
                                                border: Border
                                                    .all(
                                                    width: 2.w,
                                                    color: Rmlightblue),
                                                borderRadius: new BorderRadius
                                                    .all(
                                                    Radius
                                                        .circular(
                                                        5.0)),
                                              ),
                                              height: 20.h,
                                              width: 20.h,
                                              child: checkValue
                                                  ? Icon(
                                                Icons.check,
                                                size: 15.sp,
                                                color: Rmlightblue,
                                              )
                                                  : null,

                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            redmi?Text(
                                              "Remember",
                                              style: TextStyle(
                                                color: Rmlightblue,
                                                fontWeight: FontWeight.w400,
                                                fontSize:12.sp,),
                                            ):Text(
                                              "Remember",
                                              style: TextStyle(
                                                color: Rmlightblue,
                                                fontWeight: FontWeight.w400,
                                                fontSize:15.sp,),
                                            ),
                                          ],
                                        ))),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => Forgotpassword()));
                                  },

                                  child: redmi?Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: kSecondaryTextColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ):Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: kSecondaryTextColor,
                                      fontSize: redmi?12.sp:15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                              ],),),

                          SizedBox(
                            height: 30.h,
                          ),

                          Container(
                            height: 50.h,
                            alignment: Alignment.center,
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
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Login",
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
                            height: 20.h,
                          ),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RegistrationPage(),
                                    ),
                                  );
                                });
                                // ToastUtil.show("This option is not available in demo version.");
                              },
                              child: Text(
                                "Don't have an account? Register Here!",
                                style: TextStyle(
                                  color: kSecondaryTextColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 50.h,
                          ),

                          Align(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [

                            Text("Powered by",  style: TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),),
                            Image.asset(
                              Constants.developerLogo1,

                              height: 20.h,
                            ),
                          ],) ,alignment: Alignment.bottomCenter,)

                        ],
                      ),)
                ),
              ),
            ],
          ),
        ),))
    );
  }


  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }
  Widget buildpassword({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
    String validation,

  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 0.0,
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
                  _isHidePassword ? Colors.grey : Rmlightblue,
                  size:20.sp,
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
  Widget buildTextFormField({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
    String validation,
    bool focus,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 0.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            autofocus: focus != null ? focus : false,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.0,
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
              prefixIcon: CountryCodePicker(
                onChanged: _onCountryChange,

                initialSelection: 'In',
                countryList: countryCodes,

                favorite: ['+91','In'],

                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
            ),
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return validation;
              }
              if (value.length != 10)
                return 'Mobile Number must be of 10 digit';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          padding: const EdgeInsets.all(16.0),
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
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }


  @override
  void loginDidFailed(String invalidFields) {
    // TODO: implement registrationDidFailed
    /*Fluttertoast.showToast(
        msg:invalidFields ,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Rmlightblue,
        textColor: Colors.white,
        fontSize: 16.0);*/
    setState(() {
      showSnackBar("Invalid phone number or password!");
    });
  }

  @override
  void loginDidSucceed(String kyc,String userId,String token,String name) {
    setState(() {
      if(kyc==null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Kycform(token: token,userId: userId,)));
      }else if(name==null){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profiledata(token:token,userId: userId,)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
      navigationTo(kyc,userId,token);
    });
  }

  Future<void> navigationTo(String kyc,String userId,String token) async {
    String file=await PreferenceManager.sharedInstance.getString(Keys.SIGN1.toString());
    print("RAMESH"+file);
    bool status=await PreferenceManager.sharedInstance.getBoolean(Keys.SIGN_STATUS.toString());
    if(status==true){
      _mPresenter.doFileUpload();
    }

  }

  @override
  void submitBtnDidTapped() {
    if(formGlobalKey.currentState.validate()){
      _mPresenter.doLogin({"mobile":_phonenumber.text.toString().trim(),"password":_passwordController.text.toString().trim()});
    }
  }


}
