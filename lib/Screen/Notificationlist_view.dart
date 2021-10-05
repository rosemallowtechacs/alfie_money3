import 'package:creditscore/Common/Colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _HistoryscreenState createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<NotificationScreen> {

  List<Color> colors = [Colors.indigo, Colors.pink, Colors.pink];
  List<Color> colors2 = [Rmyellow, Rmblue, Colors.pink];
  List<String> score=["20","50","40","45","60"];
  List<String> date=["07 july 2021","05 july 2021","04 july 2021","03 july 2021","02 july 2021"];
  final titles = ["New Record", "New Record", "New Record"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];



  Widget notificationview(){
    return  Stack(

      children: [
      ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    title: Text(titles[index]),
                    subtitle: Text("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"),
                    leading: CircleAvatar(

                      backgroundColor: Colors.blue,
                      child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                    ),
                    trailing: Text("05:00 am")));
          }),
      Align(child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(

            image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain
            )
        ),),alignment: Alignment.bottomCenter,)
    ],);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Rmblue,


          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Rmlightblue,
                  Rmpick,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            /*decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
            colors: [Colors.cyan, Color(0xfff2ccff)]),)*/),
           automaticallyImplyLeading: false,
         

          bottom: TabBar(
            indicatorColor: Rmyellow,
            labelColor: Rmyellow,
            labelStyle: TextStyle(fontSize: 10),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.restore_sharp), text: "Recent",),
              Tab(icon: Icon(Icons.library_books_outlined), text: "All",),
            ],
          ),
          title: Text("Notifications"),
        ),
        body: TabBarView(
          children: [
            notificationview(),
            notificationview()
          ],
        ),
      ),
    );
  }
}
