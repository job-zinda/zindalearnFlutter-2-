import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';

class FeedbackCard extends StatelessWidget {
  final String name;
  final String message;

  const FeedbackCard({
    super.key,
    required this.name,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final width = Responsive.contentWidth(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: Responsive.spacing(context, 0.02),
      ),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.fontSize(context, 0.04, min: 13, max: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, 0.015)),
          Text(
            message,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Responsive.fontSize(context, 0.036, min: 12, max: 15),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
