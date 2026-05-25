// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/providers/feedback_provider.dart';

// class FeedbackScreen extends StatefulWidget {
//   final String token;

//   const FeedbackScreen({super.key, required this.token});

//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   final TextEditingController controller = TextEditingController();
//   int rating = 0;
//   String? editId;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<FeedbackProvider>().fetchMyFeedback(widget.token);
//     });
//   }

//   void submitFeedback() async {
//     final provider = context.read<FeedbackProvider>();

//     if (editId == null) {
//       await provider.sendFeedback(
//         token: widget.token,
//         message: controller.text,
//         rating: rating,
//       );
//     } else {
//       await provider.updateFeedback(
//         token: widget.token,
//         id: editId!,
//         message: controller.text,
//         rating: rating,
//       );
//     }

//     controller.clear();
//     rating = 0;
//     editId = null;

//     setState(() {});
//     provider.fetchMyFeedback(widget.token);
//   }

//   Widget buildStars() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(5, (index) {
//         return IconButton(
//           onPressed: () {
//             setState(() {
//               rating = index + 1;
//             });
//           },
//           icon: Icon(
//             index < rating ? Icons.star : Icons.star_border,
//             color: Colors.amber,
//             size: 28,
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<FeedbackProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),

//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B023D),
//         title: const Text("Feedback"),
//         centerTitle: true,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// ✨ INPUT CARD
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white10,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: controller,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       hintText: "Write your feedback...",
//                       hintStyle: TextStyle(color: Colors.white54),
//                       border: InputBorder.none,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   buildStars(),

//                   const SizedBox(height: 10),

//                   /// SUBMIT BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       onPressed: submitFeedback,
//                       child: Text(
//                         editId == null ? "Submit Feedback" : "Update Feedback",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// LIST TITLE
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "All Feedback",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             /// LIST
//             Expanded(
//               child: provider.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: provider.allFeedback.length,
//                       itemBuilder: (context, index) {
//                         final item = provider.allFeedback[index];

//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 16),
//                           padding: const EdgeInsets.all(16),

//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.white.withOpacity(.08),
//                                 Colors.white.withOpacity(.03),
//                               ],
//                             ),

//                             borderRadius: BorderRadius.circular(22),

//                             border: Border.all(color: Colors.white12),
//                           ),

//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,

//                             children: [
//                               /// HEADER
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 22,
//                                     backgroundColor: Colors.purple.shade300,

//                                     child: Text(
//                                       item["studentId"]?["name"]
//                                               ?.substring(0, 1)
//                                               .toUpperCase() ??
//                                           "S",

//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),

//                                   const SizedBox(width: 12),

//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,

//                                       children: [
//                                         Text(
//                                           item["studentId"]?["name"] ??
//                                               "Student",

//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                           ),
//                                         ),

//                                         const SizedBox(height: 3),

//                                         Text(
//                                           "Student Feedback",
//                                           style: TextStyle(
//                                             color: Colors.white.withOpacity(.5),
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               const SizedBox(height: 16),

//                               /// MESSAGE
//                               Text(
//                                 item["message"] ?? "",

//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   height: 1.5,
//                                 ),
//                               ),

//                               const SizedBox(height: 14),

//                               /// STARS
//                               Row(
//                                 children: List.generate(5, (i) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 4),

//                                     child: Icon(
//                                       i < (item["rating"] ?? 0)
//                                           ? Icons.star_rounded
//                                           : Icons.star_border_rounded,

//                                       color: Colors.amber,
//                                       size: 20,
//                                     ),
//                                   );
//                                 }),
//                               ),

//                               const SizedBox(height: 14),

//                               /// ACTIONS
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,

//                                 children: [
//                                   /// EDIT
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white10,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),

//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.edit,
//                                         color: Colors.white,
//                                       ),

//                                       onPressed: () {
//                                         controller.text = item["message"];

//                                         rating = item["rating"];

//                                         editId = item["_id"];

//                                         setState(() {});
//                                       },
//                                     ),
//                                   ),

//                                   const SizedBox(width: 10),

//                                   /// DELETE
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red.withOpacity(.15),

//                                       borderRadius: BorderRadius.circular(10),
//                                     ),

//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.delete,
//                                         color: Colors.redAccent,
//                                       ),

//                                       onPressed: () async {
//                                         await context
//                                             .read<FeedbackProvider>()
//                                             .deleteFeedback(
//                                               token: widget.token,
//                                               id: item["_id"],
//                                             );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/feedback_provider.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class FeedbackScreen extends StatefulWidget {
  final String token;

  const FeedbackScreen({super.key, required this.token});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController controller = TextEditingController();

  int rating = 0;
  String? editId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackProvider>().fetchMyFeedback(widget.token);
    });
  }

  Future<void> submitFeedback() async {
    if (controller.text.trim().isEmpty || rating == 0) {
      showSnackBar("Please enter feedback & rating", Colors.red);
      return;
    }

    final provider = context.read<FeedbackProvider>();
    bool success;

    if (editId != null) {
      await provider.deleteFeedback(token: widget.token, id: editId!);
      editId = null;
    }

    success = await provider.sendFeedback(
      token: widget.token,
      message: controller.text,
      rating: rating,
    );

    if (success) {
      showSnackBar(
        editId == null ? "Submitted successfully" : "Updated successfully",
        Colors.green,
      );
    } else {
      showSnackBar("Failed", Colors.red);
      return;
    }

    controller.clear();
    rating = 0;
    setState(() {});
  }

  void showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => setState(() => rating = i + 1),
          child: Icon(
            i < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedbackProvider>();
    final feedbackList = provider.allFeedback;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F2A),
        elevation: 0,
        title: const Text("Feedback"),
        centerTitle: true,
      ),

      body: ResponsiveBody(
        child: Column(
          children: [
            /// INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),

              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write your feedback...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildStars(),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: submitFeedback,
                      child: Text(
                        editId == null ? "Submit Feedback" : "Update Feedback",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Reviews",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : feedbackList.isEmpty
                  ? const Center(
                      child: Text(
                        "No feedback yet",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: feedbackList.length,
                      itemBuilder: (context, index) {
                        final item = feedbackList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(color: Colors.white10),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(
                                      (item["studentId"]?["name"] ?? "S")
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      item["studentId"]?["name"] ?? "Student",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                item["message"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < (item["rating"] ?? 0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        controller.text = item["message"] ?? "";
                                        rating = item["rating"] ?? 0;
                                        editId = item["_id"];
                                      });
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      await context
                                          .read<FeedbackProvider>()
                                          .deleteFeedback(
                                            token: widget.token,
                                            id: item["_id"],
                                          );

                                      showSnackBar("Deleted", Colors.red);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
