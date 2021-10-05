import 'dart:convert';
import 'dart:io';

import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ViewBankResponce.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/AddBankDetails/AddBankDetails.dart';
import 'package:creditscore/Screen/Home.dart';
import 'package:creditscore/Screen/bankDetails/BankDetails.dart';
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

class BankAccounts extends StatefulWidget {
  const BankAccounts({Key key}) : super(key: key);

  @override
  _BankAccountsState createState() => _BankAccountsState();
}

class _BankAccountsState extends State<BankAccounts> {

  File _image;
  ProgressDialog pr;
  bool progress=true;
  List list = [];
  Future<ViewBankResponce> BankList;

  @override
  void initState() {

    BankList = getDetails();


    super.initState();
  }
  _asyncFileUpload( File file) async{
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
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
    var postUri = Uri.parse(APIS.fileupload+"${userId}");


    print(postUri);
    print(token);
    var request = http.MultipartRequest("POST",postUri);
    //add text fields
    Map<String, String> headers = {
      "Authorization":token,
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
          context, MaterialPageRoute(builder: (context) => BankAccounts()));
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
          fontSize: 16.0);
    }

  }
  Future<ViewBankResponce> getDetails() async {
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response = await http.get(Uri.parse(APIS.ViewBankDetails),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);
        var responseJSON = json.decode(response.body);
        progress=false;
        list = responseJSON["bankDetails"];


        var decodedData = jsonDecode(data);
        ViewBankResponce registrationResponse = ViewBankResponce.fromJson(decodedData);

        return ViewBankResponce.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to load ');
    }
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
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home())),

          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Bank Accounts",
            style: TextStyle(
              color: Rmlightblue,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),

        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child:Stack(
            children: <Widget>[
              Container(child:
              Center(child: FutureBuilder<ViewBankResponce>(
                future: BankList,
                builder: (context, snapshot) {
                 if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      alignment: Alignment.topCenter,
                      height:MediaQuery.of(context).size.height/1.5,child:ListView.builder(

                      itemCount: snapshot.data.bankDetails.length,
                      itemBuilder: (context, index) {
                        return   Padding(padding: EdgeInsets.all(5),
                            child: Card(child:Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ListTile(
                                      leading: Icon(Icons.account_balance),
                                      title: Text(snapshot.data.bankDetails[index].bankName,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text("Name:"+snapshot.data.bankDetails[index].payee,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                        Text("Ac.no. "+snapshot.data.bankDetails[index].accountNumber,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
                                      ],),
                                    ),
                                  ],)

                            )));
                      },
                    ),);
                  } else if (snapshot.hasError) {
                    return Container(child: Center(child: Text("No Data found !!"),),);
                  }
                  return  Container(
                      height: 150,
                      child:Center(child:CircularProgressIndicator()));
                },
              ),),),



             Align(
               alignment: Alignment.bottomCenter,
               child:  Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: RaisedButton(
                  onPressed: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AddBankDetails()));
                  },
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
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
                        //borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: 10.0),

                      alignment: Alignment.center,
                      child:Text("Add Bank Details",style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
              ),),
            ],
          ),)
    )));
  }
}
