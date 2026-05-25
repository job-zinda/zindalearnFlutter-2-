import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/session_provider.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/screens/course/course_screen.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

class SessionScreen extends StatefulWidget {

  final String categoryId;
  final String token;

  const SessionScreen({
    super.key,
    required this.categoryId,
    required this.token,
  });

  @override
  State<SessionScreen> createState() =>
      _SessionScreenState();
}

class _SessionScreenState
    extends State<SessionScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<SessionProvider>()
          .fetchSessions(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<SessionProvider>();

    final width = Responsive.contentWidth(context);
    final height = Responsive.height(context);

    return Scaffold(

      backgroundColor:
          const Color(0xFF0B023D),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        title: const Text(
          "Choose Session",
        ),
      ),

      body: provider.isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : provider.sessions.isEmpty

              ? const Center(
                  child: Text(

                    "No Sessions Found",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )

              : ResponsiveBody(
                  padding: EdgeInsets.zero,
                  child: ListView.builder(
                  padding: Responsive.screenPadding(context),

                  itemCount:
                      provider.sessions.length,

                  itemBuilder:
                      (context, index) {

                    final session =
                        provider.sessions[index];

                    return GestureDetector(

                    onTap: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => CoursesScreen(

        categoryId: widget.categoryId,

        categoryTitle: session.title,

        token: widget.token,

        // sessionType:
        //     session.title.toLowerCase().contains("batch")

        //         ? "batch"

        //         : "one_to_one",
        sessionType:
    session.title.toLowerCase().contains("batch")
        ? "batch"
        : session.title.toLowerCase().contains("one")
            ? "one_to_one"
            : session.title.toLowerCase().contains("skill")
                ? "skill_base"
                : session.title.toLowerCase().contains("talent")
                    ? "talent_base"
                    : "none",
      ),
    ),
  );
},
                      child: Container(

                        margin: EdgeInsets.only(
                          bottom:
                              height * 0.025,
                        ),

                        decoration:
                            BoxDecoration(

                          gradient:
                              const LinearGradient(

                            colors: [
                              Color(0xFF1A145F),
                              Color(0xFF241B7A),
                            ],

                            begin:
                                Alignment.topLeft,

                            end:
                                Alignment.bottomRight,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color:
                                  Colors.black.withOpacity(
                                0.22,
                              ),

                              blurRadius:
                                  12,

                              offset:
                                  const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                        ),

                        child: Padding(

                          padding:
                              EdgeInsets.all(
                            width * 0.05,
                          ),

                          child: Row(

                            children: [

                              Container(

                                height:
                                    width * 0.16,

                                width:
                                    width * 0.16,

                                decoration:
                                    BoxDecoration(

                                  color:
                                      Colors.white.withOpacity(
                                    0.1,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),

                                child:
                                    const Icon(

                                  Icons.video_collection,

                                  color:
                                      Colors.white,

                                  size: 34,
                                ),
                              ),

                              SizedBox(
                                width:
                                    width * 0.04,
                              ),

                              Expanded(

                                child:
                                    Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      session.title,

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.white,

                                        fontSize:
                                            width * 0.045,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(
                                      height:
                                          height * 0.008,
                                    ),

                                    Text(

                                      "${session.courses.length} Courses Available",

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.white70,

                                        fontSize:
                                            width * 0.034,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(

                                Icons.arrow_forward_ios,

                                color:
                                    Colors.white70,

                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ),
    );
  }
}