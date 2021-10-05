
import 'package:creditscore/Screen/Demo.dart';
import 'package:creditscore/Screen/SplashScreen.dart';
import 'package:creditscore/Screen/profile/Profile.dart';
import 'package:creditscore/providers/auth_provider.dart';
import 'package:creditscore/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Apiservice/Responce/ProfiledetailsResponce.dart';
import 'Common/Colors.dart';
import 'Common/Constants.dart';
import 'Data/shared_preference.dart';
import 'Screen/size_config.dart';
const debug = true;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug);
  runApp( MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AuthProvider()),
          ChangeNotifierProvider(create: (_)=>UserProvider())
        ],
        child:ScreenUtilInit(
        designSize: Size(360, 690),
    builder: () =>LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName,
                theme: ThemeData(
                  primarySwatch: createMaterialColor(Rmlightblue),
                  fontFamily: Constants.fontName,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: MyApp11());
          },
        );
      },
    )));
  }
}
