import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zindaonlineschool/providers/course_provider.dart';
import 'package:zindaonlineschool/providers/feedback_provider.dart';

import 'package:zindaonlineschool/providers/home_provider.dart';
import 'package:zindaonlineschool/providers/session_provider.dart';
import 'package:zindaonlineschool/screens/auth/login_screen.dart';
import 'package:zindaonlineschool/screens/course/course_screen.dart';
import 'package:zindaonlineschool/screens/session/session_screen.dart';
import 'package:zindaonlineschool/screens/splash/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    print("HOME TOKEN: ${widget.token}");

    Future.microtask(() {
      context.read<HomeProvider>().fetchHomeData(widget.token);
       context.read<FeedbackProvider>().fetchAllFeedback(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Zinda Online",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),

        //     onPressed: () async {
        //       final prefs = await SharedPreferences.getInstance();

        //       await prefs.remove("token");

        //       if (!mounted) return;

        //       Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (_) => const LoginScreen()),
        //         (route) => false,
        //       );
        //     },
        //   ),
        // ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await provider.refreshHomeData(widget.token);
              },

              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildSearchBar(),

                    SizedBox(height: height * 0.03),

                    _buildWelcomeSection(width, height),

                    SizedBox(height: height * 0.03),

                    _buildBannerSection(provider, width, height),

                    SizedBox(height: height * 0.04),

                    _buildSectionTitle(title: "Our Courses", width: width),

                    SizedBox(height: height * 0.02),

                    _buildCategorySection(provider, width, height),

                    SizedBox(height: height * 0.04),

                    _buildSectionTitle(
                      title: "What Students Say",
                      width: width,
                    ),

                    SizedBox(height: height * 0.02),

                    // _buildFeedbackSection(provider, width, height),
                    _buildFeedbackSection(width, height),

                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),
            ),
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search Courses",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  /// WELCOME SECTION
  Widget _buildWelcomeSection(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Welcome Back 👋",

          style: TextStyle(
            color: Colors.white,
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: height * 0.01),

        Text(
          "Find the best courses for your future",

          style: TextStyle(color: Colors.white70, fontSize: width * 0.036),
        ),
      ],
    );
  }

  /// COMMON TITLE
  Widget _buildSectionTitle({required String title, required double width}) {
    return Text(
      title,

      style: TextStyle(
        color: Colors.white,
        fontSize: width * 0.055,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// BANNER SECTION
  Widget _buildBannerSection(
    HomeProvider provider,
    double width,
    double height,
  ) {
    if (provider.banners.isEmpty) {
      return const Center(
        child: Text("No Banners Found", style: TextStyle(color: Colors.white)),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: height * 0.24,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.99,
        autoPlayCurve: Curves.easeInOut,
        autoPlayAnimationDuration: const Duration(milliseconds: 900),
        enableInfiniteScroll: true,
      ),

      items: provider.banners.map((banner) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.01,
            vertical: height * 0.008,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),

            child: SizedBox.expand(
              child: Image.network(banner.image, fit: BoxFit.cover),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// CATEGORY SECTION
  Widget _buildCategorySection(
    HomeProvider provider,
    double width,
    double height,
  ) {
    if (provider.categories.isEmpty) {
      return const Center(
        child: Text(
          "No Categories Found",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: provider.categories.length,

      itemBuilder: (context, index) {
        final category = provider.categories[index];

        return Container(
          margin: EdgeInsets.only(bottom: height * 0.025),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),

                child: Image.network(
                  category.image,

                  height: height * 0.24,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: height * 0.24,
                      alignment: Alignment.center,

                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(width * 0.045),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TITLE
                    Text(
                      category.title,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: height * 0.015),

                    /// DESCRIPTION
                    Text(
                      category.description,

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.035,
                        height: 1.7,
                      ),
                    ),

                    SizedBox(height: height * 0.025),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),

                          foregroundColor: Colors.white,

                          elevation: 0,

                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.018,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        // onPressed: () {
                        //   Navigator.push(
                        //     context,

                        //     MaterialPageRoute(
                        //       builder: (_) => ChangeNotifierProvider(
                        //         create: (_) => CourseProvider(),

                        //         child: CoursesScreen(
                        //          categoryId: category.id, categoryTitle: category.title, token: widget.token,
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // },
                        onPressed: () {
                          if (category.key == "online_tuition") {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => SessionProvider(),

                                  child: SessionScreen(
                                    categoryId: category.id,

                                    token: widget.token,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => CourseProvider(),

                                  child: CoursesScreen(
                                    categoryId: category.id,

                                    categoryTitle: category.title,

                                    token: widget.token,
                                    sessionType: category.key,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              "View Courses",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: width * 0.038,
                              ),
                            ),

                            SizedBox(width: width * 0.02),

                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// FEEDBACK SECTION
  Widget _buildFeedbackSection(double width, double height) {
  return Consumer<FeedbackProvider>(
    builder: (context, provider, child) {

      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.allFeedback.isEmpty) {
        return const Text(
          "No Feedbacks Found",
          style: TextStyle(color: Colors.white),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),

        itemCount: provider.allFeedback.length,

        itemBuilder: (context, index) {
          final item = provider.allFeedback[index];

          return Container(
            margin: EdgeInsets.only(bottom: height * 0.02),

            padding: EdgeInsets.all(width * 0.045),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF312E81),
                      child: Text(
                        item["name"] != null
                            ? item["name"][0].toUpperCase()
                            : "S",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    SizedBox(width: width * 0.03),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"] ?? "Student",
                            style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            item["course"] ?? "",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),

                Text(
                  item["message"] ?? "",
                  style: TextStyle(
                    fontSize: width * 0.037,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
  }

