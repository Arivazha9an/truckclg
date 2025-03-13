
import 'package:flutter/material.dart';
import 'package:truckclgproject/payment/upi.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Google Pay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Choose Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Other Payment Methods',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                paymentOption('Credit/ Debit Card', Icons.credit_card),
                SizedBox(
                  height: 10,
                ),
                paymentOption('Phonepay', Icons.account_balance_wallet),
                SizedBox(
                  height: 10,
                ),
                paymentOption('Google Pay', Icons.payments),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 180),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  onPressed: () {
                    _navigateToSelectedScreen(context);
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentOption(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (selectedPaymentMethod == title)
              Icon(Icons.radio_button_checked, color: Colors.blue)
            else
              Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _navigateToSelectedScreen(BuildContext context) {
    Widget screen;
    switch (selectedPaymentMethod) {
      case 'Credit/ Debit Card':
        screen = CreditCardScreen();
        break;
      case 'Phonepay':
        screen = PhonePayScreen();
        break;
      case 'Google Pay':
        screen = FlutterPayUPI();
        break;
      default:
        screen = GooglePayScreen();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

// Dummy Screens for demonstration

class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit/Debit Card Payment'),
      ),
      body: Center(
        child: Text('Credit/Debit Card Payment Screen'),
      ),
    );
  }
}

class PhonePayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phonepay Payment'),
      ),
      body: Center(
        child: Text('Phonepay Payment Screen'),
      ),
    );
  }
}

class GooglePayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Pay Payment'),
      ),
      body: Center(
        child: Text('Google Pay Payment Screen'),
      ),
    );
  }
}
