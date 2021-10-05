import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gkash_flutter_sdk/gkash_flutter_sdk.dart';
import 'package:gkash_flutter_sdk/gkash_payment_callback.dart';
import 'package:gkash_flutter_sdk/payment_request.dart';


class MyApp11 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gkash Payment Demo'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements GkashPaymentCallback {
  var amountInput;
  GkashFlutterSdk _gkashFlutterSdk;

  // Insert your merchant Id
  String _merchantId = 'M161-U-20392';
  // Insert your signature key
  String _signatureKey = 'OtAWUOLSJV4ttQm';

  void submitButton(var amount) {
    PaymentRequest request = PaymentRequest(
      version: '1.5.0',
      cid: _merchantId,
      currency: 'MYR',
      amount: amount,
      cartid: DateTime.now().microsecond.toString(),
      signatureKey: _signatureKey,
    );

    try {
      _gkashFlutterSdk.startPayment(context, request, this);
    } catch (e) {
      //catch exception when sdk throw
      print(e);
    }
  }

  @override
  void onPaymentResult(
      String status,
      String description,
      String companyRemId,
      String poId,
      String cartId,
      String amount,
      String currency,
      String paymentType) {
    print('Gkash Payment Demo: Payment done.');
    Fluttertoast.showToast(msg: status, textColor: Colors.green);
    // handle payment response
  }

  @override
  void initState() {
    _gkashFlutterSdk = GkashFlutterSdk.getInstance();

    //set staging environment
    //set to true when using production
    _gkashFlutterSdk.setProductionEnvironment(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the amount';
              }
              return null;
            },
            onChanged: (amount) {
              amountInput = amount;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Amount",
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                submitButton(amountInput);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('SUBMIT'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}