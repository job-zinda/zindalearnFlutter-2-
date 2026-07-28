
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
      centerTitle: true,
      title: const Text("Feedback & Reviews"),
    ),

    body: ResponsiveBody(
      child: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.indigo.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),

            child: const Column(
              children: [
                Icon(
                  Icons.reviews,
                  size: 55,
                  color: Colors.white,
                ),

                SizedBox(height: 12),

                Text(
                  "Feedback & Reviews",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Share your learning experience with us",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// FEEDBACK FORM CARD
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),

              border: Border.all(
                color: Colors.white12,
              ),
            ),

            child: Column(
              children: [

                TextField(
                  controller: controller,
                  maxLines: 4,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Write your feedback...",
                    hintStyle: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.5),
                    ),

                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Colors.white.withOpacity(0.05),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                buildStars(),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: submitFeedback,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: Text(
                      editId == null
                          ? "Submit Feedback"
                          : "Update Feedback",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              const Icon(
                Icons.rate_review,
                color: Colors.amber,
              ),

              const SizedBox(width: 8),

              Text(
                "Your Reviews (${feedbackList.length})",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Expanded(
            child: provider.isLoading

                ? const Center(
                    child: CircularProgressIndicator(),
                  )

                : feedbackList.isEmpty

                    ? const Center(
                        child: Text(
                          "No feedback yet",
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      )

                    : ListView.builder(
                        itemCount: feedbackList.length,

                        itemBuilder: (context, index) {

                          final item = feedbackList[index];

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 14,
                            ),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // ignore: deprecated_member_use
                                  Colors.white.withOpacity(0.08),
                                  // ignore: deprecated_member_use
                                  Colors.white.withOpacity(0.04),
                                ],
                              ),

                              borderRadius:
                                  BorderRadius.circular(20),

                              border: Border.all(
                                color: Colors.white10,
                              ),
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Row(
                                  children: [

                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          Colors.deepPurple,

                                      child: Text(
                                        (item["studentId"]?["name"] ??
                                                "S")
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase(),

                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Text(
                                        item["studentId"]
                                                ?["name"] ??
                                            "Student",

                                        style:
                                            const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color: Colors.amber
                                            // ignore: deprecated_member_use
                                            .withOpacity(
                                                0.15),

                                        borderRadius:
                                            BorderRadius
                                                .circular(20),
                                      ),

                                      child: Text(
                                        "${item["rating"]}/5",

                                        style:
                                            const TextStyle(
                                          color: Colors.amber,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  item["message"] ?? "",

                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children:
                                      List.generate(5, (i) {

                                    return Icon(
                                      i <
                                              (item["rating"] ??
                                                  0)
                                          ? Icons.star
                                          : Icons.star_border,

                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }),
                                ),

                                const SizedBox(height: 14),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,

                                  children: [

                                    Container(
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.white10,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10),
                                      ),

                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color:
                                              Colors.white,
                                        ),

                                        onPressed: () {
                                          setState(() {
                                            controller.text =
                                                item["message"] ??
                                                    "";

                                            rating =
                                                item["rating"] ??
                                                    0;

                                            editId =
                                                item["_id"];
                                          });
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Container(
                                      decoration:
                                          BoxDecoration(
                                        color: Colors.red
                                            // ignore: deprecated_member_use
                                            .withOpacity(
                                                0.15),

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10),
                                      ),

                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),

                                        onPressed:
                                            () async {

                                          await context
                                              .read<
                                                  FeedbackProvider>()
                                              .deleteFeedback(
                                                token:
                                                    widget.token,
                                                id: item[
                                                    "_id"],
                                              );

                                          showSnackBar(
                                            "Deleted",
                                            Colors.red,
                                          );
                                        },
                                      ),
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
