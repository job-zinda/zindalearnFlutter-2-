import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/core/constants/app_textstyle.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_detailes_screen.dart';
import 'package:zindaonlineschool/widgets/custom_searchbar.dart';

import '../../core/utils/responsive.dart';
import '../../models/tutor_model.dart';
import '../../providers/tutor_provider.dart';
import '../../widgets/responsive_body.dart';

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
  String tutorSearchQuery = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // If courseId is empty string, convert to null for 'All Tutors' API structure
      final String? cleanCourseId = widget.courseId.isEmpty
          ? null
          : widget.courseId;

      context.read<TutorProvider>().fetchTutors(cleanCourseId, widget.token);
    });
  }

  double getAverageRating(List reviews) {
    if (reviews.isEmpty) return 0;

    double total = 0;
    int count = 0;

    for (var review in reviews) {
      if (review["rating"] != null) {
        total += review["rating"].toDouble();
        count++;
      }
    }

    return count == 0 ? 0 : total / count;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TutorProvider>();
    // 2. Filter tutors list locally based on search query match
    final filteredTutors = provider.tutors.where((tutor) {
      return tutor.name.toLowerCase().contains(tutorSearchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        elevation: 0,

        centerTitle: true,

        title: Text(
          widget.courseTitle,

          style: AppTextStyles.subHeading.copyWith(
            fontSize: Responsive.fontSize(context, 0.05, min: 16, max: 22),
          ),
        ),
      ),

      body: ResponsiveBody(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.screenPadding(context).left,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  CustomSearchBar at the top of the body layout stack
            const SizedBox(height: 12),
            CustomSearchBar(
              hintText: "Search tutors by name...",
              onChanged: (value) {
                setState(() {
                  tutorSearchQuery =
                      value; // Triggers instant filtering refresh
                });
              },
            ),
            SizedBox(height: Responsive.spacing(context, 0.025)),

            // 4. Wrap list/grid views in an Expanded widget area
            Expanded(
              child: provider.isLoading && provider.tutors.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTutors.isEmpty
                  ? const Center(
                      child: Text(
                        "No Tutors Found",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : _buildTutorsList(context, filteredTutors),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTutorsList(BuildContext context, TutorProvider provider) {
  Widget _buildTutorsList(BuildContext context, List<TutorModel> tutorsList) {
    final columns = Responsive.gridColumns(context);
    // final padding = Responsive.screenPadding(context);

    if (columns == 1) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tutorsList.length,
        separatorBuilder: (_, _) =>
            SizedBox(height: Responsive.spacing(context, 0.025)),
        itemBuilder: (context, index) =>
            _buildTutorCard(context, tutorsList[index]),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tutorsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: Responsive.value(
          context,
          mobile: 0.85,
          tablet: 0.72,
          desktop: 0.78,
        ),
      ),
      itemBuilder: (context, index) =>
          _buildTutorCard(context, tutorsList[index]),
    );
  }

  String _formatName(String name) {
    return name
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  Widget _buildTutorCard(BuildContext context, TutorModel tutor) {
    final isGrid = Responsive.gridColumns(context) > 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        final avatarR = isGrid ? 32.0 : (cardW * 0.11).clamp(28.0, 48.0);
        final nameSize = isGrid ? 14.0 : (cardW * 0.052).clamp(14.0, 20.0);
        final bodySize = isGrid ? 12.0 : (cardW * 0.034).clamp(11.0, 15.0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: AppColors.cardFill,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(cardW * 0.045),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.24),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: avatarR,
                        backgroundColor: AppColors.white,
                        backgroundImage: tutor.image.isNotEmpty
                            ? CachedNetworkImageProvider(tutor.image)
                            : null,
                        child: tutor.image.isEmpty
                            ? Icon(
                                Icons.person,
                                size: avatarR,
                                color: AppColors.grey,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: cardW * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatName(tutor.name),
                            maxLines: isGrid ? 2 : null,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading.copyWith(
                              fontSize: nameSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getAverageRating(
                                  tutor.reviews,
                                ).toStringAsFixed(1),
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white,
                                  fontSize: bodySize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (tutor.qualification.isNotEmpty) ...[
                  SizedBox(height: Responsive.spacing(context, 0.015)),
                  Text(
                    tutor.qualification,
                    maxLines: isGrid ? 2 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: bodySize,
                      height: 1.4,
                    ),
                  ),
                ],
                if (tutor.experience.isNotEmpty && !isGrid) ...[
                  SizedBox(height: Responsive.spacing(context, 0.012)),
                  Text(
                    tutor.experience,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: bodySize,
                      height: 1.4,
                    ),
                  ),
                ],
                SizedBox(height: Responsive.spacing(context, 0.018)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TutorDetailsScreen(
                            tutorId: tutor.id,
                            token: widget.token,
                          ),
                        ),
                      );
                    },
                    child: Text('View Profile', style: AppTextStyles.button),
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
