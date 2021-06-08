import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  Token _paymentToken;
  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }
  final List<Map<String,dynamic>> _listItem = [
    {
      'name': "Pay via new card",
      'icon': Icons.credit_card,
    },
    {
      'name': "Native Pay",
      'icon': Icons.credit_card,
    },
    // Icons.email,
    // Icons.calendar_today
  ];
  _onpressed(BuildContext context,int index) async{
print("you tapped $index");
switch(index) {
  case 0:
   await payViaNewCard(context);
    break;
  case 1:
    await nativePay();
    break;
}

  }
  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '15000',
        currency: 'USD'
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
        )
    );
  }
nativePay(){
  if (Platform.isIOS) {
    _controller.jumpTo(450);
  }
  StripePayment.paymentRequestWithNativePay(
    androidPayOptions: AndroidPayPaymentRequest(
      totalPrice: "2.40",
      currencyCode: "EUR",
    ),
    applePayOptions: ApplePayPaymentOptions(
      countryCode: 'DE',
      currencyCode: 'EUR',
      items: [
        ApplePayItem(
          label: 'Test',
          amount: '27',
        )
      ],
    ),
  ).then((token) {
    setState(() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
      _paymentToken = token;
    });
  }).catchError(setError);
}
  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: Icon(Icons.arrow_back),
        title: Text("Payment"),

      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('assets/images/stripe.png'),
                        fit: BoxFit.cover
                    )
                ),

              ),
              SizedBox(height: 20,),
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: _listItem.map((item) => GestureDetector(
                      onTap: ()=>_onpressed(context,_listItem.indexOf(item)),
                      child: Card(

                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_listItem[_listItem.indexOf(item)]['icon'],size: 48,color: Colors.deepOrange,),
                            SizedBox(height: 12,),
                            Text("${_listItem[_listItem.indexOf(item)]['name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                          ],
                        )
                      ),
                    )).toList(),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}