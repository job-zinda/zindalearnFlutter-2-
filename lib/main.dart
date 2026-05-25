// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/providers/course_provider.dart';
// import 'package:zindaonlineschool/providers/feedback_provider.dart';
// import 'package:zindaonlineschool/providers/home_provider.dart';
// import 'package:zindaonlineschool/providers/profile_provider.dart';
// import 'package:zindaonlineschool/providers/review_provider.dart';
// import 'package:zindaonlineschool/providers/tutor_provider.dart';

// import 'package:zindaonlineschool/screens/splash/splash_screen.dart';

// import 'core/theme/app_theme.dart';
// import 'providers/auth_provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),

//         ChangeNotifierProvider(create: (_) => ProfileProvider()),
//         ChangeNotifierProvider(create: (_) => HomeProvider()),
//         ChangeNotifierProvider(create: (_) => CourseProvider()),
//         ChangeNotifierProvider(create: (_) => TutorProvider()),
//         ChangeNotifierProvider(create: (_) => ReviewProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//           ChangeNotifierProvider(create: (_) => FeedbackProvider()),
//       ],

//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,

//         theme: AppTheme.darkTheme,

//         home: const SplashScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/providers/course_provider.dart';
import 'package:zindaonlineschool/providers/feedback_provider.dart';
import 'package:zindaonlineschool/providers/home_provider.dart';
import 'package:zindaonlineschool/providers/profile_provider.dart';
import 'package:zindaonlineschool/providers/review_provider.dart';
import 'package:zindaonlineschool/providers/tutor_provider.dart';

import 'package:zindaonlineschool/screens/splash/splash_screen.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: mq.textScaler.clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 1.15,
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
