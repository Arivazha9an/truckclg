
import 'package:flutter/material.dart';
import 'package:truckclgproject/BharathBenz/screens/forms/refuel.dart';
import 'package:truckclgproject/BharathBenz/screens/retrieve/fuelretrieve.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';

class Fuelselect extends StatefulWidget {
  const Fuelselect({super.key});

  @override
  State<Fuelselect> createState() => _VehicleselectState();
}

class _VehicleselectState extends State<Fuelselect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Select'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                title: 'Store',
                background: green,
                textColor: white,
                fontSize: 18,
                width: 200,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BFuel()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                width: 200,
                title: 'View',
                background: orange,
                textColor: white,
                fontSize: 18,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FuelRetrieve()),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
