import 'package:flutter/material.dart';

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

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(
        bottom: height * 0.02,
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
                backgroundColor:
                    Colors.blue.withOpacity(0.2),

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
                    fontSize: width * 0.04,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: height * 0.015),

          Text(
            message,

            style: TextStyle(
              color: Colors.white70,
              fontSize: width * 0.036,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}