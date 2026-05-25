import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
import 'package:zindaonlineschool/screens/contact/contact_screen.dart';
import 'package:zindaonlineschool/screens/review/review_screen.dart';
import '../../core/utils/responsive.dart';
import '../../services/home_service.dart';
import '../../widgets/responsive_body.dart';

class TutorDetailsScreen extends StatefulWidget {
  final String tutorId;
  final String token;
  

  const TutorDetailsScreen({
    super.key,
    required this.tutorId,
    required this.token,
  });

  @override
  State<TutorDetailsScreen> createState() => _TutorDetailsScreenState();
}

class _TutorDetailsScreenState extends State<TutorDetailsScreen> {
  final HomeService _service = HomeService();

  Map<String, dynamic>? tutor;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTutorDetails();
  }

  Future<void> fetchTutorDetails() async {
    try {
      final data = await _service.getTutorDetails(widget.tutorId, widget.token);

      setState(() {
        tutor = data;

        
        print("TUTOR DATA: $data");
        print("RATING FROM API: ${data["rating"]}");
      });
    } catch (e) {
      debugPrint("Tutor Details Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteReview() async {
    final success = await _service.deleteReview(
      tutorId: widget.tutorId,
      token: widget.token,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Review deleted")));

        fetchTutorDetails();
      }
    }
  }

  String capitalizeWords(String text) {
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  double _getAverageRating(List reviews) {
    if (reviews.isEmpty) return 0;

    double total = 0;
    int count = 0;

    for (var r in reviews) {
      if (r["rating"] != null) {
        total += (r["rating"]).toDouble();
        count++;
      }
    }

    if (count == 0) return 0;

    return total / count;
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.contentWidth(context);
    final height = Responsive.height(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B023D),

        elevation: 0,

        centerTitle: true,

        title: const Text("Tutor Profile"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tutor == null
          ? const Center(
              child: Text(
                "Tutor Not Found",

                style: TextStyle(color: Colors.white),
              ),
            )
          : ResponsiveBody(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
              padding: Responsive.screenPadding(context),

              child: Column(
                children: [
                  /// TOP CARD
                  /// TOP PROFILE CARD
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(width * 0.05),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),

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

                    child: Column(
                      children: [
                        /// IMAGE
                        Container(
                          padding: const EdgeInsets.all(4),

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            border: Border.all(color: Colors.white24, width: 2),
                          ),

                          child: CircleAvatar(
                            radius: width * 0.16,

                            backgroundColor: Colors.white,

                            backgroundImage:
                                tutor!["photo"] != null &&
                                    tutor!["photo"].toString().isNotEmpty
                                ? NetworkImage(tutor!["photo"])
                                : null,

                            child:
                                tutor!["photo"] == null ||
                                    tutor!["photo"].toString().isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: width * 0.12,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        /// NAME
                        Text(
                          capitalizeWords(tutor!["name"] ?? ""),

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: width * 0.07,

                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        SizedBox(height: height * 0.01),

                        /// QUALIFICATION TEXT
                        Text(
                          tutor!["qualification"] ?? "No Qualification",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white70,

                            fontSize: width * 0.038,

                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: height * 0.012),

                        /// RATING
                        // if (tutor!["rating"] != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: width * 0.05,
                            ),
                            SizedBox(width: width * 0.015),

                            Text(
                              _getAverageRating(
                                tutor!["reviews"] ?? [],
                              ).toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03),

                        /// PROFILE DETAILS SESSION
                        Container(
                          width: double.infinity,

                          padding: EdgeInsets.all(width * 0.045),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),

                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: Column(
                            children: [
                              /// QUALIFICATION
                              buildProfileItem(
                                width,

                                icon: Icons.school_rounded,

                                title: "Qualification",

                                value:
                                    tutor!["qualification"] ?? "Not Available",
                              ),

                              SizedBox(height: height * 0.025),

                              /// COURSE
                              buildProfileItem(
                                width,

                                icon: Icons.menu_book_rounded,

                                title: "Course",

                                value:
                                    tutor!["courseId"]?["name"] ??
                                    "Not Available",
                              ),

                              SizedBox(height: height * 0.025),

                              /// SUBJECTS
                              buildProfileItem(
                                width,

                                icon: Icons.auto_stories_rounded,

                                title: "Subjects",

                                value: (tutor!["subjects"] ?? []).join(", "),
                              ),

                              SizedBox(height: height * 0.025),

                              /// ABOUT
                              buildProfileItem(
                                width,

                                icon: Icons.info_outline_rounded,

                                title: "About",

                                value:
                                    tutor!["about"] != null &&
                                        tutor!["about"].toString().isNotEmpty
                                    ? tutor!["about"]
                                    : "No About Information",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.035),

                  /// REVIEWS
                  /// REVIEWS
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(width * 0.05),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// TITLE
                        Row(
                          children: [
                            Icon(
                              Icons.reviews_rounded,

                              color: Colors.amber,

                              size: width * 0.055,
                            ),

                            SizedBox(width: width * 0.025),

                            Text(
                              "Recent Reviews",

                              style: TextStyle(
                                color: Colors.white,

                                fontWeight: FontWeight.bold,

                                fontSize: width * 0.045,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.025),

                        /// BACKEND REVIEWS
                        if (tutor!["reviews"] != null &&
                            tutor!["reviews"].isNotEmpty)
                          ...List.generate(tutor!["reviews"].length, (index) {
                            final review = tutor!["reviews"][index];

                            return Padding(
                              padding: EdgeInsets.only(bottom: height * 0.018),

                              child: reviewTile(
                                width,

                                review["review"] ?? "",

                                review["studentId"]?["name"] ?? "Student",

                                review["rating"] ?? 0,

                                review["_id"] ?? "",
                              ),
                            );
                          })
                        else
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),

                              child: Text(
                                "No Reviews Yet",

                                style: TextStyle(
                                  color: Colors.white54,

                                  fontSize: width * 0.036,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.035),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: buildButton(
                          width,

                          title: "Write Review",

                          color: const Color(0xFF8B5CF6),

                          onTap: () async {
                            final result = await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => WriteReviewScreen(
                                  tutorId: widget.tutorId,

                                  token: widget.token,
                                ),
                              ),
                            );

                            if (result == true) {
                              fetchTutorDetails();
                            }
                          },
                        ),
                      ),

                      SizedBox(width: width * 0.03),
                     Expanded(
  child: Consumer<ChatProvider>(
    builder: (context, provider, child) {

      
      final isRequested = provider.rooms.any((room) {
        final tutor = room["tutor"] ?? {};

        return tutor["_id"] == widget.tutorId ||
               tutor["id"] == widget.tutorId;
      });

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isRequested ? Colors.grey : Colors.green,
        ),
// onPressed: () async {
//   final res = await context
//       .read<ChatProvider>()
//       .connectTutor(widget.tutorId, widget.token);

//   if (!mounted) return;

//   if (res == null || res is! Map<String, dynamic>) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Request Failed (no response)")),
//     );
//     return;
//   }

//   final roomData = res["room"];

//   if (roomData == null || roomData is! Map<String, dynamic>) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Request Failed (no room)")),
//     );
//     return;
//   }

//   final roomId = roomData["_id"];

//   if (roomId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Room ID missing")),
//     );
//     return;
//   }

//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("Request Sent")),
//   );


// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => ChatRoomScreen(
//       roomId: roomId,
//       token: widget.token,

//       tutor: {
//         "_id": tutor!["_id"],
//         "name": tutor!["name"],
//         "photo": tutor!["photo"],
//         "qualification": tutor!["qualification"],
//       },
//     ),
//   ),
// );
// },

onPressed: () async {
  final chatProvider = context.read<ChatProvider>();

  final res = await chatProvider.connectTutor(
    widget.tutorId,
    widget.token,
  );

  if (!mounted) return;

  if (res == null || res is! Map<String, dynamic>) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request Failed")),
    );
    return;
  }

  final room = res["room"];

  if (room == null || room["_id"] == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Room not created")),
    );
    return;
  }

  final roomId = room["_id"];

  /// ✅ IMPORTANT: refresh rooms before navigation (fix UI state)
  await chatProvider.fetchRooms(widget.token);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Request Sent Successfully")),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ChatRoomScreen(
        roomId: roomId,
        token: widget.token,
        tutor: {
          "_id": widget.tutorId,
          "name": tutor?["name"] ?? "",
          "photo": tutor?["photo"] ?? "",
          "qualification": tutor?["qualification"] ?? "",
        },
      ),
    ),
  );
},

        child: Text(
          isRequested ? "Request Sent" : "Send Request",
        ),
      );
    },
  ),
)
                    ],
                  ),

                  SizedBox(height: height * 0.02),

                  SizedBox(
                    width: double.infinity,

                    child: buildButton(
                      width,

                      title: "Contact Us",

                      color: Colors.green,

                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ContactScreen(),
    ),
  );
},
                    ),
                  ),

                  SizedBox(height: height * 0.04),
                ],
              ),
            ),
            ),
    );
  }

  Widget buildCard(
    double width, {
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(width * 0.05),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: width * 0.055),

              SizedBox(width: width * 0.025),

              Text(
                title,

                style: TextStyle(
                  color: Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: width * 0.045,
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.03),

          Text(
            value.isNotEmpty ? value : "Not Available",

            style: TextStyle(
              color: Colors.white70,

              fontSize: width * 0.036,

              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(
    double width, {
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,

        padding: const EdgeInsets.symmetric(vertical: 16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      onPressed: onTap,

      child: Text(
        title,

        style: TextStyle(
          color: Colors.white,

          fontWeight: FontWeight.bold,

          fontSize: width * 0.036,
        ),
      ),
    );
  }

  Widget buildProfileItem(
    double width, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(width * 0.04),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),

        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: Colors.amber, size: width * 0.055),

          SizedBox(width: width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontSize: width * 0.04,
                  ),
                ),

                SizedBox(height: width * 0.02),

                Text(
                  value,

                  style: TextStyle(
                    color: Colors.white70,

                    fontSize: width * 0.035,

                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewTile(
    double width,

    String review,

    String studentName,

    dynamic rating,

    String reviewId,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// STAR + ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: List.generate(rating.toInt(), (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 4),

                    child: Icon(Icons.star, color: Colors.amber, size: 18),
                  );
                }),
              ),

              PopupMenuButton(
                color: const Color(0xFF1E1B4B),

                icon: const Icon(Icons.more_vert, color: Colors.white),

                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "edit",

                    child: Text("Edit Review"),
                  ),

                  const PopupMenuItem(
                    value: "delete",

                    child: Text("Delete Review"),
                  ),
                ],

                onSelected: (value) {
                  if (value == "edit") {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => WriteReviewScreen(
                          tutorId: widget.tutorId,

                          token: widget.token,

                          reviewId: reviewId,

                          existingReview: review,

                          existingRating: rating.toDouble(),
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        fetchTutorDetails();
                      }
                    });
                  }

                  if (value == "delete") {
                    deleteReview();
                  }
                },
              ),
            ],
          ),

          SizedBox(height: width * 0.03),

          /// REVIEW TEXT
          Text(
            review,

            style: TextStyle(
              color: Colors.white70,

              fontSize: width * 0.034,

              height: 1.5,
            ),
          ),

          SizedBox(height: width * 0.03),

          /// USERNAME
          Text(
            studentName,

            style: TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.bold,

              fontSize: width * 0.033,
            ),
          ),
        ],
      ),
    );
  }
}
