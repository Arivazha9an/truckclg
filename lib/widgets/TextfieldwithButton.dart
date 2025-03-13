import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';



class CustomFieldButton extends StatelessWidget {
  final String name;

  final VoidCallback ontap;

  const CustomFieldButton(
      {super.key, required this.name,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 330,
          height: 55,
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: name,
              hintStyle: const TextStyle(color: black),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    bottomLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                    bottomRight: Radius.circular(17)),
                borderSide: BorderSide(color: black, style: BorderStyle.none),
              ),
            ),
          ),
        ),
        Positioned(
          left: 250,
          child: SizedBox(
            width: 80,
            height: 55,
            child: InkWell(
              onTap: ontap,
              child: Container(
                width: 80,
                height: 46,
                decoration: BoxDecoration(
                    color: blue,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        topRight: Radius.circular(17),
                        bottomRight: Radius.circular(17)),
                    border: Border.all(color: blue)),
                child: const Center(
                  child: Text(
                    'Details',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
