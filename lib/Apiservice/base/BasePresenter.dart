
import 'package:dio/dio.dart';

import 'BaseView.dart';
import 'ConnectivityUtils.dart';

abstract class BasePresenter<V extends BaseView> {
  V mView;

  BasePresenter(V mView) {
    this.mView = mView;
  }

  void handleError(DioError e) {
    print("Error Type: ${e.type} Error: ${e.error}");
    if (e.type == DioErrorType.DEFAULT && e.error == NoConnectivityException) {
      if (mView != null) mView.onNetworkUnavailable();
    } else if (e.type == DioErrorType.RESPONSE) {
      Response _response = e.response;
      if (_response != null) {
        int _httpCode = _response.statusCode;
        print(_httpCode);

        switch (_httpCode) {
          case 400: // Phone verification required

            break;

          case 401:

            break;

          case 403: // Email verification required

            break;

          case 404:
            if (mView != null) mView.onServerError();
            break;

          case 500:
            if (mView != null) mView.onServerError();
            break;

          case 417:
            print(_response);
            if (mView != null) {
              mView.onExpectationFailed();
            }
            break;
        }
      }
    } else if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      if (mView != null) mView.onTimeOutError();
    }
  }
}
