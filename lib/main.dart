import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/pages/existing-cards.dart';
import 'package:flutter_stripe_payments/pages/home.dart';
import 'package:flutter_stripe_payments/pages/homepage.dart';
import 'package:flutter_stripe_payments/pages/new%20card.dart';
import 'package:flutter_stripe_payments/services/payment-service-alt.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage1(),
        '/existing-cards': (context) => ExistingCardsPage(),
        '/new-card':(context)=>MySample()
      },
    );
  }
}
