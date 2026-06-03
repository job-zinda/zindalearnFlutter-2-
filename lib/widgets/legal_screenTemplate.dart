import 'package:flutter/material.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class LegalScreenTemplate extends StatelessWidget {
  final String title;
  final List<String> body;

  const LegalScreenTemplate({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {

    final width = Responsive.contentWidth(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.fontSize(
              context,
              0.05,
              min: 18,
              max: 24,
            ),
          ),
        ),
      ),

      body: ResponsiveBody(
        child: ListView.separated(

          padding: Responsive.screenPadding(context),

          itemCount: body.length,

          separatorBuilder: (_, __) =>
              SizedBox(
                height: Responsive.spacing(
                  context,
                  0.015,
                ),
              ),

          itemBuilder: (context, index) {

            final text = body[index];

            return Container(

              padding: EdgeInsets.all(
                width * 0.045,
              ),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),

                borderRadius:
                    BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0,4),
                  ),
                ],
              ),

              child: Text(
                text,

                style: TextStyle(
                  color: Colors.white,

                  height: 1.7,

                  fontSize: Responsive.fontSize(
                    context,
                    0.034,
                    min: 13,
                    max: 17,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}