
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/title_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'AvailedLoanList.dart';
import 'AwaitingLoanapproval.dart';
import 'Loanapproed.dart';
import 'Loandeals.dart';
import 'register/Register.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key key}) : super(key: key);

  @override
  _Homescreen1State createState() => _Homescreen1State();
}

class _Homescreen1State extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentStep = 0;
  double loaneligibility;
  bool redmi=false;
  List<Step> steps = [
    Step(
      title: const Text(''),
      isActive: true,
      state: StepState.complete,
      content:Text(""),
    ),
    Step(
        isActive: false,
        state: StepState.complete,
        title: const Text(''),
        content: Text("")
    ),
    Step(
        state: StepState.complete,
        title: const Text(''),
        subtitle: const Text(""),
        content: Text("")
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaneligibility=4000;
  }
  Widget _getRadialGauge() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 2,

      axes:<RadialAxis>[
        RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
            minimum: 0, maximum: 99,
            ranges: <GaugeRange>[GaugeRange(startValue: 5, endValue: 20,
              color: Color(0xFFFE2A25),

              labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:  20),
              startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
            ),GaugeRange(startValue: 20, endValue: 40,
              color:Colors.orange,
              labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
              startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
            ),
              GaugeRange(startValue: 40, endValue: 60,
                color:Color(0xFFFFBA00),
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
              GaugeRange(startValue: 60, endValue: 80,
                color:Colors.lightBlue,
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
              GaugeRange(startValue: 80, endValue: 96,
                color:Color(0xFF00AB47),
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),

            ],
            pointers: <GaugePointer>[NeedlePointer(value: 60
            )],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                    child: Center(child:Column(

                      children: [
                        Text('6/10',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),
                        Text('Experian Vantage Score',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.bold,color: Colors.black))

                      ],mainAxisAlignment: MainAxisAlignment.center,) ),),
                  angle: 90,
                  positionFactor: 0.5)
            ]

        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Size size = MediaQuery.of(context).size;
    if (MediaQuery.of(context).size.height > 765) {
      redmi = true;

    } else {
      redmi = false;
    }
    return Container(
        color: Rmlightblue,
        child: SafeArea(child:SafeArea(
            child: Scaffold(
              key: _scaffoldKey,

              backgroundColor: Colors.white,

              body:SingleChildScrollView(
                  child:Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Image.asset(
                              Constants.developerLogo,

                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                       /* Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.contain
                              )
                          ),),*/

                      /*  SizedBox(height: 5),
                        GestureDetector(child:   Container( padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),child:TitleText(text: "Repayment amount due: "+"\$1800",color: Colors.green,fontSize: 15,),),),
                        Container( padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),child:Row(children: [TitleText(text: "Total loan approved:",color: Colors.green,fontSize: 12,), SizedBox(width: 5),TitleText(text: "\$18000",color: Colors.grey,fontSize: 13,)],)),
                        Container( padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),child:Row(children: [TitleText(text: "Overdraft limit:",color: Colors.green,fontSize: 12,), SizedBox(width: 5),TitleText(text: "\$18000",color: Colors.grey,fontSize: 13,)],)),
                        SizedBox(height: 5),

                         Container(
                            height: 50,
                            child: Stack(children: [

                              Container(
                                height: MediaQuery.of(context).size.height/8,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Center(child: Container(width: MediaQuery.of(context).size.width,

                                    height: 10, decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Rmpick,
                                            Rmlightblue,


                                          ],
                                        ))),),
                              ) ,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 80,),

                                  Center(
                                    child: NeumorphicRadio(
                                      groupValue: "Google",
                                      padding: EdgeInsets.all(1),

                                      style: NeumorphicRadioStyle(
                                          shape: NeumorphicShape.concave,
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                                          unselectedColor: Colors.green
                                      ),
                                      child:Icon(
                                          Icons.done,
                                          size: 20,
                                          color: Colors.white
                                      ),
                                      // child:Container(height:20,width: 20,child:Center(child: Text("1"))),
                                      onChanged: (value) {
                                      },
                                    ),),
                                  SizedBox(width: 80,),

                                  Center(
                                    child: NeumorphicRadio(
                                      groupValue: "Google",
                                      padding: EdgeInsets.all(1),

                                      style: NeumorphicRadioStyle(
                                          shape: NeumorphicShape.concave,
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                                          unselectedColor: Colors.green
                                      ),
                                      child:Icon(
                                          Icons.done,
                                          size: 20,
                                          color: Colors.white
                                      ),
                                      onChanged: (value) {
                                      },
                                    ),),
                                  SizedBox(width: 80,),
                                  Center(
                                    child: NeumorphicRadio(
                                      groupValue: "Google",
                                      padding: EdgeInsets.all(1),

                                      style: NeumorphicRadioStyle(
                                          shape: NeumorphicShape.concave,
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                                          unselectedColor: Colors.white
                                      ),
                                      child:Icon(
                                          Icons.done,
                                          size: 20,
                                          color: Colors.grey
                                      ),
                                      onChanged: (value) {
                                      },
                                    ),),
                                ],)
                            ],)
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(

                              title: Text("Tenure : 3 months",style: TextStyle(color: Colors.black,fontSize: 10)),

                              trailing:Text("Successful payments: 2 months",style: TextStyle(color: Colors.black,fontSize: 10)) ,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        Container( padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),child:TitleText(text: "My Credit Score"),),

                        Container(
                          height: redmi?  MediaQuery.of(context).size.height/2.8:MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width,
                          child:Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.purple, Colors.blue]),
                                borderRadius: BorderRadius.circular(12)),
                            child:Container(child: Column(children: [
                              //Flexible(child: _getRadialGauge(),),
                              Container(
                                  height: MediaQuery.of(context).size.height/4,
                                  child:  _getRadialGauge()),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Row(children: [
                                    Column(children: [

                                          Text("Your starting Score", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),

                                      SizedBox(height: 5,),

                                          Text("600", style: TextStyle(color: Colors.white),),
                                    ],),
                                    Spacer(),
                                    Column(children: [

                                          Text("Change to date", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),

                                          Text("+20 points", style: TextStyle(color: Colors.white),),
                                    ],),
                                  ],) ),


                            ],),),
                          ) ,),
                        SizedBox(height: 20),
                        Center(child:
                            Text("Loan Eligibility : \$4000", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)
                        ),
*/
                        Container( padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),child:TitleText(text: "My Credit Score"),),

                        Container(
                          height: redmi?  MediaQuery.of(context).size.height/2.8:MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width,
                          child:Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                                /*gradient: LinearGradient(
                                  colors: [
                                    Rmlightblue,
                                    Rmpick,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),*/
                              color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child:Container(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              //Flexible(child: _getRadialGauge(),),
                                Spacer(),
                              Container(
                                  height: MediaQuery.of(context).size.height/3.2,
                                  child:  _getRadialGauge()),
                             /* Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Row(children: [
                                    Column(children: [

                                      Text("Your starting Score", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),

                                      SizedBox(height: 5,),

                                      Text("600", style: TextStyle(color: Colors.white),),
                                    ],),
                                    Spacer(),
                                    Column(children: [

                                      Text("Change to date", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),

                                      Text("+20 points", style: TextStyle(color: Colors.white),),
                                    ],),
                                  ],) ),*/


                            ],),),
                          ) ,),
                        SizedBox(height: 10),
                        Center(child:
                        Text("Loan Eligibility : RM 5000", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10),



                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {

                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Loanprocess(loanmax:loaneligibility)));

                              });
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            padding: EdgeInsets.all(0.0),
                            color: Rmpick,
                            splashColor: Rmpick,
                            child: Ink(
                              decoration: BoxDecoration(

                                // color: Color(0xff0066ff),
                                  color:Rmlightblue,
                                  /*gradient: LinearGradient(
                                    colors: [
                                      Rmlightblue,
                                      Rmpick,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),*/
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Apply for Loan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {

                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => AvailedLoanList()));

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
                                 /* gradient: LinearGradient(
                                    colors: [
                                      Rmlightblue,
                                      Rmpick,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),*/
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Check Availed Loans",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                       /* Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {

                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => LoanApproval()));

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
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  Constants.loanstatus2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {

                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => LoanApproedList()));

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
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  Constants.loanstatus3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                       /* Container(
                          height: redmi? 70:65,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          width: MediaQuery.of(context).size.width,

                          child: NeumorphicButton(
                              padding: const EdgeInsets.all(18.0),
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Loanprocess(loanmax:loaneligibility)));
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                color: Rmlightblue,
                                boxShape:
                                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                              ),
                              child: Center(child:Text('Apply for Loan',style: TextStyle(color: Colors.white),) ,)
                          ),
                        ),*/


                        /*Container(
                          height: redmi? 70:65,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          width: MediaQuery.of(context).size.width,

                          child: NeumorphicButton(
                              padding: const EdgeInsets.all(18.0),
                              onPressed: () {

                              },

                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                color: Rmlightblue,
                                boxShape:
                                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                              ),
                              child: Center(child:Text('Increase Loan Eligibility',style: TextStyle(color: Colors.white)) ,)
                          ),
                        ),*/

                        SizedBox(height: 20),
                      ],
                    ),)
              ),)
        )));
  }
}

