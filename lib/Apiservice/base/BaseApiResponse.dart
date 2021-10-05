
import 'package:dio/dio.dart';

enum Status { SUCCESS, FORM_DATA_ERROR, DIO_ERROR ,SUCCESSFORGOT,LOGIN_SUCCESS,REPAYMENT_SUCCESS,REPAYMENT_FAIELD,LOGIN_FAIELD,ERROR_CHANGE_PASSWORD}

class BaseApiResponse {

  Status status;
  Map data;
  String reponceData;
  DioError error;
  BaseApiResponse.onSuccess(this.data): status = Status.SUCCESS;
  BaseApiResponse.onSuccessForgot(this.reponceData): status = Status.SUCCESSFORGOT;
  BaseApiResponse.onChangeError(this.reponceData): status = Status.ERROR_CHANGE_PASSWORD;
  BaseApiResponse.onFormDataError(this.data): status = Status.FORM_DATA_ERROR;
  BaseApiResponse.onDioError(this.error): status = Status.DIO_ERROR;
  BaseApiResponse.onFailed(this.data): status = Status.LOGIN_FAIELD;
  BaseApiResponse.onSuccessLogin(this.data): status = Status.LOGIN_SUCCESS;
  BaseApiResponse.onSuccessRepayment(this.data): status = Status.REPAYMENT_SUCCESS;
  BaseApiResponse.onFailedRepayment(this.reponceData): status = Status.REPAYMENT_FAIELD;
  BaseApiResponse.onLoginFailed(this.reponceData): status = Status.LOGIN_FAIELD;
}

