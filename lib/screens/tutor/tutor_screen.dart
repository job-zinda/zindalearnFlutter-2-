import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_detailes_screen.dart';

import '../../providers/tutor_provider.dart';

class TutorsScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String token;

  const TutorsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.token,
  });

  @override
  State<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   context.read<TutorProvider>().fetchTutors(widget.courseId, widget.token);
    // })
   final isAllTutors = widget.courseId.isEmpty;

Future.microtask(() {
  context.read<TutorProvider>().fetchTutors(
    isAllTutors ? null : widget.courseId,
    widget.token,
  );
});
  }

  double getAverageRating(List reviews) {
    if (reviews.isEmpty) return 0;

    double total = 0;

    for (var review in reviews) {
      total += (review["rating"] ?? 0).toDouble();
    }

    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TutorProvider>();

    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),

        elevation: 0,

        centerTitle: true,

        title: Text(
          widget.courseTitle,

          style: TextStyle(
            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: width * 0.05,
          ),
        ),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.tutors.isEmpty
          ? const Center(
              child: Text(
                "No Tutors Found",

                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),

              itemCount: provider.tutors.length,

              itemBuilder: (context, index) {
                final tutor = provider.tutors[index];

                return Container(
                  margin: EdgeInsets.only(bottom: height * 0.025),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),

                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,

                      colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),

                        blurRadius: 15,

                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(width * 0.045),

                    child: Column(
                      children: [
                        /// TOP SECTION
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            /// PROFILE IMAGE
                            Container(
                              padding: const EdgeInsets.all(3),

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: Colors.white24,
                                  width: 2,
                                ),
                              ),

                              child: CircleAvatar(
                                radius: width * 0.11,

                                backgroundColor: Colors.white,

                                backgroundImage: tutor.image.isNotEmpty
                                    ? NetworkImage(tutor.image)
                                    : null,

                                child: tutor.image.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: width * 0.09,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),

                            SizedBox(width: width * 0.04),

                            /// NAME + RATING
                            Expanded(
                              child: SizedBox(
                                height: width * 0.22,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    /// NAME + STAR
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,

                                      children: [
                                        Expanded(
                                          child: Text(
                                            tutor.name
                                                .split(' ')
                                                .map(
                                                  (word) => word.isNotEmpty
                                                      ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                                      : '',
                                                )
                                                .join(' '),

                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.052,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.025,
                                            vertical: height * 0.005,
                                          ),

                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.08,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: width * 0.04,
                                              ),

                                              SizedBox(width: width * 0.01),

                                              Text(
                                                getAverageRating(
                                                  tutor.reviews,
                                                ).toStringAsFixed(1),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.032,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.025),

                        /// QUALIFICATION + EXPERIENCE
                        Container(
                          width: double.infinity,

                          padding: EdgeInsets.all(width * 0.04),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              /// QUALIFICATION
                              if (tutor.qualification.isNotEmpty) ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Icon(
                                      Icons.school_rounded,

                                      color: Colors.amber,

                                      size: width * 0.05,
                                    ),

                                    SizedBox(width: width * 0.03),

                                    Expanded(
                                      child: Text(
                                        tutor.qualification,

                                        style: TextStyle(
                                          color: Colors.white70,

                                          fontSize: width * 0.034,

                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              if (tutor.qualification.isNotEmpty &&
                                  tutor.experience.isNotEmpty)
                                SizedBox(height: height * 0.018),

                              /// EXPERIENCE
                              if (tutor.experience.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Icon(
                                      Icons.workspace_premium,

                                      color: Colors.orange,

                                      size: width * 0.05,
                                    ),

                                    SizedBox(width: width * 0.03),

                                    Expanded(
                                      child: Text(
                                        tutor.experience,

                                        style: TextStyle(
                                          color: Colors.white70,

                                          fontSize: width * 0.034,

                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),

                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.018,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorDetailsScreen(
                                    tutorId: tutor.id,
                                    token: widget.token,
                                  ),
                                ),
                              );

                              // if (result == true) {
                              //   context.read<TutorProvider>().fetchTutors(
                              //     widget.courseId,
                              //     widget.token,
                              //   );
                              // }
                              await context.read<TutorProvider>().fetchTutors(
                                widget.courseId,
                                widget.token,
                              );
                            },

                            child: Text(
                              "View Profile",

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: width * 0.036,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
