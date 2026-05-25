import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = Responsive.contentWidth(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: width * 0.08,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: Icon(
                  Icons.school,
                  color: Colors.blue.shade200,
                  size: width * 0.08,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, 0.015)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 0.04, min: 13, max: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
