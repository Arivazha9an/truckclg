
import 'package:flutter/material.dart';
import 'package:truckclgproject/BharathBenz/Gride%20View/Vehicledetail.dart';
import 'package:truckclgproject/BharathBenz/screens/select/Loadselect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/Refuelselect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/driverselect.dart';
import 'package:truckclgproject/BharathBenz/screens/select/serviceselect.dart';
import 'package:truckclgproject/constants/colors.dart';

class BGrideview extends StatefulWidget {
  const BGrideview({super.key});

  @override
  State<BGrideview> createState() => _BGrideviewState();
}

class _BGrideviewState extends State<BGrideview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bharath Benz'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30),
            buildRow(
                context,
                const Fuelselect(),
                "Refuel",
                "assets/images/fuel.jpg",
                const Serviceselect(),
                "Service",
                "assets/images/service.jpg"),
            const SizedBox(height: 30),
            buildRow(
                context,
                const Loadselect(),
                "Load",
                "assets/images/load.jpg",
                const Driverselect(),
                "Driver",
                "assets/images/driver.jpg"),
            const SizedBox(height: 30),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Vehciledetailgrid()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: buildContainer(
                        "Vehicle \n Details", "assets/images/vehicledetails.jpg"),
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
