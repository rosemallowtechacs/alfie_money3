import 'dart:convert';

import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/UserdetailsResponce.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {

  int counter = 0;
  String firstName="";
  String lastName="";
  String icNumber="";
  String dob="";
  String address1="";
  String emailId="";
  String mobilenumber="";
  String datee="";
  ProgressDialog pr;
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
  TextEditingController  _fbid=TextEditingController();
  bool prodileUpadetdstate=false;
  DateTime selectedDate=DateTime.now().subtract(Duration(days: 1));
  String datee_time;
  String datee_time1;
  @override
  void initState() {
    getUserdata();
    //getdetails();
    super.initState();
  }

  Future<void> profileRegister() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String  token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    print(token);
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

    int icnum=int.parse(_icnumber.text);
    int zipCode=int.parse(_zipcode.text);
    final body = {
      'firstName':_userNameController.text.toString().trim(),
      'lastName':_userlastNameController.text.toString().trim(),
      'icNumber':icnum,
      'address1':_addressController.text.toString().trim(),
      'address2':_addressController1.text.toString().trim(),
      'city':_cityname.text.toString().trim(),
      'zipCode':zipCode,
      'dob':_dateofbirthController.text.toString(),
      'email':_emailController.text.toString().trim(),
      'facebookId':_fbid.text.toString().trim()
      };
    //final json = '{"firstName":${_userNameController.text.toString().trim()}, "lastName": ${_userlastNameController.text.toString().trim()}}';
    print(json.encode(body));


    var response = await http.put(Uri.parse(APIS.profiledata+userid), headers: {
      "Content-type": "application/json",
      "Authorization": token}, body: json.encode(body));
    print(response.headers);
    try {
      if (response.statusCode == 200) {
        pr.hide();
        var responseJSON = json.decode(response.body);
        //Profiledetails  registerusers_responce = Profiledetails.fromJson(responseJSON);
        print(responseJSON);



        Fluttertoast.showToast(
            msg:"Update Successful" ,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Rmlightblue,
            textColor: Colors.white,
            fontSize: 16.0);

        return responseJSON;
      }else if (response.statusCode == 401) {
        print('ramesh' + response.body);
        setState(()  {

          var responseJSON = json.decode(response.body);
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
      }else{
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }

  Future getUserdata() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String  token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    print(token);
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
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
    var response= await http.get(Uri.parse(APIS.getuser+userId),headers: {
      "Authorization":token,
    },);
    try{
    if (response.statusCode == 200) {
      String data = response.body;
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      setState(() {
        var decodedData = jsonDecode(data);
        Profiledetails  registerusers_responce = Profiledetails.fromJson(decodedData);
        print(registerusers_responce.firstName);
        _userNameController.text=registerusers_responce.firstName ;
        _userlastNameController.text=registerusers_responce.lastName;
        _icnumber.text=registerusers_responce.icNumber;
        _addressController.text=registerusers_responce.address1;
        _addressController1.text=registerusers_responce.address2;
        _dateofbirthController.text=formatter.format(DateTime.parse(registerusers_responce.dob));
        _cityname.text=registerusers_responce.city;
        _zipcode.text=registerusers_responce.zipCode;
        _emailController.text=registerusers_responce.email;
        _fbid.text=registerusers_responce.facebookId;
        _mobilenumber.text="${registerusers_responce.mobile}";


        print(registerusers_responce.docSign);

      });
      print(data);

      pr.hide();
    }}catch(e){
      pr.hide();
    //  getUserdata();
    }
    /*try {
       else {
        pr.hide();
        print("failad");
        return 'failed';
      }
    } catch (e) {
      pr.hide();
      return 'failed';
    }*/

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
        //_icnumber.text= datee_time1;
      });
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
            ),
            body: SingleChildScrollView(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Image.asset(
                      Constants.developerLogo,
                      width: 50,
                      height: 50,
                    ),
                   /* Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height/3.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Rmlightblue,Rmpick],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(200.0),


                        ),
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 110.0,),
                            CircleAvatar(
                              radius: 55.0,
                              backgroundImage: AssetImage('assets/images/user.png'),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 10.0,),
                            Text(firstName,
                                style: TextStyle(
                                  color:Colors.white,
                                  fontSize: 20.0,
                                )),
                            SizedBox(height: 10.0,),

                          ]
                      ),
                    ),*/




                    Container(

                        padding: EdgeInsets.all(30),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: [
                              Text("Profile Information",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w800,
                                ),),
                              Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                            ],),
                            Divider(color: Colors.grey[300],),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("First name :"),
                                buildTextFormField(
                                  controller: _userNameController,
                                  hint:"First name",
                                  inputType: TextInputType.text,
                                  validation:"Enter First name",
                                  icon: Icon(
                                    Icons.account_circle,
                                    color: Color(0xFFFEB71E),
                                  ),
                                ),
                                Text("Last name :"),
                                buildTextFormField(
                                  controller: _userlastNameController,
                                  hint:"Last name",
                                  validation:"Enter Last name",
                                  inputType: TextInputType.text,
                                  icon: Icon(
                                    Icons.account_circle,
                                    color: Color(0xFFFEB71E),
                                  ),
                                ),
                                Text("DOB :"),
                                TextFormField(
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
                                    fontSize: 14.0,
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
                                    hintText: 'DOB e.g dd-mm-yyyy',
                                    hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                                  ),
                                ),
                                Text("IC Number :"),
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
                                // Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),child: _buildRadios(),),
                                Text("Address :"),
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

                                Text("Address 2 :"),
                                buildTextFormField(
                                  controller: _addressController1,
                                  hint:"Address2 ",
                                  inputType: TextInputType.text,
                                  validation:"Enter Address2",
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Color(0xFFFEB71E),
                                  ),
                                ),
                                Text("City Name :"),

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

                                Text("Zip code :"),
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
                                Text("Email Id :"),
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
                                Text("Facebook Id :"),
                                buildTextFormField(
                                  controller: _fbid,
                                  hint:"facebook id",
                                  maxLength: 5,
                                  inputType: TextInputType.text,
                                  icon: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Color(0xFFFEB71E),
                                  ),
                                ),
                              ],),

                            SizedBox(height: 20.0,),
                            Container(
                              height: 50.0,

                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width/1.5,
                              child: RaisedButton(
                                onPressed: () async {
                                  profileRegister();
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                padding: EdgeInsets.all(0.0),
                                color: Rmpick,
                                splashColor: Rmpick,
                                child: Ink(
                                  decoration: BoxDecoration(
                                      color: Rmlightblue,
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Text(
                                          "Update",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 35.0,
                                          height: 35.0,
                                          child: Icon(
                                            Icons.upload_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],

                        )),
                  ],




            ),)
        )));
  }
}
Widget  buildTextFormField({
  TextEditingController controller,
  String hint,
  TextInputType inputType,
  int maxLength,
  Icon icon,
  String validation,
  bool focus,
  bool profileedit
}) {
  return TextFormField(
          obscureText: inputType == TextInputType.visiblePassword,
          autofocus: focus != null ? focus : false,
          textInputAction: TextInputAction.next,

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


  );
}