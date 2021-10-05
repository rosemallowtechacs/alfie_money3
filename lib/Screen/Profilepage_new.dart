
import 'dart:async';

import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'Home.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'register/Register.dart';

class Profilepagenew extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<Profilepagenew> {

  TextEditingController _nameController;
  TextEditingController _userNameController;

  TextEditingController _dateofbirthController = new TextEditingController();
  TextEditingController _phoneController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  TextEditingController _addressController;
  TextEditingController _facebookController;
  DateTime selectedDate=DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  bool isLoading = false;
  bool creditscore=false;
  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateofbirthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _userNameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _dateofbirthController=TextEditingController();
    selectedDate=DateTime.now();
    super.initState();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate1 = picked;
        //_dateofbirthController.text = DateFormat('dd/MM/yyyy').format(picked);
        _dateofbirthController.text = picked.toString();
        //_dateofbirthController.text=selectedDate1.toString();
      });
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Color(0xfff5c61e),
                onPrimary: Colors.white,
                surface: Color(0xfff5c61e),
                onSurface: Colors.white,
              ),
              //dialogBackgroundColor: Color(0xfffe1705),
              dialogBackgroundColor: Color(0xff268ac7),
            ),
            child: child,
          );
        });

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateofbirthController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
  }
  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home()));
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
      child: Scaffold(
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.exit_to_app),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
              setState(() {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              });
            }
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
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SingleChildScrollView(
                child: creditscore?Column(children: [
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 1.0,
                        top: 4.0,
                      ),
                      child: Text(
                        "Acquiring your",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 1.0,
                        top: 30.0,
                      ),
                      child: Text(
                        "CREDIT SCORE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 1.0,
                        top: 30.0,
                      ),
                      child: Text(
                        "........Wait",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Rmblue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 1.0,
                          top: 4.0,
                        ),
                        child: Text(
                         "Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    buildTextFormField1(
                      controller: _userNameController,
                      hint:"Enter Name",
                      inputType: TextInputType.text,
                      icon: Icon(
                        Icons.account_circle,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: _addressController,
                      hint:"IC Number",
                      inputType: TextInputType.text,
                      icon: Icon(
                        Icons.location_city,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: _emailController,
                      hint: "Pincode",
                      inputType: TextInputType.number,
                      icon: Icon(
                        Icons.pin_drop,
                        color: Rmblue,
                      ),
                    ),


      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),child:TextFormField(
          textAlign: TextAlign.left,
          autofocus: true,
          onTap: (){
            setState(() {
              _selectDate1(context);
            });
          },
          controller: _dateofbirthController,
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 14.0,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w400,
          ),

          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 16.0,
              ),

              border: OutlineInputBorder(),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: IconButton(
                  icon: Icon(Icons.date_range,color:Colors.purple ,),
                  onPressed: (){
                    setState(() {
                      _selectDate1(context);
                    });
                  },
                ), // icon is 48px widget.
              ),
              hintText: 'DOB e.g dd-mm-yyyy',
              hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey)),
        ),),),),
                    SizedBox(height: 10,),


      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35.0,
        ),child:Align(child: GestureDetector(
                      onTap: () {

                      },
                      child: Text(
                        "Attach Bank Statements",
                        style: TextStyle(
                          color: Rmblue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                   alignment: Alignment.topRight,),),
                   SizedBox(height: 20,),
                    buildButton(
                      onPressCallback: () {
                      setState(() {
                        creditscore=true;
                        var _duration = new Duration(seconds: 3);
                        return new Timer(_duration, navigationPage);

                      });
                      },
                      backgroundColor: Rmblue,
                      title: "Submit"
                    ),



                  ],
                ),
              ),
            ),
          ],
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

  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 14.0,
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
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextFormField1({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,

  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 14.0,
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
            controller: controller,
            inputFormatters: [ FilteringTextInputFormatter.deny(RegExp("0-9")),],
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
      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 16.0),
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



 /* bool _validateUserData() {
    RegExp regExpEmail = RegExp(kRegExpEmail);
    RegExp regExpPhone = RegExp(kRegExpPhone);


    if (_nameController.text.trim().isEmpty &&
        _userNameController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty &&
        _confirmPasswordController.text.trim().isEmpty) {
      ToastUtil.show(getString('registration_please_fill_up_all_the_fields'));
      return false;
    } else if (_nameController.text.trim().isEmpty) {
      ToastUtil.show(getString('name_is_required'));
      return false;
    } else if (_userNameController.text.trim().isEmpty) {
      ToastUtil.show(getString('username_is_required'));
      return false;
    } else if (_userNameController.text.trim().contains(" ")) {
      ToastUtil.show(getString('registration_username_space_error'));
      return false;
    } else if (_emailController.text.trim().isEmpty) {
      ToastUtil.show(getString('email_is_required'));
      return false;
    } else if (!regExpEmail.hasMatch(_emailController.text.trim())) {
      ToastUtil.show(getString('registration_please_enter_a_valid_email'));
      return false;
    } else if (_phoneController.text.trim().isEmpty) {
      ToastUtil.show(getString('phone_is_required'));
      return false;
    } else if (!regExpPhone.hasMatch(_phoneController.text.trim())) {
      ToastUtil.show(getString('registration_please_enter_a_valid_phone'));
      return false;
    } else if (_passwordController.text.trim().isEmpty) {
      ToastUtil.show(getString('password_is_required'));
      return false;
    } else if (_passwordController.text.trim().length < 8) {
      ToastUtil.show(getString('registration_passwords_should_have_length'));
      return false;
    } else if (_confirmPasswordController.text.trim().isEmpty) {
      ToastUtil.show(getString('confirm_password_is_required'));
      return false;
    } else if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ToastUtil.show(getString('registration_your_passwords_do_not_match'));
      return false;
    } else {
      return true;
    }
  }*/


}
