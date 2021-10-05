
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/LoginModel.dart';
import 'package:creditscore/Apiservice/Responce/RepaymentResponce.dart';
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
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class RepaymentView extends BaseView {
  void submitBtnDidTapped() {}

  void repaymentDidSucceed(String amount) {}

  void repaymentDidFailed(String invalidFields) {}

}

class RepaymentPresenter {
  void doRepayment(Map registrationData) {}

}

/////////////////////////////////////////////////////////////////////////////////////////////
class RepaymentPresenterImpl extends BasePresenter<RepaymentView>
    implements RepaymentPresenter {
   RepaymentPresenterImpl(RepaymentView view) : super(view);
  ProgressDialog pr;

  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doRepayment(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData);

    BaseApiResponse response = await DioUtils.repayment(APIS.repayment, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {

      case Status.REPAYMENT_FAIELD:
        mView.repaymentDidFailed(response.reponceData);
        break;
      case Status.REPAYMENT_SUCCESS:
        RepaymentPage Repament_Response = RepaymentPage.fromJson(response.data);


        mView.repaymentDidSucceed("${Repament_Response.emiAmount}");
        break;
      case Status.DIO_ERROR:
        mView.repaymentDidFailed("Invalid mobile or password");

        super.handleError(response.error);
        break;
    }
  }
   @override
   void doFileUpload() async {
     String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
     String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
     String file=await PreferenceManager.sharedInstance.getString(Keys.SIGN1.toString());

     var response = await DioUtils.fileUpload(userId,token,APIS.fileupload+userId,File(file),Constants.documentType);
     print(response);

   }
}