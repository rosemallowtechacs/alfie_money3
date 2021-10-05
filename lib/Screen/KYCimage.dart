import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Screen/profile/Profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'register/Register.dart';

class Kycform extends StatefulWidget {
  const Kycform({Key key,this.token,this.userId}) : super(key: key);
  final String token;
  final String userId;
  @override
  _KycformState createState() => _KycformState();
}

class _KycformState extends State<Kycform> {

  File _image;
  ProgressDialog pr;
  _imgFromCamera() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
      preferences.setString("file_ic",_image.path);
    });
  }

  _imgFromGallery() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
      preferences.setString("file_ic",_image.path);
    });
  }



  Future<String> uploadSingleImage(File file) async
  {


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
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.w600));
    pr.show();
    String fileName = file.path.split("/").last;

    var stream  = new http.ByteStream(file.openRead());
    stream.cast();

    // get file length

    var length = await file.length(); //imageFile is your image file
    Map<String, String> headers = {
      "Authorization":widget.token
    }; // ignore this headers if there is no authentication

    var postUri = Uri.parse(APIS.fileupload+"${widget.userId}");


    print(postUri);

    var request = new http.MultipartRequest("POST", postUri);
    var multipartFileSign = new http.MultipartFile('document',
        stream,
        length,
        filename: fileName
    );
    var multipartFile = new http.MultipartFile('document', stream, length,
        filename:fileName);
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
  //  request.files.add(await http.MultipartFile.fromPath('document', file.path));
   // request.files.add(multipartFileSign);
    request.headers.addAll(headers);
    request.fields["key"] ="docSign";

    var response = await request.send();

    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      if(response.statusCode==200){
        pr.hide();
      }else if(response.statusCode==500){
        pr.hide();
        Fluttertoast.showToast(
            msg: "${value}",
            timeInSecForIosWeb: 10,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Color(0xFF550161),
            textColor: Colors.white,
            fontSize: 16.sp);
      }

    });
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
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.w600));
    pr.show();
    var postUri = Uri.parse(APIS.fileupload+"${widget.userId}");


    print(postUri);
    print(widget.token);
    var request = http.MultipartRequest("POST",postUri);
    //add text fields
    Map<String, String> headers = {
      "Authorization":widget.token,
    };
    request.headers.addAll(headers);
    request.fields["key"] ="docEKYC";
    //create multipart using filepath, string or bytes
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
          context, MaterialPageRoute(builder: (context) => Profiledata(token: widget.token,userId: widget.userId,)));
    }
    if(response.statusCode==401){
      print(responseString);
      pr.hide();
      Fluttertoast.showToast(
          msg: "Invalid Token",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.sp);
    }



   // print(responseString["url"]);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RegistrationPage()));
            }
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "e-KYC",
          style: TextStyle(
            color: Rmlightblue,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

      ),
      body: SingleChildScrollView(child:Container(
        height: MediaQuery.of(context).size.height,
        child:Column(
        children: <Widget>[

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
          Text(
            "Please Attach Your IC Image Here!!",
            style: TextStyle(
              color: Rmlightblue,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

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
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.height/3.5,
                child: _image==null?Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ):Image.file(
                  _image,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),

          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width/1.5,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),

            child: RaisedButton(
              onPressed: () async {
                setState(() {
                  _imgFromCamera();
                });

              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.all(0.0),
              color: Rmpick,
              splashColor: Rmpick,
              child: Ink(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        "Capture image & upload",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 35.w,
                        height: 35.h,
                        child: Icon(
                          Icons.camera,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50.h,

            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width/1.5,
            child: RaisedButton(
              onPressed: () async {
               setState(() {
                 _imgFromGallery();
               });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.all(0.0),
              color: Rmpick,
              splashColor: Rmpick,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                  alignment: Alignment.center,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        "Upload from Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 35.w,
                        height: 35.h,
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 50.h,),

          Container(
            height: 50.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            child: RaisedButton(
              onPressed: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                if(_image==null){
                  ToastUtil.show("Please select IC image");
                }else{

                  setState(() {

                    _asyncFileUpload(_image);

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
        ],
      ),))
    );
  }
}
