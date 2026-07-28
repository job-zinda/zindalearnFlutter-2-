import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/custom_searchbar.dart';
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
  String courseSearchQuery = "";

  @override
  void initState() {
    super.initState();
  Future.microtask(() {
  if (!mounted) return;
  context.read<CourseProvider>().fetchCourses(widget.categoryId);
});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // Evaluate category rules and search query terms safely
    final filteredCourses = provider.courses.where((course) {
      bool matchesType = false;
      if (widget.sessionType.isEmpty || widget.sessionType == "none") {
        matchesType = true;
      } else if (widget.sessionType == "skill_base" ||
          widget.sessionType == "talent_base") {
        matchesType = true;
      } else {
        matchesType = course.sectionType == widget.sessionType;
      }

      bool matchesSearch = course.title.toLowerCase().contains(
        courseSearchQuery.toLowerCase(),
      );

      return matchesType && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.categoryTitle),
        actions: const [Padding(padding: EdgeInsets.only(right: 12))],
      ),
      body: ResponsiveBody(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.screenPadding(context).left,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            CustomSearchBar(
              hintText: "Search courses...",
              onChanged: (value) {
                setState(() {
                  courseSearchQuery = value;
                });
              },
            ),
            SizedBox(height: Responsive.spacing(context, 0.025)),

            // UI Layout Controller based on Provider State
            Expanded(
              child: () {
                // State 1: Show Loader
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // State 2: Network Connection Error Occurred (Catches the server sleeping/connection issues)
                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Colors.white38,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                            ),
                            onPressed: () {
                              context.read<CourseProvider>().fetchCourses(
                                widget.categoryId,
                              );
                            },
                            child: const Text(
                              "Retry Connection",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // State 3: List Empty after filtering or empty fetch
                if (filteredCourses.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Courses Found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                // State 4: Data Loaded successfully
                return _buildCoursesList(context, filteredCourses);
              }(),
            ),
          ],
        ),
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
        separatorBuilder: (_, _) =>
            SizedBox(height: Responsive.spacing(context, 0.025)),
        itemBuilder: (context, index) =>
            _buildCourseCard(context, courses[index]),
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
      itemBuilder: (context, index) =>
          _buildCourseCard(context, courses[index]),
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
  color: Colors.black.withValues(alpha: 0.22),
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
                            child: Icon(
                              Icons.school,
                              size: imageSize * 0.5,
                              color: Colors.grey,
                            ),
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
                      // backgroundColor: const Color(0xFF6C63FF),
                      backgroundColor: const Color(0xFF8B5CF6),
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
