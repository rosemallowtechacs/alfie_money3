import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Model/receiver_model.dart';
import 'package:flutter/material.dart';
import 'send_money_page.dart';


class SelectAccountPage extends StatefulWidget {
  @override
  SelectAccountPageState createState() => SelectAccountPageState();
}

class SelectAccountPageState extends State<SelectAccountPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowSearchButton = false;
  int selectedIndex = 0;
  int _groupValue;

  List<ReceiverModel> receivers = [
    ReceiverModel('Mohan', '9087889656', '1234 0000 0099 0909'),
    ReceiverModel('Ramesh', '9567443234', '1234 0000 0099 0909'),
    ReceiverModel('Kumar', '9786443230', '1234 0000 0099 0909'),
    ReceiverModel('Laxmanan', '9345267767', '1234 0000 0099 0909'),
    ReceiverModel('Prasanth', '9899778977', '5678 0000 0099 0909'),
  ];

  List<ReceiverModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
                padding:
                const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Rmlightblue,),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      'Send Money',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20.0,color: Rmlightblue),
                    ),
                  ],
                )),
            _getSearchSection(),
            _getAccountTypeSection(),
            //_buildRadios(),
            selectedIndex == 0 ? _getContactListSection() : _getAccountListSection()
          ],
        ),
      ),
    );
  }

  Widget _getSearchSection() {
    Widget searchBar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration.collapsed(
                hintText: 'Search for Number or Name',
              ),
              onChanged: _searchTextChanged,
            ),
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      height: 56.0,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: searchBar,
        ),
      ),
    );
  }

  Widget _getAccountTypeSection() {
    return Container(
      margin: EdgeInsets.all(16.0),


      child: Card(
        margin: EdgeInsets.all(0.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Container(
          height: 68.0,
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTapUp: (tapDetail) {
                    selectedIndex = 0;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius
                          .all(
                          Radius
                              .circular(
                              5.0)),
                      gradient: LinearGradient(
                        // new
                        // Where the linear gradient begins and ends
                        begin: Alignment.topRight, // new
                        end: Alignment.bottomLeft, // new
                        // Add one stop for each color.
                        // Stops should increase
                        // from 0 to 1
                        stops: [0.0, 0.5],
                        colors: selectedIndex == 0
                        ? [
                        // Colors are easy thanks to Flutter's
                        // Colors class.
                        Rmlightblue,
                        Rmlightblue
                        ]
                        : [Colors.white, Colors.white],
                      ),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person_sharp,
                            color: selectedIndex == 0
                                ? Colors.white
                                : Color(0xFF939192),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Phone\nContacts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : Color(0xFF939192)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: GestureDetector(
                  onTapUp: (tapDetail) {
                    selectedIndex = 1;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius
                          .all(
                          Radius
                              .circular(
                              5.0)),
                      gradient: LinearGradient(
                        // new
                        // Where the linear gradient begins and ends
                        begin: Alignment.topRight, // new
                        end: Alignment.bottomLeft, // new
                        // Add one stop for each color.
                        // Stops should increase
                        // from 0 to 1
                        stops: [0.0, 0.5],
                        colors: selectedIndex == 1
                        ? [
                        // Colors are easy thanks to Flutter's
                        // Colors class.
                        Rmlightblue,
                        Rmlightblue
                        ]
                        : [Colors.white, Colors.white],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.account_balance,
                            color: selectedIndex == 1
                                ? Colors.white
                                : Color(0xFF939192),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Bank\nAccounts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : Color(0xFF939192)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAccountListSection() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Card(
                child: ListView.builder(
                    itemCount: searchController.text.isEmpty ? receivers.length : searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _getReceiverSection(searchController.text.isEmpty ? receivers[index] : searchResults[index]);
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.0),
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Rmlightblue,
                      borderRadius: BorderRadius.all(Radius.circular(11.0))),
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'ADD ACCOUNT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getContactListSection() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Card(
                child: ListView.builder(
                    itemCount: searchController.text.isEmpty ? receivers.length : searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _getReceiverSection(searchController.text.isEmpty ? receivers[index] : searchResults[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReceiverSection(ReceiverModel receiver) {
    return GestureDetector(
      onTapUp: (tapDetail) {
        Navigator.push(context,
            SendMoneyPageRoute(receiver));
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Rmlightblue,
                child: Text(receiver.name.substring(0, 1),style: TextStyle(color: Colors.white),),
              ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      receiver.name,
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.phone,
                            size: 13.0,
                            color: Color(0xFF929091),),
                        ),
                        Text(
                          receiver.phoneNumber,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF929091)),
                        ),
                      ],
                    ),
                   Divider(),
                   /* Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.account_balance,
                              size: 13.0, color: Color(0xFF929091)),
                        ),
                        Text(
                          receiver.accountNumber,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF929091)),
                        ),
                      ],
                    )*/
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void _searchTextChanged(String text) {
    isShowSearchButton = text.isNotEmpty;
    searchResults = receivers.where((i) {
      return i.name.toLowerCase().contains(text.toLowerCase()) || i.phoneNumber.toLowerCase().contains(text.toLowerCase()) || i.accountNumber.toLowerCase().contains(text.toLowerCase());
    }).toList();
    setState(() {});
  }
}