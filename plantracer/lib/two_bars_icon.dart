import 'package:flutter/material.dart';
import 'utils.dart';

class TwoBarsIcon extends StatelessWidget {
  const TwoBarsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 23,
            height: 3,
            decoration: BoxDecoration(
              color: getTextColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 15,
            height: 3,
            decoration: BoxDecoration(
              color: getTextColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
