import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_detailes_screen.dart';

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

            fontSize: Responsive.fontSize(context, 0.05, min: 16, max: 22),
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
          : ResponsiveBody(
              padding: EdgeInsets.zero,
              child: _buildTutorsList(context, provider),
            ),
    );
  }

  Widget _buildTutorsList(BuildContext context, TutorProvider provider) {
    final columns = Responsive.gridColumns(context);
    final padding = Responsive.screenPadding(context);

    if (columns == 1) {
      return ListView.separated(
        padding: padding,
        itemCount: provider.tutors.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: Responsive.spacing(context, 0.025)),
        itemBuilder: (context, index) =>
            _buildTutorCard(context, provider.tutors[index]),
      );
    }

    return GridView.builder(
      padding: padding,
      itemCount: provider.tutors.length,
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
          _buildTutorCard(context, provider.tutors[index]),
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
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: avatarR,
                        backgroundColor: Colors.white,
                        backgroundImage: tutor.image.isNotEmpty
                            ? CachedNetworkImageProvider(tutor.image)
                            : null,
                        child: tutor.image.isEmpty
                            ? Icon(Icons.person, size: avatarR, color: Colors.grey)
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: nameSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                getAverageRating(tutor.reviews).toStringAsFixed(1),
                                style: TextStyle(
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
                    style: TextStyle(color: Colors.white70, fontSize: bodySize, height: 1.4),
                  ),
                ],
                if (tutor.experience.isNotEmpty && !isGrid) ...[
                  SizedBox(height: Responsive.spacing(context, 0.012)),
                  Text(
                    tutor.experience,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70, fontSize: bodySize, height: 1.4),
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
                    child: Text(
                      'View Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isGrid ? 13 : bodySize + 1,
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
