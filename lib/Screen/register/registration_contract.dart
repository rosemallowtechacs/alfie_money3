
import 'dart:convert';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/UserVerification.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart' as api;
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/RegisterResponce.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class RegistrationView extends BaseView {
  void submitBtnDidTapped() {}

  void registrationDidSucceed() {}
  void termsandconditionDidSucceed(String terms) {}

  void registrationDidFailed(String invalidFields) {}

}

class RegistrationPresenter {
  void doRegistration(Map registrationData) {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class RegistrationPresenterImpl extends BasePresenter<RegistrationView>
    implements RegistrationPresenter {
   RegistrationPresenterImpl(RegistrationView view) : super(view);


  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRegistration(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);
    BaseApiResponse response = await DioUtils.reqeust(APIS.register,
        method: RequestMethod.POST, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESS:
        UserVerification registrationResponse =
        UserVerification.fromJson(response.data);
        if (registrationResponse.status == true) {
          mView.registrationDidFailed(registrationResponse.result);
        } else {
          mView.registrationDidSucceed();
        }
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }

  @override
  void getTerms() async {
    String terms = await PreferenceManager.sharedInstance
        .getString(Keys.TC.toString());
    print(terms);
    if (terms.isEmpty) {
      var response = await http.get(Uri.parse(APIS.terms),);
      if (response.statusCode == 200) {
        print('ramesh' + response.body);
        var responseJSON = json.decode(response.body);
        terms = responseJSON;
        print(responseJSON);
        await PreferenceManager.sharedInstance.putString(
            Keys.TC.toString(), responseJSON);
        mView.termsandconditionDidSucceed(terms);
      }
      else {
        throw Exception('Failed to load post');
      }
    }
  }

  @override
  void Verification(BuildContext context,String moblileNumber,String code) async {
    await PreferenceManager.sharedInstance.putInt(Keys.MOBILE_NUM.toString(), int.parse(moblileNumber));
    await PreferenceManager.sharedInstance.putString(Keys.COUNTRY_CODE.toString(), code);
    print("Ramesh dsfa"+"  "+"${await PreferenceManager.sharedInstance.getInt(Keys.MOBILE_NUM.toString())}");

    mView.onNetworkCallStarted("Loading...");
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(context,authResult);

    };
    PhoneVerificationFailed verificationFailed=(FirebaseException){
      //showErrorDialog(context, FirebaseException.message);
      final CupertinoAlertDialog alert = CupertinoAlertDialog(
        title:  Text(Constants.appName),
        content: Text('\n${Constants.errorMsg}'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child:  Text(Constants.messageData),
            onPressed: () {
              Navigator.of(context).pop();
              Verification(context,moblileNumber,code);
            },
          )
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      mView.onNetworkCallEnded();


        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OtpScreen(mobilenumber:moblileNumber ,verificationid: verId,)));

    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: code+moblileNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
  signIn(context,AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Kycform()));
  }
}