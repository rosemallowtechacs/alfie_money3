import 'dart:io';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/Loandeals.dart';
import 'package:creditscore/Screen/bankDetails/BankDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/MyFormTextField.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'LoanAgreement.dart';
const directoryName = 'ACS';
class Loancontract extends StatefulWidget {
  const Loancontract({Key key, this.loanId}) : super(key: key);

  final String loanId;

  @override
  _LoandetailsState createState() => _LoandetailsState();
}

class _LoandetailsState extends State<Loancontract> {
  double _lowerValue = 0;
  double _months=0;
  double _upperValue = 180;
  bool checkBoxValue = false;
  double _height;
  File _image;
  String loanId;
  String productType;
  String tenureMonth;
  String loanFeess;
  String loanAmount;
  String mobileNumber;
  String kycPath;
  String signature;
  Random random = new Random();
  double _width;
  DateTime selectedDate=DateTime.now();
  int randomNumber=0;
  final _formKey = GlobalKey<FormState>();
   String token="";
  final value = new NumberFormat("#,##0", "en_US");
  TextEditingController username = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController icnumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController mobilenumber = new TextEditingController();
  TextEditingController emailaddress = new TextEditingController();
  TextEditingController dateee = new TextEditingController();
  TextEditingController product = new TextEditingController();
  TextEditingController loanamount = new TextEditingController();
  TextEditingController Loanfees = new TextEditingController();
  TextEditingController interestrate = new TextEditingController();
  TextEditingController tenure = new TextEditingController();
  TextEditingController Loanrepayment = new TextEditingController();
  TextEditingController penalties = new TextEditingController();
  ProgressDialog pr;
  Map<String, String> headersMap ;


  @override
  void initState() {
    // TODO: implement initState
    getloandetails();
    super.initState();
  }
  @override
  getloandetails()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    username.text = preferences.getString(Constants.firstName);
    lastname.text=preferences.getString(Constants.lastName);
    emailaddress.text = preferences.getString(Constants.emailId);
    icnumber.text = preferences.getString(Constants.icNumbe);
    address.text = preferences.getString(Constants.address1);
    dateee.text=formattedDate;
    loanId=preferences.getString(Constants.loanId)??"";
    product.text=preferences.getString(Constants.productType)??"";
    tenure.text=preferences.getString(Constants.tenureMonth)??"";
    double fees=(double.parse(preferences.getInt(Constants.loanAmount).toString()) * 1 / 100) ;
    Loanfees.text="RM${value.format(fees)}";
    double prof=preferences.getDouble(Constants.profitRate)??"";
    interestrate.text="RM"+value.format(prof);
    double loan=double.parse(preferences.getInt(Constants.loanAmount).toString())??"";
    loanamount.text="RM"+value.format(loan)??"";
    mobilenumber.text= "${await PreferenceManager.sharedInstance.getInt(
        Keys.MOBILE_NUM.toString())??""}";
     token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString())??"";
    kycPath=await PreferenceManager.sharedInstance.getString(Keys.E_KYC.toString())??"";
    signature=preferences.getString(Constants.docSign)??"";
    headersMap = {
      'Authorization' : token
    };

  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1600, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Rmpick,
                onPrimary: Colors.white,
                surface: Rmpick,
                onSurface: Colors.white,
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
        dateee.text = DateFormat('dd-MM-yyyy').format(picked);

      });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Loanprocess())),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Loan Agreement",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
        ),
        body: Container(
          color: Colors.white,
      height: MediaQuery.of(context).size.height,
          padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: SingleChildScrollView(child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10.h,),
          Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Text("Loan Id: ",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(widget.loanId,style: TextStyle(fontWeight: FontWeight.bold)),
                    ],),

                    SizedBox(height: 10.h,),

                    Text("Personal info: ",style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("First name :",style: TextStyle(fontSize: 12),),),
                    buildTextFormField(
                      controller: username,
                      hint:"first name",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter first name",
                      icon: Icon(
                        Icons.account_circle,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Last name :",style: TextStyle(fontSize: 12),),),
                    buildTextFormField(
                      controller: lastname,
                      hint:"last name",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter last name",
                      icon: Icon(
                        Icons.account_circle,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("IC Number :",style: TextStyle(fontSize: 12),),),
                    buildTextFormField(
                      controller: icnumber,
                      hint:"IC Number",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter IC Number",
                      icon: Icon(
                        Icons.confirmation_num,
                        color: Color(0xFFFEB71E),
                      ),
                    ),


                    SizedBox(height: 10.h,),
                    Text("IC Image "),
                    SizedBox(height: 10.h,),


                    GestureDetector(child: Container(
               decoration: BoxDecoration(
                 border: Border.all(color: Rmlightblue),

                 borderRadius:BorderRadius.all(Radius.circular(20.0)),
                 color: Colors.black,
               ),
               padding: EdgeInsets.all(20),
               margin: EdgeInsets.all(20),
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height/5,
               child: CachedNetworkImage(

                 placeholder: (context, url) => Container(
                     height: 20.h,
                     width: 20.w,
                     child: Icon(Icons.image,color: Colors.white,)),
                 errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
                 imageUrl: 'http://104.131.5.210:7400/api/users/doc/${kycPath}?key=${"docEKYC"}',
                 httpHeaders: headersMap,
                 width: 100.w,
                 height: 100.h,
                 fit: BoxFit.fitHeight,
               ),),onTap: (){
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:kycPath ,keyvalue: "docEKYC",title:"IC Image")));
                      });
                    },),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Address :",style: TextStyle(fontSize: 12),),),
                    buildTextFormField(
                      controller: address,
                      hint:"Address",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Address",
                      icon: Icon(
                        Icons.location_on,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Mobile number :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: mobilenumber,
                      hint:"Mobile number",
                      maxLength: 10,
                      showtext: false,
                      inputType: TextInputType.number,
                      validation:"Enter mobilenumber",
                      icon: Icon(
                        Icons.phone,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Email Id :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: emailaddress,
                      hint:"Email address",
                      showtext: false,
                      inputType: TextInputType.text,
                      validation:"Enter Email id",
                      icon: Icon(
                        Icons.email,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Date :",style: TextStyle(fontSize: 12),),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),child:TextFormField(
                        textAlign: TextAlign.left,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        onTap: (){
                          setState(() {
                            _selectDate1(context);
                          });
                        },
                        controller: dateee,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Select Agreement date";
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
                                setState(() {
                                  _selectDate1(context);
                                });
                              },
                            ), // icon is 48px widget.
                          ),
                          hintText: 'Agreement date (dd-mm-yyyy)',
                          hintStyle: TextStyle(fontSize: 14.sp,color: Colors.grey),

                        ),
                      ),),),),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Product Type :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: product,
                      hint:"Product",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Product",
                      icon: Icon(
                        Icons.email,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
        Padding(
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
          child:Text("Loan Amount :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: loanamount,
                      hint:"Loan Amount",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Loan Amount",
                      icon: Icon(
                        Icons.local_atm,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Loan fees :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: Loanfees,
                      hint:"Loan fees",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Loan fees",
                      icon: Icon(
                        Icons.local_atm,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Total profit rate :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: interestrate,
                      hint:"Interestrate",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Profit rate",
                      icon: Icon(
                        Icons.calculate_rounded,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                      child:Text("Tenure :",style: TextStyle(fontSize: 12.sp),),),
                    buildTextFormField(
                      controller: tenure,
                      hint:"Tenure",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Tenure",
                      icon: Icon(
                        Icons.calendar_view_month,
                        color: Color(0xFFFEB71E),
                      ),
                    ),


                  ],
                ),
              ),



            ],
          ),


          Text("Signature Image ",style: TextStyle(fontWeight: FontWeight.bold),),
          GestureDetector(child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Rmlightblue),

              borderRadius:BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black,
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/5,
            child: CachedNetworkImage(

              placeholder: (context, url) => Container(
                  height: 20.h,
                  width: 20.w,
                  child: Icon(Icons.image,color: Colors.white,)),
              errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
              imageUrl: 'http://104.131.5.210:7400/api/users/doc/${signature}?key=${"docSign"}',
              httpHeaders: headersMap,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.fitHeight,
            )),onTap: (){
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:signature ,keyvalue: "docSign",title: "Signature",)));
            });
          },),

          SizedBox(height: 20),
          Container(
            height: 50.h,
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {

                SharedPreferences preferences = await SharedPreferences.getInstance();
                if(_formKey.currentState.validate()){

                  setState(() {

                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => BankDetails(loanId: widget.loanId,)));
                  });

                }
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
                        "Next",
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

          SizedBox(height: 20.sp,),
        ],
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
    bool showtext
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            enabled:showtext ,
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
              }if(maxLength==10){
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
}
class ImageView extends StatelessWidget {
  const ImageView({Key key,this.path,this.token,this.keyvalue,this.title}) : super(key: key);
 final String path;
  final String token;
  final String keyvalue;
  final String title;
  @override
  Widget build(BuildContext context) {
    Map<String, String> headersMap = {
      'Authorization' : token
    };
    return Container(
        color: Rmlightblue,
        child:SafeArea(child: Scaffold(appBar: AppBar(
          brightness: Brightness.light,
          title: Text(title,style: TextStyle(color: Rmlightblue),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),body: Container(child:CachedNetworkImage(
          imageUrl: 'http://104.131.5.210:7400/api/users/doc/$path?key=${keyvalue}',
          httpHeaders: headersMap,
          placeholder: (context, url) => Container(
              height: 20.h,
              width: 20.w,
              child: Icon(Icons.image,color: Colors.white,)),
          errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
          width: MediaQuery.of(context).size.width,
          height:  MediaQuery.of(context).size.height,
          fit: BoxFit.fitHeight,
        ),),),)

    );
  }
}