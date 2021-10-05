
import 'dart:io';

import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/bankDetails/BankDetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Screen/login/Login.dart';
class LoanAgreement extends StatefulWidget {
  const LoanAgreement({Key key,this.loanId}) : super(key: key);
   final String loanId;
  @override
  _LoanAgreementState createState() => _LoanAgreementState();
}

class _LoanAgreementState extends State<LoanAgreement> {
  File _image;
  ProgressDialog pr;
 String terms="";
  String token="";
  String userid="";
  String loanId="";
  String sign;
  @override
  void initState() {

    get_terms();
    super.initState();
  }

  get_terms() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
       sign=preferences.getString(Constants.docSign);
       loanId=preferences.getString(Constants.loanId)??"";
    });
    userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    terms=await PreferenceManager.sharedInstance.getString(Keys.TC.toString());
    print(sign);
    print(terms);
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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

              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,color: Colors.white,),
                      title: new Text('Upload from Gallery',style: TextStyle(color: Colors.white),),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,color: Colors.white),
                    title: new Text('Capture image & upload',style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  _asyncFileUpload( File file) async{
    //create multipart request for POST or PATCH method
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
    var postUri = Uri.parse(APIS.bankDocuments+"${loanId}");
    print(postUri);
    print(token);
    var request = http.MultipartRequest("POST",postUri);

    Map<String, String> headers = {
      "Authorization":token,
    };
    request.headers.addAll(headers);
    request.fields["key"] ="docLoanSign";

    print(file.path);

    var pic = await http.MultipartFile.fromPath("document", file.path,  contentType: MediaType('image','jpg'),);
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
      Fluttertoast.showToast(
          msg: "Upload Successfully",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BankDetails(loanId: widget.loanId,)));
    }
    else if(response.statusCode==401){
      print(responseString);
      pr.hide();
      Fluttertoast.showToast(
          msg: "Invalid Token",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else if(response.statusCode==404){
      print(responseString);
      pr.hide();
      Fluttertoast.showToast(
          msg: "Server Not Found",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // print(responseString["url"]);
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
              title: Text("Accepting the offer",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
            ),
            body: SingleChildScrollView(child:Container(padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(child: new Image.asset(
                 Constants.developerLogo,
                  width: 100,
                  height: 50,
                ),alignment: Alignment.center,),
                Align(child: Text("Loan Agreement",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),alignment: Alignment.center,),
                Text(terms),

                SizedBox(height: 10,),

                Text("Insert Signature ",style: TextStyle(fontWeight: FontWeight.bold),),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        border: Border.all(color: Rmlightblue),

                        borderRadius:BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: _image==null?Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ):Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10),
                  child: RaisedButton(
                    onPressed: () {
                      if(_image==null){
                        ToastUtil.show("Please select Signature image");
                      }
                      else{
                       _asyncFileUpload(_image);
                        /*Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Bankdetails()));*/
                      }

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
                        constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              "Accept",
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
              ],) ,),))));
  }
}
