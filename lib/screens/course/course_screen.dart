import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';

import '../../core/utils/responsive.dart';
import '../../models/course_model.dart';
import '../../providers/course_provider.dart';
import '../../widgets/cached_app_image.dart';
import '../../widgets/responsive_body.dart';

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
          : ResponsiveBody(
              padding: EdgeInsets.zero,
              child: _buildCoursesList(context, filteredCourses),
            ),
    );
  }

  Widget _buildCoursesList(BuildContext context, List<CourseModel> courses) {
    final columns = Responsive.gridColumns(context);
    final padding = Responsive.screenPadding(context);

    if (columns == 1) {
      return ListView.separated(
        padding: padding,
        itemCount: courses.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: Responsive.spacing(context, 0.025)),
        itemBuilder: (context, index) => _buildCourseCard(context, courses[index]),
      );
    }

    return GridView.builder(
      padding: padding,
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: Responsive.value(
          context,
          mobile: 0.8,
          tablet: 0.68,
          desktop: 0.72,
        ),
      ),
      itemBuilder: (context, index) => _buildCourseCard(context, courses[index]),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    final isGrid = Responsive.gridColumns(context) > 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        final imageSize = isGrid ? 56.0 : (cardW * 0.28).clamp(48.0, 90.0);
        final titleSize = isGrid ? 15.0 : (cardW * 0.05).clamp(14.0, 20.0);
        final bodySize = isGrid ? 12.0 : (cardW * 0.034).clamp(11.0, 15.0);

        return Container(
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
            padding: EdgeInsets.all(cardW * 0.045),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: course.image.isNotEmpty
                        ? CachedAppImage(url: course.image, fit: BoxFit.cover)
                        : ColoredBox(
                            color: Colors.white,
                            child: Icon(Icons.school, size: imageSize * 0.5, color: Colors.grey),
                          ),
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 0.015)),
                Text(
                  course.title,
                  textAlign: TextAlign.center,
                  maxLines: isGrid ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 0.01)),
                Text(
                  course.description.isNotEmpty
                      ? course.description
                      : 'Professional course available for students.',
                  textAlign: TextAlign.center,
                  maxLines: isGrid ? 3 : 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: bodySize,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 0.015)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
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
                    icon: const Icon(Icons.person_search, size: 18),
                    label: Text(
                      'View Tutors',
                      style: TextStyle(
                        fontSize: isGrid ? 12 : bodySize + 1,
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
    );
  }
}
