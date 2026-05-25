import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/responsive.dart';
import '../../providers/review_provider.dart';
import '../../widgets/responsive_body.dart';

class WriteReviewScreen extends StatefulWidget {
  final String tutorId;
  final String token;

  /// EDIT DATA
  final String? reviewId;
  final String? existingReview;
  final double? existingRating;

  const WriteReviewScreen({
    super.key,
    required this.tutorId,
    required this.token,
    this.reviewId,
    this.existingReview,
    this.existingRating,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ReviewProvider>();

      /// EDIT MODE
      if (widget.reviewId != null) {
        provider.reviewController.text = widget.existingReview ?? "";

        provider.updateRating(widget.existingRating ?? 0);
      } else {
        provider.clearReview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReviewProvider>();

    final width = Responsive.contentWidth(context);
    final height = Responsive.height(context);

    final isEdit = widget.reviewId != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),

        elevation: 0,

        centerTitle: true,

        title: Text(isEdit ? "Edit Review" : "Write Review"),
      ),

      body: SafeArea(
        child: ResponsiveBody(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
          padding: Responsive.screenPadding(context),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TITLE
              Text(
                isEdit ? "Update Your Review" : "Rate Your Experience",

                style: TextStyle(
                  color: Colors.white,

                  fontSize: width * 0.055,

                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.04),

              /// STAR SESSION
              Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(vertical: height * 0.025),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  children: [
                    Text(
                      "Tap To Rate",

                      style: TextStyle(
                        color: Colors.white70,

                        fontSize: width * 0.04,
                      ),
                    ),

                    SizedBox(height: height * 0.015),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            provider.updateRating(index + 1.0);
                          },

                          icon: Icon(
                            index < provider.rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,

                            color: Colors.amber,

                            size: width * 0.1,
                          ),
                        );
                      }),
                    ),

                    Text(
                      provider.rating == 0
                          ? "No Rating"
                          : "${provider.rating.toInt()} / 5",

                      style: TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,

                        fontSize: width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.04),

              /// REVIEW FIELD
              Text(
                "Your Review",

                style: TextStyle(
                  color: Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: width * 0.045,
                ),
              ),

              SizedBox(height: height * 0.018),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),

                  borderRadius: BorderRadius.circular(24),
                ),

                child: TextField(
                  controller: provider.reviewController,

                  maxLines: 7,

                  style: const TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    hintText: "Write your experience here...",

                    hintStyle: const TextStyle(color: Colors.white54),

                    border: InputBorder.none,

                    contentPadding: EdgeInsets.all(width * 0.05),
                  ),
                ),
              ),

              SizedBox(height: height * 0.06),

              /// BUTTONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,

                        padding: EdgeInsets.symmetric(vertical: height * 0.02),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {
                        provider.clearReview();

                        Navigator.pop(context);
                      },

                      child: Text(
                        "Cancel",

                        style: TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,

                          fontSize: width * 0.036,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.04),

                  /// SUBMIT / UPDATE
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),

                        padding: EdgeInsets.symmetric(vertical: height * 0.02),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              bool success = false;

                              /// UPDATE
                              if (isEdit) {
                                success = await provider.updateReview(
                                  tutorId: widget.tutorId,

                                  reviewId: widget.reviewId!,

                                  token: widget.token,
                                );
                              } else {
                                /// ADD
                                success = await provider.submitReview(
                                  tutorId: widget.tutorId,

                                  token: widget.token,
                                );
                              }

                              if (success && context.mounted) {
                                provider.clearReview();

                                 Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,

                                    content: Text(
                                      isEdit
                                          ? "Failed to update review"
                                          : "Please add rating and review",
                                    ),
                                  ),
                                );
                              }
                            },

                      child: provider.isLoading
                          ? SizedBox(
                              height: width * 0.05,

                              width: width * 0.05,

                              child: const CircularProgressIndicator(
                                color: Colors.white,

                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEdit ? "Update" : "Submit",

                              style: TextStyle(
                                color: Colors.white,

                                fontWeight: FontWeight.bold,

                                fontSize: width * 0.036,
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.03),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
