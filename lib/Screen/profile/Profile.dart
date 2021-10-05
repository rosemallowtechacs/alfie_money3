
import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:creditscore/Screen/profile/profile_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Home.dart';



class Profiledata extends StatefulWidget {
  const Profiledata({Key key,this.token,this.userId}) : super(key: key);
  final String token;
  final String userId;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends BaseState<Profiledata> implements ProfileView{
  File _image;
  static const platform = const MethodChannel('heartbeat.fritz.ai/native');



  int radio = 1;
  int check = 2;
  ProfilePresenterImpl _mPresenter;
  String datee_time;
  String datee_time1;
  int _n = 0;
  TextEditingController _userNameController=TextEditingController();
  TextEditingController _userlastNameController=TextEditingController();
  TextEditingController _dateofbirthController = new TextEditingController();
  TextEditingController _icnumber = new TextEditingController();
  TextEditingController _addressController=TextEditingController();
  TextEditingController _addressController1=TextEditingController();
  TextEditingController _cityname=TextEditingController();
  TextEditingController _zipcode=TextEditingController();
  TextEditingController _mobilenumber = new TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController  _passwordController=TextEditingController();
  TextEditingController _confirmPasswordController=TextEditingController();
  TextEditingController _childcount = TextEditingController();
  TextEditingController _age = TextEditingController();

  ////drop down

  var currentSelectedValue;

  var education;
  var employmentStatus;


   List<FocusNode> _focusNodes;

  final formGlobalKey = GlobalKey < FormState > ();
  TextEditingController _facebookController=TextEditingController();
  DateTime selectedDate=DateTime.now().subtract(Duration(days: 1));
  bool isLoading = false;
  bool checkValue = false;
  ProgressDialog pr;
  bool _isHidePassword = true;
  String selectedEmployment;
  String selecteEducation;
  String selecteMaritalStatus;
  String radioItem = 'Loss of income or reduction in pay';

  // Group Value for Radio Button.
  bool id = false;
  String _genderRadioBtnVal="";

  var tmpArray = [];
  @override
  void dispose() {
    _userNameController.dispose();
    _userlastNameController.dispose();
    _dateofbirthController.dispose();
    _icnumber.dispose();
    _addressController.dispose();
    _addressController1.dispose();
    _cityname.dispose();
    _zipcode.dispose();
    _mobilenumber.dispose();
    _emailController.dispose();
    _childcount.dispose();
    _passwordController.dispose();
    _age.dispose();

    super.dispose();
  }

  @override
  void initState() {

    _focusNodes = Iterable<int>.generate(4)
        .map((e) => FocusNode())
        .toList();

    _focusNodes[0].requestFocus();
     _mPresenter=ProfilePresenterImpl(this);
    selectedDate=DateTime.now();

    super.initState();
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1600, 8),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.white,
                onSecondary:Colors.white ,
                onSurface: Colors.black,
                background: Colors.black

              ),
              //dialogBackgroundColor: Color(0xfffe1705),
              dialogBackgroundColor: Rmlightblue,
            ),
            child: child,
          );
        });

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datee_time=DateFormat('MM-dd-yyyy').format(picked);
        _dateofbirthController.text = datee_time;
        datee_time1=DateFormat('yyMMdd').format(picked);
        print("DATEEEE" + datee_time);
        _icnumber.text= datee_time1+"-PB-";
        _age.text="Age: "+"${calculateAge(selectedDate)}";
      });
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Rmblue,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.white),
                    title: new Text('Camera',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),

                ],
              ),
            ),
          );
        });
  }
  void add() {
    setState(() {
      _n++;
    });
  }
  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
    });
  }
  void _handleGenderChange(String value) {
    setState(() {
      _genderRadioBtnVal = value;

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
              key: scaffoldKey,
              appBar: AppBar(
                brightness: Brightness.light,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  "Profile Details",
                  style: TextStyle(
                    color: Rmlightblue,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ),
              body:Stack(
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
                        child: Form(
                          key: formGlobalKey,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                  ),
                                  child: Image.asset(
                                    Constants.developerLogo,

                                    height: 30.h,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h,),


                              Container(
                                height: MediaQuery.of(context).size.height/1.5,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0,0 ,30),
                                        child: Stack(

                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 60,backgroundColor: Colors.grey,
                                              child: ClipOval(child: _image==null?Image.asset('assets/images/user.png', height: 150, width: 150, fit: BoxFit.cover,):Image.file(
                                                _image,
                                                width: 150.w,
                                                height: 150.h,
                                                  fit: BoxFit.cover
                                              ),),
                                            ),
                                         Positioned(bottom: 1, right: 1 ,child: Container(
                                              height: 30.h, width: 30.w,
                                              child: GestureDetector(child:Icon(Icons.add_a_photo, color: Colors.white,),onTap: (){
                                                setState(() {
                                                  _showPicker(context);
                                                });
                                              },),
                                              decoration: BoxDecoration(
                                                color: Rmlightblue,

                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                              )),
                                            ),

                                          ],
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _userNameController,
                                        hint:"First name",
                                        focus: true,
                                        inputType: TextInputType.text,
                                        validation:"Enter First name",
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _userlastNameController,
                                        hint:"Last name",
                                        validation:"Enter Last name",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),child:Row(
                                    children: <Widget>[
                                      Radio<String>(
                                        value: "Male",
                                        groupValue: _genderRadioBtnVal,
                                        onChanged: _handleGenderChange,
                                      ),
                                      Text("Male"),
                                      Radio<String>(
                                        value: "Female",
                                        groupValue: _genderRadioBtnVal,
                                        onChanged: _handleGenderChange,
                                      ),
                                      Text("Female"),
                                      Radio<String>(
                                        value: "Other",
                                        groupValue: _genderRadioBtnVal,
                                        onChanged: _handleGenderChange,
                                      ),
                                      Text("Other"),
                                    ],
                                  ),))),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,
                                          onTap: (){
                                            setState(() {
                                              _selectDate1(context);
                                            });
                                          },
                                          controller: _dateofbirthController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Select your DOB";
                                            }

                                            return null;
                                          },
                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.sp,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


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
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(Icons.date_range,color:Colors.purple ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'DOB (dd-mm-yyyy)',
                                            hintStyle: TextStyle(fontSize: 14.sp,color: Colors.grey),

                                          ),
                                        ),),),),
                                      buildTextFormField(
                                        controller: _age,
                                        hint:"Age",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.contact_page,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _icnumber,
                                        hint:"IC Number",
                                        inputType: TextInputType.text,
                                        validation:"Enter IC number",
                                        icon: Icon(
                                          Icons.confirmation_num,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),

                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                          child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),child:DropdownButtonFormField<String>(
                                            value: selecteMaritalStatus,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white))),
                                            hint: Text(
                                              'Select Marital Status',style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)
                                            ),
                                            onChanged: (salutation) =>
                                                setState(() => selecteMaritalStatus = salutation),
                                            validator: (value) => value == null ? 'field required' : null,
                                            items:
                                            ["Single", "Married", "Divorced","Widowed"].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)),
                                              );
                                            }).toList(),
                                          ),))),


                                      buildTextFormField(
                                        controller: _childcount,
                                        hint:"Number of children",
                                        inputType: TextInputType.number,
                                        validation:"Enter Number of children",
                                        icon: Icon(
                                          Icons.child_friendly_outlined,
                                          color: Colors.cyan,
                                        ),
                                      ),


                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                          child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),child:DropdownButtonFormField<String>(
                                            value: selecteEducation,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white))),
                                            hint: Text(
                                              'Level of education',style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)
                                            ),
                                            onChanged: (salutation) =>
                                                setState(() => selecteEducation = salutation),
                                            validator: (value) => value == null ? 'field required' : null,
                                            items:
                                            ["Primary", "Secondary", "Diploma", "University", "Professional certification"].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)),
                                              );
                                            }).toList(),
                                          ),))),

                                      Padding(
                                      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                      child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),child:DropdownButtonFormField<String>(
                                        value: selectedEmployment,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white))),
                                        hint: Text(
                                          'Employment status',style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)
                                        ),
                                        onChanged: (salutation) =>
                                            setState(() => selectedEmployment = salutation),
                                        validator: (value) => value == null ? 'field required' : null,
                                        items:
                                        ['Full-time','Part-time', 'Contract', 'Casual', 'Business owner', 'Unemployed'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,style: TextStyle( color: kSecondaryTextColor, fontSize: 14.0,)),
                                          );
                                        }).toList(),
                                      ),))),

                                      // Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),child: _buildRadios(),),
                                      buildTextFormField(
                                        controller: _addressController,
                                        hint:"Address",
                                        inputType: TextInputType.text,
                                        validation:"Enter Address1",
                                        icon: Icon(
                                          Icons.location_on,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,

                                          controller: _addressController1,

                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.sp,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


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
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(Icons.location_on,color:Colors.green ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'Address 2',
                                            hintStyle: TextStyle(fontSize: 14.sp,color: Colors.grey),

                                          ),
                                        ),),),),

                                      /*buildTextFormField(
                                        controller: _addressController1,
                                        hint:"Address 2",
                                        validation:"Enter Address2",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.add_location_rounded,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),*/
                                      buildTextFormField(
                                        controller: _cityname,
                                        hint:"City Name",
                                        inputType: TextInputType.text,

                                        validation:"Enter City Name",
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _zipcode,
                                        hint:"Zip code",
                                        maxLength: 5,
                                        validation:"Enter Zip code",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      /*buildTextFormField(
                        controller: _mobilenumber,
                        hint:"Mobile number",
                        validation:"Enter Mobile number",
                        maxLength:10,
                        inputType: TextInputType.number,
                        icon: Icon(
                          Icons.phone_android,
                          color: Color(0xFFFEB71E),
                        ),
                      ),*/
                                      buildTextFormField(
                                        controller: _emailController,
                                        hint: "Email Id",
                                        validation:"Enter Email Id",
                                        inputType: TextInputType.emailAddress,
                                        icon: Icon(
                                          Icons.email,
                                          color: Rmblue,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,

                                          controller: _facebookController,

                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.sp,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


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
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(FontAwesomeIcons.facebook,color:Rmblue ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'Facebook Id',
                                            hintStyle: TextStyle(fontSize: 14.sp,color: Colors.grey),

                                          ),
                                        ),),),),

                                    ],)),),


                              SizedBox(height: 20.h,),

                              Container(
                                height: 50.h,
                                alignment: Alignment.center,
                                child: RaisedButton(
                                  onPressed: () {

                                   setState(() {
                                     if(_image==null){
                                       showSnackBar("Select Your Profile Picture.");
                                     }else{
                                       submitBtnDidTapped();
                                     }
                                   });

                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.all(0.0),
                                  color: Rmpick,
                                  splashColor: Rmpick,
                                  child: Ink(
                                    decoration: BoxDecoration(

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
                              SizedBox(height: 10.h,),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    "Already have an account? Login !",
                                    style: TextStyle(
                                      color: kSecondaryTextColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),)
                    ),
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
    bool focus,
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
              fontSize: 16.sp,
            ),
          ),
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
    submitBtnFileUpload();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home()));
  }
  @override
  void submitBtnFileUpload()  {
    _mPresenter.doFileUpload(_image);
  }

  @override
  void submitBtnDidTapped() {
    // TODO: implement submitBtnDidTapped
    if(formGlobalKey.currentState.validate()){

      int len = _icnumber.text.length;
      if(len>=10){
        String icnumber = _icnumber.text.substring(0,10);

        if(datee_time1+"-PB-"==icnumber){
          print("DATE "+ icnumber);

          _mPresenter.doRegistration(widget.userId,
              { 'firstName':_userNameController.text.toString().trim(),
                'lastName':_userlastNameController.text.toString().trim(),
                'icNumber':"${_icnumber.text.toString()}",
                'dob':datee_time.toString(),
                'address1':_addressController.text.toString().trim(),
                'address2':_addressController1.text.toString().trim(),
                'city':_cityname.text.toString().trim(),
                'zipCode':_zipcode.text.toString().trim(),
                'email':_emailController.text.toString().trim(),
                'facebookId':_facebookController.text.toString().trim(),
                'maritalStatus':selecteMaritalStatus,
                'numOfChild':int.parse(_childcount.text.toString().trim()),
                'educationLevel':selecteEducation,
                'employmentStatus':selectedEmployment,
                'gender':_genderRadioBtnVal,

              });

        }else{
          showSnackBar("Invalid IC number Should be this format \n(yymmdd-PB-)");
          // Invalid IC number Should be this format \n(yymmdd-PB-)
        }
      }else{
        showSnackBar("Invalid IC number Should be this format \n(yymmdd-PB-)");
        // Invalid IC number Should be this format \n(yymmdd-PB-)
      }



    }

  }

}
