
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:creditscore/Apiservice/Responce/AddBankResponce.dart';
import 'package:creditscore/Apiservice/Responce/BankDetailsResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/base/AlertService.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/AlertDialogeBox.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/BankAccounts.dart';
import 'package:creditscore/Screen/Landingpage.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:creditscore/Screen/register/Register.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//import 'package:pdf_flutter/pdf_flutter.dart';
import '../Home.dart';
import 'bankdetails_contract.dart';
import 'bankdetails_contract.dart';
import 'bankdetails_contract.dart';

class AddBankDetails extends StatefulWidget {
  const AddBankDetails({Key key,this.loanId}) : super(key: key);
  final String loanId;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends BaseState<AddBankDetails> implements BankDetailsView {

  BankDetailsPresenterImpl _mPresenter;

  File localFile;
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
  String _directoryPath="";
  String filetype;
  var absalute_path;
  String token="";
  String userid="";
  bool _pathEmpty=false;
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
    _mPresenter = BankDetailsPresenterImpl(this);
    getData();
    super.initState();
  }

  void getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
      token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
  }
  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
  }


  Future<void> getfile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any);
    if(result != null) {
      localFile = File(result.files.first.path);
      _directoryPath = result.files.first.path;
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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
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

        String bankId = registerusers_responce.id;



       /* Fluttertoast.showToast(
            msg: "Success",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Rmlightblue,
            textColor: Colors.white,
            fontSize: 16.0);*/
       /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoanApproval(status: Status,)));*/
        _asyncFileUpload(File(_directoryPath),bankId);

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
            fontSize: 16.0);
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
            fontSize: 16.0);
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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BankAccounts()));
     /* Fluttertoast.showToast(
          msg: "Upload Successfully",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);*/

    }
    if(response.statusCode==401){
      print(responseString);
      pr.hide();
      /* Fluttertoast.showToast(
          msg: "Invalid Token",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }
    if(response.statusCode==404){
      print(responseString);
      pr.hide();
      /* Fluttertoast.showToast(
          msg: "Invalid Token",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);*/
    }else {
      pr.hide();
      throw Exception('Failed to load post');
    }



    // print(responseString["url"]);
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
                    Text("Bank Details", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
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
                        child:Form(
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
                                    "Bank details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
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
                              /*_directoryPath==""?Container():SfPdfViewer.file(
                      File(_directoryPath),
                      key: _pdfViewerKey,
                    ),*/

                              Padding(
                                padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),child: _directoryPath==""?Container():Text(_directoryPath),),
                              /*  _directoryPath==""?Container():Container(
                      alignment: Alignment.center,
                      child: Stack(children: [
                        Center(child:PDF.file(
                          File(_directoryPath),
                          height: 100,

                          width: MediaQuery.of(context).size.width,

                        ),),

                        Align(
                            alignment: Alignment.bottomRight,
                            child:IconButton(onPressed: (){
                              setState(() {
                                _navigateToPage(
                                  title: 'Bank Statement',
                                  child: PDF.file(
                                    File(_directoryPath),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                );
                              });
                            }, icon: Icon(Icons.file_copy_sharp,color: Rmlightblue,))),
                      ],),
                    height: 150,
                    width: 100,color: Colors.black,),*/

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
                                      fontSize: 18.0,
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
                              SizedBox(height: 20,),

                              Container(
                                height: 50.0,
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
                                          bankDetails();
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
                                      constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
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
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          Spacer(),
                                          Card(
                                            //color: Color(0xCDA3C5EC),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0)),
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
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage({ String title,  Widget child}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:child),
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
        ),body: Container(child:/* PDF.file(
      File(file),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
    )*/Text("")),))

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
                   /* Align(child: Container(
                        color: Rmlightblue,
                        padding: EdgeInsets.only(left: 10),

                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child:Text("Loan Status",style: TextStyle(color: Colors.white,fontSize: 18),)
                    ),alignment: Alignment.topCenter,
                    ),*/
                    SizedBox(height: 20,),
                  /* Align(child:Container(
                      margin: EdgeInsets.only(top: 20),
                      child:Text(widget.status,style: TextStyle(fontSize: 18),textAlign: TextAlign.center),

                      alignment: Alignment.center,),
                    ),*/
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