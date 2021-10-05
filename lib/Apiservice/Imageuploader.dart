
import 'package:dio/dio.dart';

import 'Responce/ProfiledetailsResponce.dart';

class UserApiProvider{
  final String _endpoint = "https://randomuser.me/api/";
  final Dio _dio = Dio();

  Future<Profiledetails> getUser() async {
    try {
      Response response = await _dio.get(_endpoint);
      return Profiledetails.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return error;
    }
  }
}