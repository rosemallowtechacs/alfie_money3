import 'package:creditscore/providers/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/UserdetailsResponce.dart';
import 'package:creditscore/Common/AlertDialogeBox.dart';
import 'package:creditscore/Screen/Dashboard.dart';
import 'package:creditscore/Screen/Loan_contract.dart';
import 'package:creditscore/Screen/Notificationlist_view.dart';
import 'package:creditscore/Screen/repayment/Repayment.dart';
import 'package:creditscore/Screen/userprofile/Userprofile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/balance_card.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/title_text.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BankAccounts.dart';
import 'Dashboard2.dart';
import 'LoanDetails.dart';
import 'History.dart';
import 'Landingpage.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'bankDetails/BankDetails.dart';
import 'change_password/change_pass_screen.dart';
import 'register/Register.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> _launched;
  int _currentIndex1 = 0;
  int mobileNumber = 0;
  String emailId = "";
  String address1 = "";
  String cityName = "";
  String userId = "";
  String dob = "";
  String firstName = "";
  String lastName = "";
  String address = "";
  String token="";
  String profilePic="";
  Map<String, String> headersMap ;
  ProgressDialog pr;

  final List<Widget> _children = [
    Dashboard(),
    Repayment(screen: false,),
    Container(
        child:Center(child:Text("Notifications"))
    ),
    //NotificationScreen(),
  ];

  /*final List<Widget> _children = [
    Homescreen(),
    LoanDetails(),
    Repayment(screen: false,),
    Container(child: Center(child: Text("Notification"),),),
    //NotificationScreen(),
  ];*/



  @override
  void initState() {

    getUserdata();
    _getLocation();
    _loadProfileDataFromSF();
    //Timer.periodic(Duration(seconds: 2), (Timer t) => _loadProfileDataFromSF());
    super.initState();

  }


  void _loadProfileDataFromSF() async {
    token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString())??"";
    headersMap = {
      'Authorization' : token
    };
    Map<String, dynamic> map = await PreferenceManager.sharedInstance
        .getMap(Keys.PROFILE_MAP.toString());
    setState(() {
      firstName=map[ProfileKeys.FIRSTNAME_.toString()];
      address=map[ProfileKeys.ADDRESS1_.toString()];


    });

  }

  Future getUserdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = await PreferenceManager.sharedInstance.getString(
        Keys.USER_ID.toString());
    String token = await PreferenceManager.sharedInstance.getString(
        Keys.ACCESS_TOKEN.toString());
    print(token);

    var response = await http.get(Uri.parse(APIS.getuser + userId), headers: {
      "Authorization": token,
    },);

      if (response.statusCode == 200) {
        String data = response.body;
        final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
         print("strttttttttt");
          var decodedData = jsonDecode(data);
          Profiledetails registrationResponse = Profiledetails.fromJson(decodedData);
        Provider.of<UserProvider>(context, listen: false).setUser(registrationResponse);
          preferences.setString(Constants.firstName,decodedData["firstName"]);
          preferences.setString(Constants.lastName,decodedData["lastName"]);
          preferences.setString(Constants.icNumbe,decodedData["icNumber"]);
          preferences.setString(Constants.address1,decodedData["address1"]);
          preferences.setString(Constants.emailId,decodedData["email"]);
          preferences.setString(Constants.docSign,decodedData["docSign"]);
       setState(() {
        preferences.setString(Constants.dateTime,formatter.format(DateTime.parse(decodedData["createdOn"])));
         profilePic=registrationResponse.docPhoto;
       });

        String profilePic1= preferences.getString(Constants.dateTime);
          Map<String, dynamic> map = Map();
          map[ProfileKeys.FIRSTNAME_.toString()] = registrationResponse.firstName;
          map[ProfileKeys.LASTNAME_.toString()] = registrationResponse.lastName;
          map[ProfileKeys.ICNUM_.toString()] = registrationResponse.icNumber;
          map[ProfileKeys.ZIPCODE_.toString()] = registrationResponse.zipCode;
          map[ProfileKeys.MOBILE_.toString()] = registrationResponse.mobile;
          map[ProfileKeys.EMAIL_.toString()] = registrationResponse.email;
          map[ProfileKeys.DOB_.toString()] = registrationResponse.dob;
        map[ProfileKeys.CITY_.toString()] = registrationResponse.city;
          map[ProfileKeys.ADDRESS1_.toString()] = registrationResponse.address1;
          map[ProfileKeys.ADDRESS2_.toString()] = registrationResponse.address2;
          map[ProfileKeys.FACEBOOK_.toString()] = registrationResponse.facebookId;
        map[ProfileKeys.EMPLOYMENT_.toString()] = registrationResponse.employment;
        map[ProfileKeys.EDUCATION_.toString()] = registrationResponse.education;
        map[ProfileKeys.MARITALSTATUS_.toString()] = registrationResponse.maritalstatus;
        map[ProfileKeys.NUM_CHILD_.toString()] = registrationResponse.numofchild;
        map[ProfileKeys.GENDER_.toString()] = registrationResponse.gender;
        map[ProfileKeys.PROFILE_PIC.toString()] = registrationResponse.docPhoto;
        map[ProfileKeys.REG_DATETIME.toString()] = formatter.format(registrationResponse.createdOn);

        await PreferenceManager.sharedInstance
            .putMap(Keys.PROFILE_MAP.toString(), map);
        print("DDDDsafsf");
        print(profilePic1);
        print(data);

      }
    else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user data');
    }


  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex1 = index;
    });
  }


  _getLocation() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    if(first.addressLine==address){
      //point 1
      preferences.setInt(Constants.userLocation,1);
    }
    print("${first.featureName} : ${first.addressLine}");
  }
  /*_launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }*/
  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    Profiledetails user = Provider.of<UserProvider>(context).user;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: (){
          var dialog = CustomAlertDialog(
              title: "Exit",
              message: "Are you sure?, Do you want to exit an App",
              onPostivePressed: () {
                exit(0);
              },
              positiveBtnText: 'Yes',
              negativeBtnText: 'No');
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog);
        },
        child:Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Rmlightblue

          ),
        ),
          //title: Text("Alternate Credit Score", style: TextStyle(color: Colors.white),),
        elevation: 0,
          leading: Row(children: [
            IconButton(
              icon: new  Icon(Icons.menu,color: Colors.white,),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            new Image.asset(
              Constants.developerLogo,
              fit: BoxFit.contain,

            ),
          ],),
          backgroundColor: Colors.white,actions: [
        Center(child: Text(user.firstName??"",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.sp),textAlign: TextAlign.center,),),
        SizedBox(width: 10.w,),
        Center(
          child:  CircleAvatar(
              radius: 15,backgroundColor: Colors.white,
              child: CircleAvatar(
                  radius: 13,backgroundColor: Colors.grey,child:ClipOval(

                  child:GestureDetector(child:CachedNetworkImage(

              placeholder: (context, url) => Container(
                  height: 20.h,
                  width: 20.w,
                  child: Icon(Icons.person,color: Colors.white,)),
              errorWidget: (context, url, error) => Icon(Icons.person,color: Colors.white,),
              imageUrl: 'http://104.131.5.210:7400/api/users/doc/${user.docPhoto}?key=${Constants.documentType1}',
              httpHeaders: headersMap,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),onTap: (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:user.docPhoto ,keyvalue: Constants.documentType1,title:"Profile Picture")));
              });
            })) )
          ),
        ),
          SizedBox(width: 10.w,),
        ],),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.exit_to_app),
              backgroundColor: Colors.red,
              onPressed: (){
                setState(() {
                  var dialog = CustomAlertDialog(
                      title: "Logout",
                      message: "Are you sure, do you want to logout?",
                      onPostivePressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      positiveBtnText: 'Yes',
                      negativeBtnText: 'No');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog);
                 /* Navigator.push(
                      context, MaterialPageRoute(builder: (context) => LoginPage()));*/
                });
              }
          ),
      drawer:Drawer(
        child: Column(

          children: <Widget>[

            DrawerHeader(
              decoration: BoxDecoration(
                color: Rmlightblue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Rmyellow,
                      radius: 45,
                      child: ClipOval(child:GestureDetector(child:CachedNetworkImage(

                        /*placeholder: (context, url) => Container(
                     height: 20,
                     width: 20,
                     child: CircularProgressIndicator()),*/
                        placeholder: (context, url) => Container(
                            height: 20.h,
                            width: 20.w,
                            child: Icon(Icons.person,color: Colors.white,)),
                        errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
                        imageUrl: 'http://104.131.5.210:7400/api/users/doc/${profilePic}?key=${Constants.documentType1}',
                        httpHeaders: headersMap,
                        width: 150.w,
                        height: 150.h,
                        fit: BoxFit.cover,
                      ),onTap: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:profilePic ,keyvalue: Constants.documentType1,title:"Profile Picture")));
                        });
                      })),
                    ), //CircleAvatar
                  ),
                 Center(child: Text(user.firstName??"",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),)

                ],
              ),
            ),

            ListTile(
              title: Row(children: [Icon(Icons.home_outlined),SizedBox(width: 10.w,),Text('Home'),],),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.person_sharp),SizedBox(width: 10.w,),Text('Profile'),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UserProfile()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.account_balance),SizedBox(width: 10.w,),Text('Add Bank Details '),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => BankAccounts()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.payment),SizedBox(width: 10.w,),Text('Repayment '),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Repayment(screen: true,)));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.payments),SizedBox(width: 10.w,),Text('Loan Performance'),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Historyscreen()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.admin_panel_settings_rounded),SizedBox(width: 10.w,),Text('Change Password'),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.support_agent),SizedBox(width: 10.w,),Text('Support'),],),
              onTap: () {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {// Declare your variable outside the builder

                    return AlertDialog(
                      content: StatefulBuilder(  // You need this, notice the parameters below:
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                              height: MediaQuery.of(context).size.height/4.5,
                              child:Column(  // Then, the content of your dialog.
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10.h,),
                              Text("For user support and customer service, please email us at"),

                              GestureDetector(
                                  child: Text("hello@alfie.asia.", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                                  onTap: () {

                                    setState(() {

                                      _launched = _openUrl('mailto:${"hello@alfie.asia"}');

                                    });
                                  }
                              ),
                              SizedBox(height: 10.h,),
                              Center(child:Image.asset(
                                Constants.money3Logo,
                                scale: 20,

                              ),)

                            ],
                          ));
                        },
                      ),
                    );
                  },
                );

              },
            ),


            Spacer(),

            Container(
              height: 50.h,
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                onPressed: () {
                  setState(() {

                    var dialog = CustomAlertDialog(
                        title: "Logout",
                        message: "Are you sure, do you want to logout?",
                        onPostivePressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        positiveBtnText: 'Yes',
                        negativeBtnText: 'No');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);

                  });
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.all(0.0),

                color: Rmpick,
                splashColor: Rmpick,
                child: Ink(
                  decoration: BoxDecoration(
                      color:Rmlightblue,
                      // color: Color(0xff0066ff),
                       gradient: LinearGradient(
                                    colors: [
                                      Rmlightblue,
                                      Rmpick,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.w, minHeight: 50.h),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    SizedBox(width: 20.w,),
                    Center(child: new Icon(
                    Icons.exit_to_app,
                      color: Colors.white,
                    )),
                    ],)
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h,)
          ],
        ),
      ),

      body: _children[_currentIndex1], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,

        selectedItemColor: Rmlightblue,
        showUnselectedLabels: true,//
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 8,
        backgroundColor: Colors.white,// new
        currentIndex: _currentIndex1,
        // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),

            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.payments_outlined,),
              title: Text('Repayment')
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_sharp),
              title: Text('Notifications')
          )
        ],
      ),)
    );
  }
}