
import 'package:flutter/material.dart';
import 'package:truckclgproject/BharathBenz/screens/forms/insurancedetail.dart';
import 'package:truckclgproject/BharathBenz/screens/retrieve/insuranceretrive.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';

class Insuranceselect extends StatefulWidget {
  const Insuranceselect({super.key});

  @override
  State<Insuranceselect> createState() => _VehicleselectState();
}

class _VehicleselectState extends State<Insuranceselect> {
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
                    MaterialPageRoute(
                        builder: (context) => const BInsurancedetail()),
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
                    MaterialPageRoute(
                        builder: (context) => const Insuranceretrive()),
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
