import 'package:flutter/material.dart';

class ApplyLoanList extends StatefulWidget {
  const ApplyLoanList({Key key}) : super(key: key);

  @override
  _ApplyedLoanState createState() => _ApplyedLoanState();
}

class _ApplyedLoanState extends State<ApplyLoanList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:SafeArea(child: Scaffold(body: SingleChildScrollView(child: Column(
        children: [

        ],
      ),),),)
    );
  }
}
