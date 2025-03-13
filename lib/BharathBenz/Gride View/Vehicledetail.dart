import 'package:flutter/material.dart';
import 'package:truckclgproject/BharathBenz/screens/select/Insuranceselect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/PUCSelect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/Permitselect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/expenseSelect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/vehicledetailselect.dart';
import 'package:truckclgproject/constants/colors.dart';

class Vehciledetailgrid extends StatefulWidget {
  const Vehciledetailgrid({super.key});

  @override
  State<Vehciledetailgrid> createState() => _VehciledetailgridState();
}

class _VehciledetailgridState extends State<Vehciledetailgrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30),
            buildRow(
                context,
                const Expenseselect(),
                "Expense",
                "assets/images/expense.jpg",
                const Insuranceselect(),
                "Insurance",
                "assets/images/insurance.jpg"),
            const SizedBox(height: 30),
            buildRow(
                context,
                const Permitselect(),
                "Permit",
                "assets/images/permit.jpg",
                const Pucselect(),
                "PUC",
                "assets/images/PUC.jpg"),
            const SizedBox(height: 30),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Vehicledetailselect()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: buildContainer(
                        "Vehicle Info", "assets/images/vehicledetails.jpg"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildRow(
      BuildContext context,
      Widget firstRoute,
      String firstText,
      String firstImage,
      Widget secondRoute,
      String secondText,
      String secondImage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildInkWell(context, firstRoute, firstText, firstImage),
        buildInkWell(context, secondRoute, secondText, secondImage),
      ],
    );
  }

  InkWell buildInkWell(
      BuildContext context, Widget route, String text, String image) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: buildContainer(text, image),
    );
  }

  Container buildContainer(String text, String image) {
    return Container(
      height: 100,
      width: 155,
      decoration: BoxDecoration(
        color: black,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.5), 
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                color: white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
