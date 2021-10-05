import 'dart:io';

import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Termsandcondition extends StatefulWidget {
  const Termsandcondition({Key key}) : super(key: key);

  @override
  _TermsandconditionState createState() => _TermsandconditionState();
}

class _TermsandconditionState extends State<Termsandcondition> {


  File _image;
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                //color: Color(0xff0066ff),
                  gradient: LinearGradient(
                    colors: [
                      Rmlightblue,
                      Rmpick,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,color: Colors.white,),
                      title: new Text('Upload from Gallery',style: TextStyle(color: Colors.white),),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,color: Colors.white),
                    title: new Text('Capture image & upload',style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
          color: Rmlightblue,
          child: SafeArea(child:Scaffold(
         backgroundColor: Colors.white,
           appBar: AppBar(
             brightness: Brightness.light,
             leading: IconButton(
               icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
               onPressed: () => Navigator.of(context).pop(),
             ),
             backgroundColor: Colors.white,
             elevation: 0.0,
             title: Text("Terms and conditions",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
           ),
           body: SingleChildScrollView(child:Container(padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text("Consent authorisation"),
        Text("By this consent, I/we understand and agree that:  "),
        Text("I.  You may access private and digital data from my device(s) for the purposes of determining my/our creditworthiness and qualification for specific services provided by Alfie Tech Sdn Bhd."),
        Text("II. You may conduct credit/ trade check including CCRIS checks on me/us and when consent has been given individually, on our  directors, shareholders, guarantors, etc. with any registered Credit Bureaus at any time for as long as I/we have a trade relationship with you or where any dues remain unpaid and outstanding with you, for any one or more of the following purposes:  "),
        Text("   1. Opening of account",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("   2. Credit/Account monitoring",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("   3. Debt recovery",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("   4. Credit/Account evaluation  ",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("   5. Credit/Account review  ",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("   6. Legal documentation consequent to a contract or facility granted by you.  ",style: TextStyle(fontWeight: FontWeight.bold),),
        Text("III.  You may disclose any information on my/our conduct of my/our account(s) with you, to any business entity/ies for bona fide trade checking at any time.  I/We am/are also aware and understand that such information will be provided to Alfie Tech Sdn Bhd, who may in turn share such information to subscribers of their service.  "),
        Text("IV.  Where you require any processing of my/our application to be processed by any processing center located outside Malaysia (including your Head Office), I/we hereby give consent to Alfie Tech Sdn Bhd to disclose my/our credit information except CCRIS, to such  locations outside Malaysia.  "),
        Text("V.  Apart from the above, I/we the undersigned do give my/our consent to you and the Alfie Tech Sdn Bhd, to process my/our personal data as  per the PDPA Act."),

        SizedBox(height: 10,),
        Text("Insert Signature ",style: TextStyle(fontWeight: FontWeight.bold),),
        Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Container(

              decoration: BoxDecoration(
                border: Border.all(color: Rmlightblue),

                borderRadius:BorderRadius.all(Radius.circular(20.0)),
                color: Colors.black,
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: _image==null?Icon(
                Icons.camera_alt,
                color: Colors.white,
              ):Image.file(
                _image,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),

       /* Row(children: [
          Text("Signature below: ",style: TextStyle(fontWeight: FontWeight.bold),),
          IconButton(icon: Icon(Icons.brush), onPressed:(){
            setState(() {
              _controller.clear();
            });
          })
        ],),
        Container(
          color: Rmlightblue,
          padding: EdgeInsets.all(5),
          child: Signature(
              width: MediaQuery.of(context).size.width,
              height: 70,
              controller: _controller,
              backgroundColor: Colors.grey),
        ),*/
       /* buildButton(
            onPressCallback: () {
              setState(() {
                Navigator.of(context).pop();

              });
            },
            backgroundColor: appcolor,
            title: "Submit"
        ),
*/
        SizedBox(height: 10,),

        Container(
          height: 50.0,
          alignment: Alignment.center,

          child: RaisedButton(
            onPressed: () {
              setState(() {
                if(_image==null){
                  ToastUtil.show("Please select Signature image");
                }else{
                  Navigator.of(context).pop();
                }


              });
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.all(0.0),
            color: Rmpick,
            splashColor: Rmpick,
            elevation: 10,
            child: Ink(
              decoration: BoxDecoration(
                  //color: Color(0xff0066ff),
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

                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "Accept",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    Spacer(),
                    Card(
                      //color: Color(0xCDA3C5EC),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      child: SizedBox(
                        width: 35.0,
                        height: 35.0,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Rmpick,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],) ,),))));
  }
}
