import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';

import '../../providers/course_provider.dart';

class CoursesScreen extends StatefulWidget {
  final String categoryId;

  final String categoryTitle;

  final String token;
  final String sessionType;

  const CoursesScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.token,
    required this.sessionType,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CourseProvider>().fetchCourses(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final filteredCourses = provider.courses.where((course) {
      if (widget.sessionType.isEmpty || widget.sessionType == "none") {
        return true;
      }

      // TEMP FIX FOR SKILL & TALENT
      if (widget.sessionType == "skill_base" ||
          widget.sessionType == "talent_base") {
        return true;
      }

      return course.sectionType == widget.sessionType;
    }).toList();

    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: Text(widget.categoryTitle),

        actions: [Padding(padding: const EdgeInsets.only(right: 12))],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          // : provider.courses.isEmpty
          : filteredCourses.isEmpty
          ? const Center(
              child: Text(
                "No Courses Found",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(width * 0.04),

              // itemCount: provider.courses.length,
              itemCount: filteredCourses.length,

              itemBuilder: (context, index) {
                // final course = provider.courses[index];
                final course = filteredCourses[index];

                return Container(
                  margin: EdgeInsets.only(bottom: height * 0.025),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A145F), Color(0xFF241B7A)],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),

                        blurRadius: 14,

                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(width * 0.045),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        /// IMAGE
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            border: Border.all(color: Colors.white24, width: 3),
                          ),

                          child: CircleAvatar(
                            radius: width * 0.16,

                            backgroundColor: Colors.white,

                            backgroundImage: course.image.isNotEmpty
                                ? NetworkImage(course.image)
                                : null,

                            child: course.image.isEmpty
                                ? const Icon(
                                    Icons.school,
                                    size: 42,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),

                        SizedBox(height: height * 0.022),

                        /// TITLE
                        Text(
                          course.title,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: width * 0.05,

                            fontWeight: FontWeight.bold,

                            letterSpacing: 0.4,
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        /// DESCRIPTION
                        Text(
                          course.description.isNotEmpty
                              ? course.description
                              : "Professional course available for students.",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white70,

                            fontSize: width * 0.034,

                            height: 1.7,
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,

                          height: height * 0.06,

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: () {
                              // Navigator.push(
                              //   context,

                              //   MaterialPageRoute(
                              //     builder: (_) => TutorsScreen(
                              //       courseId: course.id,

                              //       courseTitle: course.title,

                              //       token: widget.token,
                              //     ),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorsScreen(
                                    courseId: course.id,
                                    courseTitle: course.title,
                                    token: widget.token,
                                  ),
                                ),
                              );
                            },

                            icon: const Icon(Icons.person_search),

                            label: Text(
                              "View Tutors",

                              style: TextStyle(
                                fontSize: width * 0.038,

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
