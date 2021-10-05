
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/Responce/AddBankResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ViewBankResponce.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/AlertDialogeBox.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/Landingpage.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../Home.dart';
import 'bankdetails_contract.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key key,this.loanId}) : super(key: key);
  final String loanId;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends BaseState<BankDetails> implements BankDetailsView {

  BankDetailsPresenterImpl _mPresenter;

  File localFile;
  bool loading=true;
  String Status="";
  String _bankID;
  TextEditingController _nameController= TextEditingController();
  TextEditingController _banknameController= TextEditingController();
  TextEditingController _branchController= TextEditingController();
  TextEditingController _nameasperbank= TextEditingController();
  TextEditingController _phoneController= TextEditingController();
  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  TextEditingController _confirmPasswordController= TextEditingController();
  TextEditingController _acnoController= TextEditingController();
  final formGlobalKey1 = GlobalKey < FormState > ();
  ProgressDialog pr;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isLoading = false;
  bool complete=false;
  String _directoryPath="";
  String filetype;
  var absalute_path;
  String token="";
  String userid="";
  bool _pathEmpty=false;

  List<Banklistdetails> _bank=[];
  Banklistdetails _projectItem;
  static const platform = const MethodChannel('heartbeat.fritz.ai/native');
  @override
  void dispose() {
    _nameController.dispose();
    _banknameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameasperbank.dispose();
    _branchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getBankId();
    _mPresenter = BankDetailsPresenterImpl(this);
    getData();
    super.initState();
  }

  void getData() async{

    userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
  }



  Future<void> getfile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any);
    if(result != null) {
      localFile = File(result.files.first.path);
      _directoryPath = result.files.first.path;
    }
  }

  getBankId() async{
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response= await http.get(Uri.parse(APIS.ViewBankDetails),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });


    if (response.statusCode == 200) {
      print('ramesh' + response.body);

      setState(() {
        loading=false;
        _bank = BankListRes.fromJson(json.decode(response.body)).projectlistdetails;
      });
      print("rrrrrrrr");
      print(_bank.length);


    }
    else {
      throw Exception('Failed to load album');
    }

  }

  Future bankDetails1() async {
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

    var body = jsonEncode({
      'bankName': _banknameController.text.toString().trim(),
      'payee': _nameasperbank.text.toString().trim(),
      'accountNumber': int.parse(_acnoController.text),
    });

    print(body);
    String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    // String loanId= preferences.getString(Constants.loanId);

    print(token);
    var postUri = Uri.parse(APIS.AddBankDetails);
    print(postUri);
    var response = await http.post(postUri, headers: {
      "Authorization":token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    }, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('ramesh' + response.body);
      setState(() {
        pr.hide();
        var responseJSON = json.decode(response.body);
        AddBankdetailsRes registerusers_responce = AddBankdetailsRes
            .fromJson(responseJSON);
        print(responseJSON);

        _bankID = registerusers_responce.id;

        String Status= preferences.getString(Constants.loanStatus);
        if(Status=="Loan approval pending"){
          Status=Constants.loanstatus2;
        }else{
          Status=Constants.loanstatus3;
        }

        _asyncFileUpload(File(_directoryPath),_bankID);

      });
    }
    if (response.statusCode == 401) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);
        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }
    if (response.statusCode == 500) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);

        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }

  }
  Future bankDetails() async {
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

    var body = jsonEncode({
      'bankId': _bankID,
    });

    print(body);
    String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String loanId= preferences.getString(Constants.loanId);

    print(token);
    var postUri = Uri.parse(APIS.AddBankLoan+loanId);
    print(postUri);
    var response = await http.put(postUri, headers: {
      "Authorization":token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    }, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('ramesh' + response.body);
      setState(() {
        pr.hide();
        var responseJSON = json.decode(response.body);
        AddBankdetailsRes registerusers_responce = AddBankdetailsRes
            .fromJson(responseJSON);
        print(responseJSON);

        String bankId = registerusers_responce.id;

        Status= preferences.getString(Constants.loanStatus);

        complete=true;


      });
    }
    if (response.statusCode == 401) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);
        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }
    if (response.statusCode == 500) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);

        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      });
    }

  }
  _asyncFileUpload( File file,String id) async{

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
    String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    String loanId= preferences.getString(Constants.loanId);

    var postUri = Uri.parse(APIS.AddBankDocument+"${id}");

    print(token);
    var request = http.MultipartRequest("POST",postUri);
    //add text fields
    Map<String, String> headers = {
      "Authorization":token,
    };
    request.headers.addAll(headers);
    request.fields["key"] ="docBankStatements";
    //create multipart using filepath, string or bytes
    print(file.path);
    var pic = await http.MultipartFile.fromPath("document", file.path,  contentType: MediaType("application", "pdf"),);
    //add multipart to request
    print(pic.filename);
    request.files.add(pic);
    var response = await request.send();
    print(response.statusCode);

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if(response.statusCode==200){
      print(responseString);
      pr.hide();
      bankDetails();

    }
    if(response.statusCode==401){
      print(responseString);
      pr.hide();

    }
    if(response.statusCode==404){
      print(responseString);
      pr.hide();

    }else {
      throw Exception('Failed to load post');
    }

  }
  DropdownMenuItem<Banklistdetails> buildDropdownMenuItem(Banklistdetails item) {
    return DropdownMenuItem(
      value: item, // you must provide a value
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(item.bankName ?? ""),
      ),
    );
  }
  Future<void> responseFromNativeCode() async {
    int mobilenumber=await PreferenceManager.sharedInstance.getInt(Keys.MOBILE_NUM.toString());

    try {

      final String result = await platform.invokeMethod('ActivityStart',{"mobilenumber":"$mobilenumber"});

    } on PlatformException catch (e) {
    }

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
              appBar: AppBar(
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title:  FadeAnimation(1.6,
                    Text("Bank Details", style: TextStyle(color: Rmlightblue, fontSize: 18.sp, fontWeight: FontWeight.bold),)
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              floatingActionButton: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.exit_to_app),
                  backgroundColor: Colors.red,
                  onPressed: (){
                    setState(() {
                      var dialog = CustomAlertDialog(
                          title: "Logout",
                          message: "Are you sure, do you want to logout?",
                          onPostivePressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          positiveBtnText: 'Yes',
                          negativeBtnText: 'No');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog);
                    });
                  }
              ),
              body: loading==true?Container(child:Center(child: CircularProgressIndicator(),)):Stack(
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
                        child: complete? Column(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Image.asset(
                              Constants.developerLogo,
                              width: 100.w,
                              height: 100.h,
                            ),

                            Card(
                                elevation: 5,
                                margin: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
                                child:Container(
                                    height: 200.h,
                                    width: MediaQuery.of(context).size.width/1,
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        FadeAnimation(1.6,
                                            Text(Status, style: TextStyle(color: Rmlightblue, fontSize: 18.sp, fontWeight: FontWeight.bold),)
                                        ),

                                      ],))),
                            SizedBox(height: 80,),

                            Container(
                              height: 50.h,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10,top: 10),
                              child: RaisedButton(
                                onPressed: () async {
                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                  setState(() {
                                    if(preferences.getBool(Constants.dataCollection)==true){
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => Home()));
                                      responseFromNativeCode();
                                    }else{
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => Home()));

                                    }
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
                                          "View your dashboard",
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

                          ],):_bank.isEmpty?Form(
                          key: formGlobalKey1,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 1.0,
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 100.w,
                                    height:100.h,
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
                                    "Bank details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              buildTextFormField(
                                controller: _banknameController,
                                hint:"Bank Name",
                                validation:"Enter Bank name",
                                inputType: TextInputType.text,
                                icon: Icon(
                                  Icons.account_balance,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: _nameasperbank,
                                hint:"Payee",
                                validation:"Enter Payee",
                                inputType: TextInputType.text,
                                icon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              buildTextFormField(
                                controller: _acnoController,
                                hint:"Account number",
                                maxLength: 18,
                                validation:"Enter Account number",
                                inputType: TextInputType.number,
                                icon: Icon(
                                  Icons.person,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),child: _directoryPath==""?Container():Text(_directoryPath),),


                              GestureDetector(child:  Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 1.0,
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    "Attach latest bank statement",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Rmlightblue,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),onTap: () async {
                                final file = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf', 'doc']);

                                setState(() {
                                  _directoryPath="";
                                  if (file?.files[0].path != null) {

                                    _directoryPath=file.files[0].path;

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to load Picked file'),
                                      ),
                                    );
                                  }
                                });
                              },),
                              _pathEmpty?Text("(Please Click to Upload Bank Statement)",style: TextStyle(color: Colors.red),):Container(),
                              SizedBox(height: 20.h,),

                              Container(
                                height: 50.h,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 10),
                                child: RaisedButton(
                                  onPressed: () {
                                    if(formGlobalKey1.currentState.validate()){
                                      setState(() {

                                        if(_directoryPath==""){
                                          _pathEmpty=true;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please select Bank statement'),
                                            ),
                                          );
                                        }else{
                                          //_asyncFileUpload(File(_directoryPath));
                                          bankDetails1();
                                        }
                                      });


                                    }



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


                            ],
                          ),):Form(
                          key: formGlobalKey1,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 1.0,
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 100.w,
                                    height:100.h,
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
                                    "Bank Details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                child:Card(
                                  elevation: 2.0,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child:Container (
                                        padding: EdgeInsets.all(10),
                                        child:  DropdownButton<Banklistdetails>(
                                          elevation: 1,
                                          hint: Text("Select Your Bank"),
                                          isExpanded: true,
                                          items: _bank.map((item) => buildDropdownMenuItem(item)).toList(),
                                          value: _projectItem, // values should match
                                          onChanged: (Banklistdetails item) {
                                            // setState(() => _projectItem = item);
                                            setState(() {
                                              _projectItem = item;
                                              _banknameController.text=_projectItem.bankName;
                                              _nameasperbank.text=_projectItem.payee;
                                              _acnoController.text=_projectItem.accountNumber;
                                              _bankID=_projectItem.id;
                                              print(_projectItem.id);

                                            });
                                          },
                                        ),)),),),

                              buildTextFormField(
                                controller: _nameasperbank,
                                hint:"Payee",
                                showtext:false,
                                validation:"Enter Payee",
                                inputType: TextInputType.text,
                                icon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              buildTextFormField(
                                controller: _acnoController,
                                hint:"Account number",
                                maxLength: 18,
                                showtext:false,
                                validation:"Enter Account number",
                                inputType: TextInputType.number,
                                icon: Icon(
                                  Icons.person,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),child: _directoryPath==""?Container():Text(_directoryPath),),


                              _bank.isEmpty? GestureDetector(child:  Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 1.0,
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    "Attach latest bank statement",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Rmlightblue,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),onTap: () async {
                                final file = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf', 'doc']);

                                setState(() {
                                  _directoryPath="";
                                  if (file?.files[0].path != null) {

                                    _directoryPath=file.files[0].path;

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to load Picked file'),
                                      ),
                                    );
                                  }
                                });
                              },):Container(),
                              _pathEmpty?Text("(Please Click to Upload Bank Statement)",style: TextStyle(color: Colors.red),):Container(),
                              SizedBox(height: 20.sp,),

                              Container(
                                height: 50.h,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 10),
                                child: RaisedButton(
                                  onPressed: () {
                                    if(_bank.isEmpty){
                                      if(formGlobalKey1.currentState.validate()){
                                        setState(() {

                                          if(_directoryPath==""){
                                            _pathEmpty=true;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please select Bank statement'),
                                              ),
                                            );
                                          }else{
                                            //_asyncFileUpload(File(_directoryPath));
                                            bankDetails();
                                          }
                                        });


                                      }
                                    }else{
                                      if(_nameasperbank.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Please Select Bank details",
                                            timeInSecForIosWeb: 1,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.sp);
                                      }else{
                                        bankDetails();
                                      }

                                    }

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
    bool showtext,
    String validation,
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
            textInputAction: TextInputAction.next,
            enabled: showtext,
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
  }

  @override
  void submitBtnDidTapped() {
    // TODO: implement submitBtnDidTapped
  }
}
class Bankstatement extends StatelessWidget {
  const Bankstatement({Key key,this.title,this.file}) : super(key: key);
  final String title;
  final String file;
  @override
  Widget build(BuildContext context) {
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
        ),body: Container(child:Text("")),))

    );
  }
}


class LoanApproval extends StatefulWidget {
  const LoanApproval({Key key,this.status}) : super(key: key);

  final String status;

  @override
  _LoanApprovalState createState() => _LoanApprovalState();
}

class _LoanApprovalState extends State<LoanApproval> {

  bool status=false;
  @override
  void initState() {
    startTime();
    super.initState();
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Constants.messageExit),
        content: new Text(Constants.messageExit1),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 30),
          new GestureDetector(
            onTap: () => exit(0),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    setState(() {
      status=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //String status= widget.status;
    return Container(
      color: Rmlightblue,
      child: SafeArea(child: WillPopScope(
        onWillPop: _onBackPressed,child:Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Column(
          children: [
            new Image.asset(
              Constants.developerLogo,
              width: 100,
              height: 100,
            ),
            Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
                child:Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width/1,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      status?Column(children: [
                        Text("Loan Approved",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                        SizedBox(height: 10,),
                        Text("Awaiting",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                        SizedBox(height: 10,),
                        Text("Disbursement",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                      ],):Column(children: [
                        Text("Awaiting",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                        SizedBox(height: 10,),
                        Text("Loan",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                        SizedBox(height: 10,),
                        Text("approval",style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                      ],),


                      //Text(status?"Loan Approved Awaiting Disbursement":"Awaiting Loan approval.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center),

                      SizedBox(height: 20,),

                      /*"Loan Approved Awaiting Disbursement"*/
                    ],),)
            ),
            SizedBox(height: 50,),
            status?Container(
              height: 50.0,
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  setState(() {

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
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Home",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ):Container(),
          ],
        ),),
      ),)),
    );
  }
}