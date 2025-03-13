import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart'; 
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Driverpaymentretreive extends StatelessWidget {
  const Driverpaymentretreive({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('driverpayment').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.discreteCircle(color: orange, size: 60);
        }

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Driver Payment Data',
            isGoBack: true,
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String driverName = data['Driver Name'] ?? '';
              String vehicleName = data['Vehicle Name'] ?? '';
              String salary = data['Salary'] ?? '';
              String payment = data['Payment'] ?? '';
              String date = data['date'] ?? '';
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: orange, width: w * 0.005)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 70, right: 20, top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Driver Name  = '),
                            Text(driverName),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Vehicle Name  = '),
                            Text(vehicleName),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Salary  = '),
                            Text(salary),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Payment = '),
                            Text(payment),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Date = '),
                            Text(date),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
