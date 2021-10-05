
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';

class ChangePasswordView extends BaseView {
  void saveChangesBtnDidTapped() {}
  void changePasswordDidSucceed(String successMsg) {}
  void changePasswordDidFailed(String failedMsg) {}
}

class ChangePasswordPresenter {
  void changePassword(Map data) {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class ChangePasswordPresenterImpl extends BasePresenter<ChangePasswordView>
    implements ChangePasswordPresenter {

  ChangePasswordPresenterImpl(ChangePasswordView view) : super(view);

  @override
  void changePassword(Map data) async{
    mView.onNetworkCallStarted("Loading...");

    BaseApiResponse response = await DioUtils.changePassword(APIS.changePassword,formData: data);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESSFORGOT:
        mView.changePasswordDidSucceed(response.reponceData);
        // mView.registrationDidSucceed(response.data);
        /* print(response.data);
        ForgotPasswordResponce forgotResponse =
        ForgotPasswordResponce.fromJson(response.data);
        if (forgotResponse.resultCode == 0) {
          mView.registrationDidSucceed(forgotResponse.result);
        }*/
        break;
      case Status.ERROR_CHANGE_PASSWORD:
        mView.changePasswordDidFailed(response.reponceData);
        break;
      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }

  /*@override
  void changePassword(Map data) async {
    mView.onNetworkCallStarted("Please wait...");

    BaseApiResponse response = await DioUtils.reqeust(APIs.CHANGE_PASSWORD,
        method: RequestMethod.POST, formData: data);
    mView.onNetworkCallEnded();

    switch (response.status) {
      case Status.SUCCESS:
        PostDataResponse result = PostDataResponse.fromJson(response.data);
        if (result.status == 200) {
          mView.changePasswordDidSucceed(result.data.stringData);
        }
        break;

      case Status.FORM_DATA_ERROR:
        if (response.data.containsKey("data")) {
          final Map<String, dynamic> rootObj = response.data["data"];
          if (rootObj.containsKey("json_object")) {
            final errors = rootObj["json_object"];
            if (errors is Map) {
              final error1st = errors.values.toList()[0];
              mView.changePasswordDidFailed(error1st);
            }
          }
        }
        break;

      case Status.DIO_ERROR:
        super.handleError(response.error);
        break;
    }
  }*/
}
