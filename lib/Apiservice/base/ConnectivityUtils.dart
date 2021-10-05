import 'package:data_connection_checker/data_connection_checker.dart';

class ConnectivityUtils {
  static ConnectivityUtils sharedInstance = ConnectivityUtils();

  Future<bool> isConnectionAvailable() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // }
    //return false;
    return DataConnectionChecker().hasConnection;
  }
}

class NoConnectivityException implements Exception {
  String get errorMessage => "No Internet Connection";
}
