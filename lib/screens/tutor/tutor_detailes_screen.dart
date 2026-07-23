// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/core/constants/app_colors.dart';
// import 'package:zindaonlineschool/core/constants/app_gaps.dart';
// import 'package:zindaonlineschool/core/constants/app_space.dart';
// import 'package:zindaonlineschool/core/constants/app_textstyle.dart';
// import 'package:zindaonlineschool/providers/auth_provider.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
// import 'package:zindaonlineschool/screens/contact/contact_screen.dart';
// import 'package:zindaonlineschool/screens/review/review_screen.dart';
// import '../../core/utils/responsive.dart';
// import '../../services/home_service.dart';
// import '../../widgets/responsive_body.dart';

// class TutorDetailsScreen extends StatefulWidget {
//   final String tutorId;
//   final String token;

//   const TutorDetailsScreen({
//     super.key,
//     required this.tutorId,
//     required this.token,
//   });

//   @override
//   State<TutorDetailsScreen> createState() => _TutorDetailsScreenState();
// }

// class _TutorDetailsScreenState extends State<TutorDetailsScreen> {
//   final HomeService _service = HomeService();
//   Map<String, dynamic>? tutor;
//   bool isLoading = true;
//   bool isSendingRequest = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       if (!mounted) return;
//       await context.read<AuthProvider>().loadUser();
//       fetchTutorDetails();
//     });
//   }

//   Future<void> fetchTutorDetails() async {
//     try {
//       final data = await _service.getTutorDetails(widget.tutorId, widget.token);
//       if (mounted) {
//         setState(() {
//           tutor = data;
//           debugPrint("RATING FROM API: ${data["rating"]}");
//         });
//       }
//     } catch (e) {
//       debugPrint("Tutor Details Error: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> deleteReview() async {
//     final success = await _service.deleteReview(
//       tutorId: widget.tutorId,
//       token: widget.token,
//     );

//     if (success && mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Review deleted")));
//       fetchTutorDetails();
//     }
//   }

//   String capitalizeWords(String text) {
//     if (text.isEmpty) return '';
//     return text
//         .split(' ')
//         .map(
//           (word) => word.isNotEmpty
//               ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//               : '',
//         )
//         .join(' ');
//   }

//   double _getAverageRating(List reviews) {
//     if (reviews.isEmpty) return 0;

//     double total = 0;
//     int count = 0;

//     for (var review in reviews) {
//       if (review["rating"] != null) {
//         total += review["rating"].toDouble();
//         count++;
//       }
//     }

//     return count == 0 ? 0 : total / count;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = Responsive.contentWidth(context);
//     final height = Responsive.height(context);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: true,
//         title: Text("Tutor Profile", style: AppTextStyles.subHeading),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : tutor == null
//           ? Center(
//               child: Text(
//                 "Tutor Not Found",
//                 style: AppTextStyles.body.copyWith(color: AppColors.white),
//               ),
//             )
//           : ResponsiveBody(
//               padding: EdgeInsets.zero,
//               child: SingleChildScrollView(
//                 padding: Responsive.screenPadding(context),
//                 child: Column(
//                   children: [
//                     /// TOP PROFILE CARD
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(AppGaps.padding),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(
//                           AppGaps.radius * 1.5,
//                         ),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             AppColors.cardFill,
//                             Color(0xFF1E145A),
//                           ], // Consider moving 0xFF1E145A to AppColors
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.black.withAlpha(64),
//                             blurRadius: 15,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           /// IMAGE
//                           Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: AppColors.white.withAlpha(64),
//                                 width: 2,
//                               ),
//                             ),
//                             child: CircleAvatar(
//                               radius: width * 0.16,
//                               backgroundColor: AppColors.white,
//                               backgroundImage:
//                                   tutor!["photo"] != null &&
//                                       tutor!["photo"].toString().isNotEmpty
//                                   ? NetworkImage(tutor!["photo"])
//                                   : null,
//                               child:
//                                   tutor!["photo"] == null ||
//                                       tutor!["photo"].toString().isEmpty
//                                   ? Icon(
//                                       Icons.person,
//                                       size: width * 0.12,
//                                       color: AppColors.grey,
//                                     )
//                                   : null,
//                             ),
//                           ),
//                           AppSpacing.h20,

//                           /// NAME
//                           Text(
//                             capitalizeWords(tutor!["name"] ?? ""),
//                             textAlign: TextAlign.center,
//                             style: AppTextStyles.heading.copyWith(
//                               fontSize: width * 0.065,
//                             ),
//                           ),
//                           AppSpacing.h10,

//                           /// QUALIFICATION TEXT
//                           Text(
//                             tutor!["qualification"] ?? "No Qualification",
//                             textAlign: TextAlign.center,
//                             style: AppTextStyles.body.copyWith(
//                               color: Colors.white70,
//                               fontSize: width * 0.038,
//                               height: 1.5,
//                             ),
//                           ),
//                           AppSpacing.h10,

//                           /// RATING
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.star_rounded,
//                                 color: Colors.amber,
//                                 size: width * 0.05,
//                               ),
//                               AppSpacing.w5,
//                               Text(
//                                 _getAverageRating(
//                                   tutor!["reviews"] ?? [],
//                                 ).toStringAsFixed(1),
//                                 style: AppTextStyles.body.copyWith(
//                                   color: AppColors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           AppSpacing.h25,

//                           /// PROFILE DETAILS SESSION
//                           Container(
//                             width: double.infinity,
//                             padding: EdgeInsets.all(width * 0.045),
//                             decoration: BoxDecoration(
//                               // color: AppColors.white.withAlpha(128),
//                               color: AppColors.cardFill,
//                               borderRadius: BorderRadius.circular(
//                                 AppGaps.radius,
//                               ),
//                             ),
//                             child: Column(
//                               children: [
//                                 buildProfileItem(
//                                   width,
//                                   icon: Icons.school_rounded,
//                                   title: "Qualification",
//                                   value:
//                                       tutor!["qualification"] ??
//                                       "Not Available",
//                                 ),
//                                 AppSpacing.h15,
//                                 buildProfileItem(
//                                   width,
//                                   icon: Icons.menu_book_rounded,
//                                   title: "Course",
//                                   value:
//                                       tutor!["courseId"]?["name"] ??
//                                       "Not Available",
//                                 ),
//                                 AppSpacing.h15,
//                                 buildProfileItem(
//                                   width,
//                                   icon: Icons.auto_stories_rounded,
//                                   title: "Subjects",
//                                   value: (tutor!["subjects"] ?? []).join(", "),
//                                 ),
//                                 AppSpacing.h15,
//                                 buildProfileItem(
//                                   width,
//                                   icon: Icons.info_outline_rounded,
//                                   title: "About",
//                                   value:
//                                       tutor!["about"] != null &&
//                                           tutor!["about"].toString().isNotEmpty
//                                       ? tutor!["about"]
//                                       : "No About Information",
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     AppSpacing.h30,

//                     /// REVIEWS CONTAINER
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(width * 0.05),
//                       decoration: BoxDecoration(
//                         color: AppColors.cardFill,
//                         borderRadius: BorderRadius.circular(AppGaps.radius),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.reviews_rounded,
//                                 color: AppColors.secondary,
//                                 size: width * 0.055,
//                               ),
//                               AppSpacing.w10,
//                               Text(
//                                 "Recent Reviews",
//                                 style: AppTextStyles.subHeading,
//                               ),
//                             ],
//                           ),
//                           AppSpacing.h20,
//                           if (tutor!["reviews"] != null &&
//                               tutor!["reviews"].isNotEmpty)
//                             ...List.generate(tutor!["reviews"].length, (index) {
//                               final review = tutor!["reviews"][index];
//                               return Padding(
//                                 padding: EdgeInsets.only(
//                                   bottom: height * 0.018,
//                                 ),
//                                 child: reviewTile(
//                                   width,
//                                   review["review"] ?? "",
//                                   review["studentId"]?["name"] ?? "Student",
//                                   review["rating"] ?? 0,
//                                   review["_id"] ?? "",
//                                   review["studentId"]?["_id"] ?? "",
//                                 ),
//                               );
//                             })
//                           else
//                             Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: height * 0.02,
//                                 ),
//                                 child: Text(
//                                   "No Reviews Yet",
//                                   style: AppTextStyles.small,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     AppSpacing.h30,

//                     /// ACTION BUTTONS
//                     Row(
//                       children: [
//                         Expanded(
//                           child: buildButton(
//                             width,
//                             title: "Write Review",
//                             color: AppColors.primary,
//                             onTap: () async {
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => WriteReviewScreen(
//                                     tutorId: widget.tutorId,
//                                     token: widget.token,
//                                   ),
//                                 ),
//                               );
//                               if (result == true) {
//                                 fetchTutorDetails();
//                               }
//                             },
//                           ),
//                         ),
//                         AppSpacing.w15,
//                         Expanded(
//                           child: Consumer<ChatProvider>(
//                             builder: (context, provider, child) {
//                               final isRequested = provider.rooms.any((room) {
//                                 final t = room["tutor"] ?? {};
//                                 return t["_id"] == widget.tutorId ||
//                                     t["id"] == widget.tutorId;
//                               });

//                               return ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: isRequested
//                                       ? AppColors.grey
//                                       : AppColors.secondary,
//                                   minimumSize: const Size(
//                                     double.infinity,
//                                     AppGaps.buttonHeight,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppGaps.radius,
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: isSendingRequest
//                                     ? null
//                                     : () async {
//                                         setState(() {
//                                           isSendingRequest = true;
//                                         });

//                                         try {
//                                           // Read provider state safely before the async gap
//                                           final chatProvider = context
//                                               .read<ChatProvider>();
//                                           final res = await chatProvider
//                                               .connectTutor(
//                                                 widget.tutorId,
//                                                 widget.token,
//                                               );

//                                           if (!mounted) return;

//                                           if (res == null ||
//                                               res is! Map<String, dynamic>) {
//                                             throw Exception("Request failed");
//                                           }

//                                           final room = res["room"];
//                                           final roomId = room["_id"];

//                                           Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (_) => ChatRoomScreen(
//                                                 roomId: roomId,
//                                                 token: widget.token,
//                                                 tutor: {
//                                                   "_id": widget.tutorId,
//                                                   "name": tutor?["name"] ?? "",
//                                                   "photo":
//                                                       tutor?["photo"] ?? "",
//                                                   "qualification":
//                                                       tutor?["qualification"] ??
//                                                       "",
//                                                 },
//                                                 currentUserId: '',

//                                               ),
//                                             ),
//                                           );
//                                           chatProvider.fetchRooms(widget.token);
//                                         } catch (e) {
//                                           if (mounted) {
//                                             ScaffoldMessenger.of(
//                                               context,
//                                             ).showSnackBar(
//                                               SnackBar(
//                                                 content: Text(e.toString()),
//                                               ),
//                                             );
//                                           }
//                                         } finally {
//                                           if (mounted) {
//                                             setState(() {
//                                               isSendingRequest = false;
//                                             });
//                                           }
//                                         }
//                                       },
//                                 child: isSendingRequest
//                                     ? const SizedBox(
//                                         height: 18,
//                                         width: 18,
//                                         child: CircularProgressIndicator(
//                                           color: AppColors.white,
//                                           strokeWidth: 2,
//                                         ),
//                                       )
//                                     : Text(
//                                         isRequested
//                                             ? "Request Sent"
//                                             : "Send Request",
//                                         style: AppTextStyles.button.copyWith(
//                                           color: isRequested
//                                               ? AppColors.white
//                                               : AppColors.background,
//                                         ),
//                                       ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     AppSpacing.h15,
//                     SizedBox(
//                       width: double.infinity,
//                       child: buildButton(
//                         width,
//                         title: "Contact Us",
//                         color: Colors.green,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ContactScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     AppSpacing.h40,
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildButton(
//     double width, {
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         minimumSize: const Size(double.infinity, AppGaps.buttonHeight),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppGaps.radius),
//         ),
//       ),
//       onPressed: onTap,
//       child: Text(title, style: AppTextStyles.button),
//     );
//   }

//   Widget buildProfileItem(
//     double width, {
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(AppGaps.padding),
//       decoration: BoxDecoration(
//         color: AppColors.white.withAlpha(10),
//         borderRadius: BorderRadius.circular(AppGaps.radius),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.secondary, size: width * 0.055),
//           AppSpacing.w15,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: AppTextStyles.body.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.white,
//                   ),
//                 ),
//                 AppSpacing.h5,
//                 Text(
//                   value,
//                   style: AppTextStyles.body.copyWith(
//                     fontSize: width * 0.035,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget reviewTile(
//     double width,
//     String review,
//     String studentName,
//     dynamic rating,
//     String reviewId,
//     String reviewOwnerId,
//   ) {
//     // listen: false used here to avoid unnecessary list rebuild issues inside widget methods
//     final myId = Provider.of<AuthProvider>(context, listen: false).userId;
//     final isOwner =
//         myId != null && myId.isNotEmpty && myId.trim() == reviewOwnerId.trim();

//     return Container(
//       padding: EdgeInsets.all(AppGaps.padding),
//       decoration: BoxDecoration(
//         color: AppColors.white.withAlpha(8),
//         borderRadius: BorderRadius.circular(AppGaps.radius),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: List.generate(rating.toInt(), (index) {
//                   return const Padding(
//                     padding: EdgeInsets.only(right: 4),
//                     child: Icon(
//                       Icons.star,
//                       color: AppColors.secondary,
//                       size: 18,
//                     ),
//                   );
//                 }),
//               ),
//               if (isOwner)
//                 PopupMenuButton(
//                   color: AppColors.appBarFill,
//                   icon: const Icon(Icons.more_vert, color: AppColors.white),
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: "edit",
//                       child: Text(
//                         "Edit Review",
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: "delete",
//                       child: Text(
//                         "Delete Review",
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                     ),
//                   ],
//                   onSelected: (value) {
//                     if (value == "edit") {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => WriteReviewScreen(
//                             tutorId: widget.tutorId,
//                             token: widget.token,
//                             reviewId: reviewId,
//                             existingReview: review,
//                             existingRating: rating.toDouble(),
//                           ),
//                         ),
//                       ).then((value) {
//                         if (value == true) {
//                           fetchTutorDetails();
//                         }
//                       });
//                     }
//                     if (value == "delete") {
//                       deleteReview();
//                     }
//                   },
//                 ),
//             ],
//           ),
//           AppSpacing.h10,
//           Text(
//             review,
//             style: AppTextStyles.body.copyWith(
//               fontSize: width * 0.034,
//               height: 1.5,
//             ),
//           ),
//           AppSpacing.h10,
//           Text(
//             studentName,
//             style: AppTextStyles.body.copyWith(
//               color: AppColors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: width * 0.033,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zindaonlineschool/core/constants/app_colors.dart';
import 'package:zindaonlineschool/core/constants/app_gaps.dart';
import 'package:zindaonlineschool/core/constants/app_space.dart';
import 'package:zindaonlineschool/core/constants/app_textstyle.dart';
import 'package:zindaonlineschool/providers/auth_provider.dart';
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
  bool isSendingRequest = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await context.read<AuthProvider>().loadUser();
      if (!mounted) return;
      context.read<ChatProvider>().fetchAssignedTutors(
        widget.token,
      ); // <-- must be here, not outside
      fetchTutorDetails();
    });
  }

  Future<void> fetchTutorDetails() async {
    try {
      final data = await _service.getTutorDetails(widget.tutorId, widget.token);
      if (mounted) {
        setState(() {
          tutor = data;
          debugPrint("RATING FROM API: ${data["rating"]}");
        });
      }
    } catch (e) {
      debugPrint("Tutor Details Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _callTutor(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open dialer")));
      }
    }
  }

  Future<void> deleteReview() async {
    final success = await _service.deleteReview(
      tutorId: widget.tutorId,
      token: widget.token,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Review deleted")));
      fetchTutorDetails();
    }
  }

  String capitalizeWords(String text) {
    if (text.isEmpty) return '';
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

    for (var review in reviews) {
      if (review["rating"] != null) {
        total += review["rating"].toDouble();
        count++;
      }
    }

    return count == 0 ? 0 : total / count;
  }

  /// Whether the current user already has an active/pending chat room tied
  /// to this tutor. Checked defensively across a few possible backend
  /// shapes since a "pending admin review" room may not yet have
  /// room["tutor"] populated — only the requested id in the connect card
  /// (or a dedicated field, if your API exposes one).
  ///
  /// TODO(backend): expose an explicit `room.requestedTutorId` or
  /// `room.status` field so this doesn't have to guess across shapes.
  bool _hasExistingRequest(ChatProvider provider) {
    return provider.rooms.any((room) {
      final t = room["tutor"] ?? room["assignedTutor"] ?? {};
      if (t is Map &&
          (t["_id"] == widget.tutorId || t["id"] == widget.tutorId)) {
        return true;
      }
      if (room["requestedTutorId"] == widget.tutorId) return true;

      // Fallback: check the last connect_card in the room, if the provider
      // exposes recent messages/lastConnectCard on the room summary.
      final card = room["connectCard"] ?? room["lastConnectCard"];
      if (card is Map &&
          (card["tuterId"] == widget.tutorId ||
              card["tutorId"] == widget.tutorId)) {
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.contentWidth(context);
    final height = Responsive.height(context);
    final isAssigned = context.watch<ChatProvider>().isTutorAssigned(
      widget.tutorId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text("Tutor Profile", style: AppTextStyles.subHeading),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tutor == null
          ? Center(
              child: Text(
                "Tutor Not Found",
                style: AppTextStyles.body.copyWith(color: AppColors.white),
              ),
            )
          : ResponsiveBody(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: Responsive.screenPadding(context),
                child: Column(
                  children: [
                    /// TOP PROFILE CARD
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppGaps.padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppGaps.radius * 1.5,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.cardFill,
                            Color(0xFF1E145A),
                          ], // Consider moving 0xFF1E145A to AppColors
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withAlpha(64),
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
                              border: Border.all(
                                color: AppColors.white.withAlpha(64),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: width * 0.16,
                              backgroundColor: AppColors.white,
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
                                      color: AppColors.grey,
                                    )
                                  : null,
                            ),
                          ),
                          AppSpacing.h20,

                          /// NAME
                          Text(
                            capitalizeWords(tutor!["name"] ?? ""),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading.copyWith(
                              fontSize: width * 0.065,
                            ),
                          ),
                          AppSpacing.h10,

                          /// QUALIFICATION TEXT
                          Text(
                            tutor!["qualification"] ?? "No Qualification",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                              fontSize: width * 0.038,
                              height: 1.5,
                            ),
                          ),
                          AppSpacing.h10,

                          /// RATING
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: width * 0.05,
                              ),
                              AppSpacing.w5,
                              Text(
                                _getAverageRating(
                                  tutor!["reviews"] ?? [],
                                ).toStringAsFixed(1),
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.h25,

                          /// PROFILE DETAILS SESSION
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(width * 0.045),
                            decoration: BoxDecoration(
                              // color: AppColors.white.withAlpha(128),
                              color: AppColors.cardFill,
                              borderRadius: BorderRadius.circular(
                                AppGaps.radius,
                              ),
                            ),
                            child: Column(
                              children: [
                                buildProfileItem(
                                  width,
                                  icon: Icons.school_rounded,
                                  title: "Qualification",
                                  value:
                                      tutor!["qualification"] ??
                                      "Not Available",
                                ),
                                AppSpacing.h15,
                                buildProfileItem(
                                  width,
                                  icon: Icons.menu_book_rounded,
                                  title: "Course",
                                  value:
                                      tutor!["courseId"]?["name"] ??
                                      "Not Available",
                                ),
                                AppSpacing.h15,
                                buildProfileItem(
                                  width,
                                  icon: Icons.auto_stories_rounded,
                                  title: "Subjects",
                                  value: (tutor!["subjects"] ?? []).join(", "),
                                ),
                                AppSpacing.h15,
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
                                if (isAssigned &&
                                    ((tutor!["phone"] ?? "")
                                            .toString()
                                            .isNotEmpty ||
                                        (tutor!["email"] ?? "")
                                            .toString()
                                            .isNotEmpty)) ...[
                                  AppSpacing.h15,
                                  if ((tutor!["phone"] ?? "")
                                      .toString()
                                      .isNotEmpty)
                                    buildProfileItem(
                                      width,
                                      icon: Icons.phone_rounded,
                                      title: "Phone",
                                      value: tutor!["phone"].toString(),
                                    ),
                                  if ((tutor!["email"] ?? "")
                                      .toString()
                                      .isNotEmpty) ...[
                                    AppSpacing.h15,
                                    buildProfileItem(
                                      width,
                                      icon: Icons.email_rounded,
                                      title: "Email",
                                      value: tutor!["email"].toString(),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.h30,

                    /// REVIEWS CONTAINER
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: AppColors.cardFill,
                        borderRadius: BorderRadius.circular(AppGaps.radius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.reviews_rounded,
                                color: AppColors.secondary,
                                size: width * 0.055,
                              ),
                              AppSpacing.w10,
                              Text(
                                "Recent Reviews",
                                style: AppTextStyles.subHeading,
                              ),
                            ],
                          ),
                          AppSpacing.h20,
                          if (tutor!["reviews"] != null &&
                              tutor!["reviews"].isNotEmpty)
                            ...List.generate(tutor!["reviews"].length, (index) {
                              final review = tutor!["reviews"][index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: height * 0.018,
                                ),
                                child: reviewTile(
                                  width,
                                  review["review"] ?? "",
                                  review["studentId"]?["name"] ?? "Student",
                                  review["rating"] ?? 0,
                                  review["_id"] ?? "",
                                  review["studentId"]?["_id"] ?? "",
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
                                  style: AppTextStyles.small,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppSpacing.h30,

                    /// ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: buildButton(
                            width,
                            title: "Write Review",
                            color: AppColors.primary,
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
                        AppSpacing.w15,

                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final isRequested = _hasExistingRequest(
                                context.watch<ChatProvider>(),
                              );

                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isAssigned
                                      ? const Color(0xFF8B5CF6)
                                      : (isRequested
                                            ? AppColors.grey
                                            : AppColors.secondary),
                                  minimumSize: const Size(
                                    double.infinity,
                                    AppGaps.buttonHeight,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppGaps.radius,
                                    ),
                                  ),
                                ),
                                onPressed:
                                    isSendingRequest ||
                                        (isRequested && !isAssigned)
                                    ? null
                                    : () async {
                                        setState(() => isSendingRequest = true);
                                        try {
                                          final chatProvider = context
                                              .read<ChatProvider>();
                                          final authProvider = context
                                              .read<AuthProvider>();

                                          if (isAssigned) {
                                            final room = await chatProvider
                                                .getStudentTutorRoom(
                                                  widget.tutorId,
                                                  widget.token,
                                                );
                                            if (!mounted) return;
                                            if (room == null ||
                                                room["_id"] == null) {
                                              throw Exception(
                                                "Could not open tutor chat",
                                              );
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ChatRoomScreen(
                                                  roomId: room["_id"]
                                                      .toString(),
                                                  token: widget.token,
                                                  tutor: {
                                                    "_id": widget.tutorId,
                                                    "name":
                                                        tutor?["name"] ?? "",
                                                    "photo":
                                                        tutor?["photo"] ?? "",
                                                    "qualification":
                                                        tutor?["qualification"] ??
                                                        "",
                                                  },
                                                  currentUserId:
                                                      authProvider.userId
                                                          ?.toString() ??
                                                      '',
                                                ),
                                              ),
                                            );
                                          } else {
                                            final res = await chatProvider
                                                .connectTutor(
                                                  widget.tutorId,
                                                  widget.token,
                                                );
                                            if (!mounted) return;
                                            if (res == null ||
                                                res is! Map<String, dynamic>) {
                                              throw Exception("Request failed");
                                            }
                                            final room = res["room"];
                                            if (room == null ||
                                                room["_id"] == null) {
                                              throw Exception(
                                                "Unexpected response from server",
                                              );
                                            }
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ChatRoomScreen(
                                                  roomId: room["_id"],
                                                  token: widget.token,
                                                  tutor: {
                                                    "_id": widget.tutorId,
                                                    "name":
                                                        tutor?["name"] ?? "",
                                                    "photo":
                                                        tutor?["photo"] ?? "",
                                                    "qualification":
                                                        tutor?["qualification"] ??
                                                        "",
                                                  },
                                                  currentUserId:
                                                      authProvider.userId
                                                          ?.toString() ??
                                                      '',
                                                ),
                                              ),
                                            );
                                            chatProvider.fetchRooms(
                                              widget.token,
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                              ),
                                            );
                                          }
                                        } finally {
                                          if (mounted)
                                            setState(
                                              () => isSendingRequest = false,
                                            );
                                        }
                                      },

                                child: isSendingRequest
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        isAssigned
                                            ? "Chat with Tutor"
                                            : (isRequested
                                                  ? "Request Sent"
                                                  : "Send Request"),
                                        style: AppTextStyles.button.copyWith(
                                          color: isAssigned || isRequested
                                              ? AppColors.white
                                              : AppColors.background,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h15,

                    SizedBox(
                      width: double.infinity,
                      child: Builder(
                        builder: (context) {
                          final tutorPhone = (tutor?["phone"] ?? "")
                              .toString()
                              .trim();
                          final canCallTutor =
                              isAssigned && tutorPhone.isNotEmpty;

                          return buildButton(
                            width,
                            title: canCallTutor ? "Call Tutor" : "Contact Us",
                            color: canCallTutor
                                ? const Color(0xFF3B82F6)
                                : Colors.green,
                            onTap: canCallTutor
                                ? () => _callTutor(tutorPhone)
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ContactScreen(),
                                      ),
                                    );
                                  },
                          );
                        },
                      ),
                    ),
                    AppSpacing.h40,
                  ],
                ),
              ),
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
        minimumSize: const Size(double.infinity, AppGaps.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppGaps.radius),
        ),
      ),
      onPressed: onTap,
      child: Text(title, style: AppTextStyles.button),
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
      padding: EdgeInsets.all(AppGaps.padding),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(AppGaps.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: width * 0.055),
          AppSpacing.w15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.h5,
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontSize: width * 0.035,
                    height: 1.5,
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
    String reviewOwnerId,
  ) {
    // listen: false used here to avoid unnecessary list rebuild issues inside widget methods
    final myId = Provider.of<AuthProvider>(context, listen: false).userId;
    final isOwner =
        myId != null && myId.isNotEmpty && myId.trim() == reviewOwnerId.trim();

    return Container(
      padding: EdgeInsets.all(AppGaps.padding),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(AppGaps.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(rating.toInt(), (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.star,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                  );
                }),
              ),
              if (isOwner)
                PopupMenuButton(
                  color: AppColors.appBarFill,
                  icon: const Icon(Icons.more_vert, color: AppColors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "edit",
                      child: Text(
                        "Edit Review",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Text(
                        "Delete Review",
                        style: TextStyle(color: AppColors.white),
                      ),
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
          AppSpacing.h10,
          Text(
            review,
            style: AppTextStyles.body.copyWith(
              fontSize: width * 0.034,
              height: 1.5,
            ),
          ),
          AppSpacing.h10,
          Text(
            studentName,
            style: AppTextStyles.body.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.033,
            ),
          ),
        ],
      ),
    );
  }
}
