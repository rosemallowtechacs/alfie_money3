
import 'package:creditscore/Apiservice/Responce/LoanDetails.dart';
import 'package:creditscore/Apiservice/Responce/LoginModel.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/providers/auth_provider.dart' as pro;
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  Profiledetails _user = Profiledetails();
  LoanDetails loanDetails = LoanDetails();
  LoginModel _login = LoginModel();
  bool loading = false;

  Profiledetails get user => _user;

  void setUser (Profiledetails user){
    _user = user;
    notifyListeners();
  }
  void setLogin (LoginModel user){
    _login = user;
    notifyListeners();
  }




 /* getPostData(context) async {
    loading = true;
    loanDetails = await getloandetils_get(context);
    loading = false;

    notifyListeners();
  }*/


}