
import 'package:creditscore/Apiservice/base/AlertService.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home.dart';
import 'change_pass_contract.dart';

class ChangePasswordScreen extends StatefulWidget {


  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseState<ChangePasswordScreen>
    implements ChangePasswordView {
  ChangePasswordPresenterImpl _mPresenter;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  // TextField Controller
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isHidePassword = true;
  bool _isHidePassword1 = true;
  bool _isHidePassword2 = true;

  String name = "";
  String email = "";
  String avatar = "";

  @override
  void initState() {
    _mPresenter = ChangePasswordPresenterImpl(this);
    super.initState();

  }


  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Rmlightblue,
      child:SafeArea(
      child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Rmlightblue,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                                "Enter Your Password",
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
                            height: 16.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
                            child: TextFormField(
                              obscureText: _isHidePassword,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                labelText: "Old Password",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kSecondaryTextColor.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kSecondaryTextColor.withOpacity(0.5),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kSecondaryTextColor.withOpacity(0.5),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
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
                                )
                              ),
                              controller: _oldPasswordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter old Password";
                                }
                                return null;
                              },

                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
                            child: TextFormField(
                              obscureText: _isHidePassword1,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  labelText: "New Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _togglePasswordVisibility1();
                                    },
                                    child: Icon(
                                      _isHidePassword1
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color:
                                      _isHidePassword1 ? Colors.grey : Rmblue,
                                      size:20,
                                    ),
                                  )
                              ),
                              controller: _passwordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter New Password";
                                }
                                return null;
                              },

                            ),
                          ),

                          SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
                            child: TextFormField(
                              obscureText: _isHidePassword2,

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  labelText: "Confirm New Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kSecondaryTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _togglePasswordVisibility2();
                                    },
                                    child: Icon(
                                      _isHidePassword2
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color:
                                      _isHidePassword2 ? Colors.grey : Rmblue,
                                      size:20,
                                    ),
                                  )
                              ),
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter Confirm Password";
                                }
                                if(value != _passwordController.text){
                                  return 'Password Not Match';
                                }
                                return null;
                              },

                            ),
                          ),

                          SizedBox(
                            height: 32.0,
                          ),

                          Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            width: 200,
                            margin: EdgeInsets.only(bottom: 10),
                            child: RaisedButton(
                              onPressed: ()  async {
                                saveChangesBtnDidTapped();
                                /*if( _form.currentState.validate()){
                                  ConfirmAction confirmAction = await AlertService.sharedInstance
                                      .showConfirmationAlert(context, "Successful",
                                      "Your password has been changed successfully. Now login to continue",
                                      negativeBtnText: "", positiveBtnText: "Log In");
                                  switch (confirmAction) {
                                    case ConfirmAction.CANCEL:
                                      break;
                                    case ConfirmAction.ACCEPT:
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                      break;
                                  }
                                }*/
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
                                      maxWidth: 300.0, minHeight: 50.0),
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
                                          fontSize: 17.0,
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
                         /* buildButton(
                            onPressCallback: () {
                              saveChangesBtnDidTapped();
                            },
                            backgroundColor: Rmlightblue,
                            title: "Submit",
                          ),*/
                          SizedBox(
                            height: 32.0,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                ],
              ),
            ),
          ),)
        ],
      ),))
    );
  }
  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }
  void _togglePasswordVisibility1() {
    setState(() {
      _isHidePassword1 = !_isHidePassword1;
    });
  }void _togglePasswordVisibility2() {
    setState(() {
      _isHidePassword2 = !_isHidePassword2;
    });
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
      padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
      child: TextFormField(
        obscureText: inputType == TextInputType.visiblePassword,

        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        keyboardType: inputType,

        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.black,
          ),
          labelText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kSecondaryTextColor.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kSecondaryTextColor.withOpacity(0.5),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: kSecondaryTextColor.withOpacity(0.5),
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
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  void onExpectationFailed() {
    showSnackBar("Old Password is wrong");
  }

  @override
  void changePasswordDidFailed(String failedMsg) {
    showSnackBar(failedMsg);
  }

  @override
  void changePasswordDidSucceed(String successMsg) async {
    ConfirmAction confirmAction = await AlertService.sharedInstance
        .showConfirmationAlert(context, "Successful",
        "Your password has been changed successfully. Now login to continue",
        negativeBtnText: "", positiveBtnText: "Log In");
    switch (confirmAction) {
      case ConfirmAction.CANCEL:
        break;
      case ConfirmAction.ACCEPT:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }

  }

  @override
  void saveChangesBtnDidTapped() {
    final oldPassword = _oldPasswordController.text.toString();
    final newPassword = _passwordController.text.toString();
    final confirmNewPass = _confirmPasswordController.text.toString();
    FocusScope.of(context).requestFocus(FocusNode());

    if (_form.currentState
        .validate()) {
      Map dataMap = Map();
      dataMap["oldPassword"] = oldPassword;
      dataMap["newPassword"] = newPassword;

      _mPresenter.changePassword(dataMap);

    }

  }
}
