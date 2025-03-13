
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:truckclgproject/widgets/customtextformwithicon.dart';
import '../Gride View/GrideView.dart';
import 'package:flutter/material.dart';

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
                  decoration: const BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage("assets/images/bharathbenz.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                      child: Text(
                    'BHARATH BENZ',
                    style: TextStyle(
                        color: white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ))),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          // Center(
          //   child: InkWell(
          //     onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) =>const Grideview()),
          //           );
          //         },
          //     child: Container(
          //         height: 150,
          //         width: 330,
          //         decoration: const BoxDecoration(
          //           color: black,
          //           borderRadius: BorderRadius.all(Radius.circular(20)),
          //           image: DecorationImage(
          //             image: AssetImage("assets/images/Taurus.jpg"),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         child: const Center(
          //             child: Text(
          //           'TAURUS LORRY',
          //           style: TextStyle(
          //               color: white,
          //               fontSize: 24,
          //               fontWeight: FontWeight.bold),
          //         ),),),
          //   ),
          // )
        ],
      ),
    );
  }
}