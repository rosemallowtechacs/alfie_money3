
import 'package:dio/dio.dart';

import 'base/BaseView.dart';
import 'base/ConnectivityUtils.dart';

abstract class DioErrorHandler {
  void onSuccess(Response response);

  void onInvalidFormData(Map<String, String> errorMap) {}

  void handleError<V extends BaseView>(V mView, DioError e) {
    if (e.type == DioErrorType.DEFAULT && e.error == NoConnectivityException) {
      if (mView != null) mView.onNetworkUnavailable();
    } else if (e.type == DioErrorType.RESPONSE) {
      Response _response = e.response;
      if (_response != null) {
        int _httpCode = _response.statusCode;

        switch (_httpCode) {


          case 404:
            if (mView != null) mView.onServerError();
            break;

          case 422:
            onInvalidFormData(Map());
            break;

          case 500:
            if (mView != null) mView.onServerError();
            break;
        }
      }
    } else if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      if (mView != null) mView.onTimeOutError();
    }
  }
}
