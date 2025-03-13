
import 'package:flutter/material.dart';
import 'package:truckclgproject/BharathBenz/Gride%20View/GrideView.dart';
import 'package:truckclgproject/constants/colors.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          const Text(
            'Vehicle List',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 65,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BGrideview()),
                );
              },
              child: Container(
                height: 150,
                width: 330,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/bharathbenz.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.5), // Add a semi-transparent overlay
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Center(
                      child: Text(
                        'BHARATH BENZ',
                        style: const TextStyle(
                            color: white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
