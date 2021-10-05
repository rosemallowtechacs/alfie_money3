/*
import 'dart:math';

import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'Home.dart';
import 'Loan_contract.dart';

class Monthlystatement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(accentColor: Rmblue,baseColor: Colors.white,depth: 8,
        intensity: 0.65,),

      themeMode: ThemeMode.light,
      child: Material(
        child: NeumorphicBackground(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),child:Monthlystatementdetails()),
        ),
      ),
    );
  }
}
class Monthlystatementdetails extends StatefulWidget {
  const Monthlystatementdetails({Key key}) : super(key: key);

  @override
  _LoandetailsState createState() => _LoandetailsState();
}

class _LoandetailsState extends State<Monthlystatementdetails> {
  double _lowerValue = 1000;
  double _months=3;
  double _interestRate=10;
  double _upperValue = 180;
  String _emiResult="";
  String _persentage="";

  final TextEditingController _principalAmount = TextEditingController(text: "0");
  final TextEditingController _interestRate1 = TextEditingController(text: "0");
  final TextEditingController _tenure = TextEditingController(text: "0");
  List<int> date_ =[08,07,06,05,04,03,02,01,30,29];
  List<bool> amountdetails =[true,false,true,false,false,true,true,false,true,true];
  List<String> month =["July","July","July","July","July","July","July","July","June","June"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Widget pendingloan(){
    return  ListView.builder(
        itemCount: date_.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
            child: Container(
              height: 105,
              margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(
          1),
          decoration: new BoxDecoration(
              color: Color(0xfff2f2f2),
          borderRadius: new BorderRadius.all(
          Radius.circular(20.0))),
              child: Stack(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        clipBehavior: Clip.hardEdge,
                        color: Rmlightblue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              15.0),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Text(
                                  "${date_[index]}" + 'th',
                                  style: TextStyle(
                                      color:
                                      Colors.white,
                                      fontFamily:
                                      'alata',
                                      fontSize: 25),
                                ),
                                Text(
                                  month[index],
                                  style: TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 18,
                                  ),)
                              ],
                            ))),Text("xxxxxxx"),
                    Spacer(),
                    Align(child: IconButton(icon:Icon(Icons.drag_indicator_sharp), onPressed: (){

                    }),alignment: Alignment.topRight,)
                  ],) ,
               Align(child: Text("${amountdetails[index]?"+":"-"}"+"\$10000",style: TextStyle(color: amountdetails[index]?Colors.green:Colors.red),),alignment: Alignment.center,),
              ],),



            ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SafeArea(child:Scaffold(body:

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child:Row(children: [
                IconButton(icon:NeumorphicIcon(
                  Icons.arrow_back_ios_outlined,
                  style: NeumorphicStyle(color: Rmlightblue,shape: NeumorphicShape.concave, boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),),
                  size: 30,

                ) ,onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },),

                FadeAnimation(1.6,
                    Text("Bank Statement", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
                ),
              ],)),

      ],)*/
/*Column(
        children: [
          SizedBox(height: 10,),
          Align(
              alignment: Alignment.topLeft,
              child:Row(children: [
                IconButton(icon:NeumorphicIcon(
                  Icons.arrow_back_ios_outlined,
                  style: NeumorphicStyle(color: Rmlightblue,shape: NeumorphicShape.concave, boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),),
                  size: 30,

                ) ,onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },),

                FadeAnimation(1.6,
                    Text("My Transactions", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
                ),
              ],)),

          Container(
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width,
            child:Neumorphic(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),

              ),
              child: Center(child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FadeAnimation(1.6,
                      Text("Available Balance on your A/C", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: 10,),
                  FadeAnimation(1.6,
                      Text("\$34500", style: TextStyle(color: Colors.grey),)
                  ),
                ],
              ),),
            ) ,),
          SizedBox(height: 10,),

          pendingloan(),

        ],
      )*//*
,),)
    );
  }
}
*/
