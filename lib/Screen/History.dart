import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Screen/select_account_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:creditscore/Screen/UserLoanList.dart';
import 'package:creditscore/Screen/RejectedLoanList.dart';
import 'package:creditscore/Screen/repayment/Repayment.dart';
import 'package:creditscore/Screen/ActiveLoans.dart';
import 'package:creditscore/Apiservice/Responce/LoanDetails.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
class Historyscreen extends StatefulWidget {
  const Historyscreen({Key key}) : super(key: key);

  @override
  _HistoryscreenState createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {

  List<Color> colors = [Colors.indigo, Colors.pink, Colors.pink];
  List<Color> colors2 = [Rmyellow, Rmblue, Colors.pink];
  List<String> score=["20","50","40","45","60"];
  List<String> date=["07 july 2021","05 july 2021","04 july 2021","03 july 2021","02 july 2021"];

  Future<LoanDetails> loandetails;
  final value = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {

    loandetails = getDetails();

    super.initState();
  }

  Future<LoanDetails> getDetails() async {
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());
    String userId = await PreferenceManager.sharedInstance
        .getString(Keys.USER_ID.toString());
    var response = await http.get(Uri.parse(APIS.LaondetalsApi+userId),headers: {
      'Authorization':token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);

        return LoanDetails.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Failed to load ');
    }


  }
  Widget activeloan(){
    return  Center(child: FutureBuilder<LoanDetails>(
      future: loandetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.activeLoans.isEmpty?Container(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Image.asset(
                Constants.activeLoans_im,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(height: 10,),
              Text("No Active Loans")
            ],),):Container(

            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            height:MediaQuery.of(context).size.height,child:ListView.builder(
              itemCount: snapshot.data.activeLoans.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height/2.5,


                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Rmlightblue, //                   <--- border color
                          width: 1.0,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                      ),
                      margin: EdgeInsets.symmetric(horizontal: 18,vertical: 10),


                      child: Stack(children: [ Container(child:

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),

                          ListTile(
                            title: Text("Loan Id  "+snapshot.data.activeLoans[index].id,style: TextStyle(fontSize: 12)),
                            subtitle:FittedBox(child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Loan Amount :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].loanAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Loan Tenure :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].tenure}"+" "+"months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Product Type :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].productType}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Late Payments:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.anyLatePayments}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],),

                                SizedBox(width: 50,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Emi Start Date :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].emiStartDate}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("ACS Score :",style: TextStyle(fontSize: 14),),
                                    Text("7/10",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Repayment Status:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].loanRepaymentDetails??" "}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Defaults:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.activeLoans[index].loanRepaymentDetails??" "}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],)
                              ],),fit: BoxFit.contain,),
                           ),



                          SizedBox(height: 10,),

                          Spacer(),
                          GestureDetector(child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,

                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Rmlightblue,
                                    Rmpick,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Pay",style: TextStyle(color: Colors.white,fontSize: 12),)
                              ],),),onTap: (){

                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Repayment(screen: true,)));

                            /* Navigator.push(
                             context, MaterialPageRoute(builder: (context) => SelectAccountPage()));*/

                          },),
                        ],
                      ),),
                        /*Align(child:IconButton(icon: Icon(Icons.info,color: Colors.black,), onPressed: (){

                  }) ,alignment: Alignment.topRight,)*/
                      ],),
                    ),



                  ],
                );
              }),);
        } else if (snapshot.hasError) {
          return Container(child: Center(child: Text("No Data found !!"),),);
        }
        return const CircularProgressIndicator();
      },
    ),);
  }
  Widget numberOfLoans(){
    return  ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height/4,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xff0099cc), Color(0xfff2ccff)])),
                child:  Stack(children: [


          Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("Application No :ACS09090k"),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text("Amount                :"+"\$10000"),
                            Text("Date and time     : 08-07-2021"),
                          ],),
                        leading: CircleAvatar(

                          backgroundColor: Colors.blue,
                          child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                        ),),

                     SizedBox(height: 30,)

                    ],
                  ),
                    Align(child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width/4.5,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.all(10),
                      child:Center(child:Text('View',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                      ),),alignment: Alignment.bottomRight,),
                    Align(child:Container(child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Container(
          width: 10.0,
          height: 10.0,
          decoration: new BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          //  border: Border.all(width: 5.0, color: Colors.white),
          ),
          ),Text(
          "In Progress",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.green,
          fontSize: 12),
          ),],),padding: EdgeInsets.all(10),),alignment: Alignment.topRight,)
                  ],
                ),
              ),


            ],
          );
        });
  }

  Widget history(){
    return SingleChildScrollView(
      child: Container( /*Column(children: [
       GestureDetector(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.access_time),
              trailing: Icon(Icons.arrow_right),
              title: Text("Number of loans taken",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),onTap: (){
         setState(() {

           Navigator.push(
               context, MaterialPageRoute(builder: (context) => UserLoanList()));
         });
       },),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.payments_outlined),

              subtitle: Text("Yes"),
              title: Text("Any late payments",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.disabled_by_default),

              subtitle: Text("Yes"),
              title: Text("Any defaults",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),
       GestureDetector(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.payments),
              trailing: Icon(Icons.arrow_right),
              title: Text("Number of rejected loans",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),onTap: (){
         setState(() {

           Navigator.push(
               context, MaterialPageRoute(builder: (context) => RejectedLoanList()));
         });
       },),
      ],)*/),
    );
  }
  Widget rejectedloan(){
    return Center(child: FutureBuilder<LoanDetails>(
      future: loandetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.rejectedLoans.isEmpty?Container(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Image.asset(
                Constants.activeLoans_im,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(height: 10,),
              Text("No Rejected Loans")
            ],),):Container(

            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            height:MediaQuery.of(context).size.height,child:ListView.builder(
              itemCount: snapshot.data.rejectedLoans.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height/2.5,


                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Rmlightblue, //                   <--- border color
                          width: 1.0,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                      ),
                      margin: EdgeInsets.symmetric(horizontal: 18,vertical: 10),


                      child: Stack(children: [ Container(child:

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),

                          ListTile(
                            title: Text("Loan Id  "+snapshot.data.rejectedLoans[index].id,style: TextStyle(fontSize: 12)),
                            subtitle:FittedBox(child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Loan Amount :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.rejectedLoans[index].loanAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Loan Tenure :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.rejectedLoans[index].tenure}"+" "+"months",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Product Type :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.rejectedLoans[index].productType}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Late Payments:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.anyLatePayments}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],),

                                SizedBox(width: 50,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Loan Date :",style: TextStyle(fontSize: 14),),
                                    snapshot.data.rejectedLoans[index].loanApproveOrRejectedDate==null?Text(""):Text("${DateFormat('dd-MM-yyyy').format(snapshot.data.rejectedLoans[index].loanApproveOrRejectedDate)}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Profit rate(%) :",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.rejectedLoans[index].interestRate}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("EMI amount:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.rejectedLoans[index].emiAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                                    Text("Defaults:",style: TextStyle(fontSize: 14),),
                                    Text("${snapshot.data.anyDefaults}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),


                                  ],)
                              ],),fit: BoxFit.contain,),
                            /* leading: CircleAvatar(

                            backgroundColor: Colors.blue,
                            child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                          ),*/),
                          //trailing: Text("31-07-2021")),


                          SizedBox(height: 10,),

                          Spacer(),

                        ],
                      ),),
                        /*Align(child:IconButton(icon: Icon(Icons.info,color: Colors.black,), onPressed: (){

                  }) ,alignment: Alignment.topRight,)*/
                      ],),
                    ),



                  ],
                );
              }),);
        } else if (snapshot.hasError) {
          return Container(child: Center(child: Text("No Data found !!"),),);
        }
        return const CircularProgressIndicator();
      },
    ),);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
         backgroundColor: Rmblue,
         flexibleSpace: Container(
         decoration: BoxDecoration(
             gradient: LinearGradient(
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
                 colors: [Colors.purple, Colors.blue]),)),

          automaticallyImplyLeading: false,


          bottom: TabBar(
            indicatorColor: Rmyellow,
           labelColor: Rmyellow,
           labelStyle: TextStyle(fontSize: 10),
           unselectedLabelColor: Colors.white,
            tabs: [

              Tab(icon: Icon(Icons.access_time), text: "Active loans",),
              //Tab(icon: Icon(Icons.access_time), text: "Rejected loans",),


            ],
          ),
          title: Text("Loan Performance "),
        ),
        body: TabBarView(
          children: [
            activeloan(),
            //rejectedloan()
          ],
        ),
      ),
    );
  }
}
