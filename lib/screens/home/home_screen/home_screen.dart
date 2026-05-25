import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/course_provider.dart';
import 'package:zindaonlineschool/providers/feedback_provider.dart';
import 'package:zindaonlineschool/providers/home_provider.dart';
import 'package:zindaonlineschool/providers/session_provider.dart';
import 'package:zindaonlineschool/screens/course/course_screen.dart';
import 'package:zindaonlineschool/screens/session/session_screen.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/models/category_model.dart';
import 'package:zindaonlineschool/widgets/cached_app_image.dart';
import 'package:zindaonlineschool/widgets/responsive_body.dart';

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

    Future.microtask(() {
      Future.wait([
        context.read<HomeProvider>().fetchHomeData(widget.token),
        context.read<FeedbackProvider>().fetchAllUsersFeedback(widget.token),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

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

       
      ),

      body: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  provider.refreshHomeData(widget.token),
                  context.read<FeedbackProvider>().fetchAllUsersFeedback(
                        widget.token,
                        force: true,
                      ),
                ]);
              },

              child: ResponsiveBody(
                child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildWelcomeSection(context),

                    if (provider.errorMessage != null) ...[
                      SizedBox(height: Responsive.spacing(context, 0.02)),
                      _buildErrorBanner(provider.errorMessage!),
                    ],

                    SizedBox(height: Responsive.spacing(context, 0.03)),

                    if (provider.isLoading && !provider.hasContent)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.spacing(context, 0.08),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text(
                                "Loading courses…",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildBannerSection(context, provider),

                    SizedBox(height: Responsive.spacing(context, 0.04)),

                    _buildSectionTitle(context, "Our Courses"),

                    SizedBox(height: Responsive.spacing(context, 0.02)),

                    _buildCategorySection(context, provider),

                    SizedBox(height: Responsive.spacing(context, 0.04)),

                    _buildSectionTitle(context, "What Students Say"),

                    SizedBox(height: Responsive.spacing(context, 0.02)),

                    // _buildFeedbackSection(provider, width, height),
                    Consumer<FeedbackProvider>(
  builder: (context, provider, child) {

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.allFeedback.isEmpty) {
      return const Text(
        "No Feedback Found",
        style: TextStyle(color: Colors.white),
      );
    }

    final count = provider.allFeedback.length.clamp(0, 5);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,

      itemBuilder: (context, index) {
        final item = provider.allFeedback[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                item["studentId"]?["name"] ?? "Student",
                style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                item["message"] ?? "",
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 8),

              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < (item["rating"] ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  },
),

                    SizedBox(height: Responsive.spacing(context, 0.04)),
                  ],
                ),
              ),
            ),
              ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.4)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.orangeAccent, fontSize: 13),
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
  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Welcome Back 👋",
          style: TextStyle(
            color: Colors.white,
            fontSize: Responsive.fontSize(context, 0.06, min: 20, max: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, 0.01)),
        Text(
          "Find the best courses for your future",
          style: TextStyle(
            color: Colors.white70,
            fontSize: Responsive.fontSize(context, 0.036, min: 13, max: 18),
          ),
        ),
      ],
    );
  }

  /// COMMON TITLE
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: Responsive.fontSize(context, 0.055, min: 16, max: 24),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// BANNER SECTION
  Widget _buildBannerSection(BuildContext context, HomeProvider provider) {
    final width = Responsive.contentWidth(context);
    if (provider.banners.isEmpty) {
      return const Center(
        child: Text("No Banners Found", style: TextStyle(color: Colors.white)),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: Responsive.spacing(context, 0.24, min: 140, max: 260),
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: Responsive.value(
          context,
          mobile: 0.99,
          tablet: 0.88,
          desktop: 0.75,
        ),
        autoPlayCurve: Curves.easeInOut,
        autoPlayAnimationDuration: const Duration(milliseconds: 900),
        enableInfiniteScroll: true,
      ),

      items: provider.banners.map((banner) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.01,
            vertical: Responsive.spacing(context, 0.008, min: 4, max: 12),
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

            child: CachedAppImage(
              url: banner.image,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    if (Responsive.gridColumns(context) == 1) {
      return _buildCategoryCardList(context, category);
    }
    return _buildCategoryCardGrid(context, category);
  }

  BoxDecoration get _categoryCardDecoration => BoxDecoration(
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
      );

  /// Full-width list card (phone).
  Widget _buildCategoryCardList(BuildContext context, CategoryModel category) {
    final width = Responsive.contentWidth(context);
    final imageHeight = Responsive.spacing(context, 0.22, min: 140, max: 200);

    return Container(
      decoration: _categoryCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: CachedAppImage(
              url: category.image,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.045),
            child: _buildCategoryCardBody(context, category, compact: false),
          ),
        ],
      ),
    );
  }

  /// Grid card (tablet/desktop) — flex layout fits fixed grid cell height.
  Widget _buildCategoryCardGrid(BuildContext context, CategoryModel category) {
    return Container(
      decoration: _categoryCardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 11,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: CachedAppImage(
                url: category.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            flex: 14,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: _buildCategoryCardBody(context, category, compact: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCardBody(
    BuildContext context,
    CategoryModel category, {
    required bool compact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          maxLines: compact ? 2 : null,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 14 : Responsive.fontSize(context, 0.05, min: 14, max: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: compact ? 4 : Responsive.spacing(context, 0.012)),
        if (compact)
          Expanded(
            child: Text(
              category.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          )
        else
          Text(
            category.description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Responsive.fontSize(context, 0.032, min: 12, max: 16),
              height: 1.5,
            ),
          ),
        SizedBox(height: compact ? 6 : Responsive.spacing(context, 0.02)),
        SizedBox(
          width: double.infinity,
          height: compact ? 36 : null,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: compact ? 8 : Responsive.spacing(context, 0.016, min: 10, max: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(compact ? 12 : 18),
              ),
            ),
            onPressed: () => _openCategory(context, category),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Courses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: compact ? 12 : Responsive.fontSize(context, 0.035, min: 12, max: 16),
                  ),
                ),
                SizedBox(width: compact ? 4 : 8),
                Icon(Icons.arrow_forward_rounded, size: compact ? 14 : 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openCategory(BuildContext context, CategoryModel category) {
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
  }

  /// CATEGORY SECTION — 1 column on phone, 2–3 on tablet/desktop
  Widget _buildCategorySection(BuildContext context, HomeProvider provider) {
    if (provider.categories.isEmpty) {
      return const Center(
        child: Text(
          "No Categories Found",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final columns = Responsive.gridColumns(context);

    if (columns == 1) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.categories.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: Responsive.spacing(context, 0.025)),
        itemBuilder: (context, index) =>
            _buildCategoryCard(context, provider.categories[index]),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: Responsive.value(
          context,
          mobile: 0.72,
          tablet: 0.58,
          desktop: 0.60,
        ),
      ),
      itemBuilder: (context, index) =>
          _buildCategoryCard(context, provider.categories[index]),
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

