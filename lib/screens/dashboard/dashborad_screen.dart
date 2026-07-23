// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zindaonlineschool/core/utils/responsive.dart';
// import 'package:zindaonlineschool/providers/chat_provider.dart';
// import 'package:zindaonlineschool/providers/tutor_provider.dart';
// import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
// import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
// import 'package:zindaonlineschool/screens/settings/settings_screen.dart';
// import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
// import 'package:zindaonlineschool/widgets/adaptive_app_navigation.dart';
// import 'package:zindaonlineschool/widgets/custom_bootom_nav.dart';

// class DashboardScreen extends StatefulWidget {
//   final String token;

//   const DashboardScreen({super.key, required this.token});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int currentIndex = 0;

//   final List<Widget?> _lazyScreens = [null, null, null, null];

//   String? roomId;
//   bool _chatLoading = false;



// @override
// void initState() {
//   super.initState();

//   /// Load Home immediately
//   _screenForIndex(0);

//   /// Pre-create Tutors screen
//   _screenForIndex(1);

//   /// Load tutors AFTER dashboard renders
//   // WidgetsBinding.instance
//   //     .addPostFrameCallback((_) {

//   //   Future.delayed(
//   //     const Duration(seconds: 2),

//   //     () {

//   //       if (!mounted) return;

//   //       context
//   //           .read<TutorProvider>()
//   //           .fetchTutors(
//   //             null,
//   //             widget.token,
//   //           );
//   //     },
//   //   );
//   // });
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//   context.read<TutorProvider>().fetchTutors(
//     null,
//     widget.token,
//   );
// });
// }
// // @override
// // void initState() {
// //   super.initState();

// //   _screenForIndex(0);
// //   _screenForIndex(1);

// //   Future.microtask(() {
// //     context.read<TutorProvider>().fetchTutors(
// //       null,
// //       widget.token,
// //     );
// //   });
// // }
//   Widget _screenForIndex(int index) {
//     if (_lazyScreens[index] != null) {
//       return _lazyScreens[index]!;
//     }

//     switch (index) {
//       case 0:
//         _lazyScreens[0] = HomeScreen(token: widget.token);
//         break;
//       case 1:
//         _lazyScreens[1] = TutorsScreen(
//           courseId: '',
//           courseTitle: 'All Tutors',
//           token: widget.token,
//         );
//         break;
//       case 2:
//         _lazyScreens[2] = const Center(
//           child: CircularProgressIndicator(color: Colors.white),
//         );
//         break;
//       case 3:
//         _lazyScreens[3] = SettingsScreen(token: widget.token);
//         break;
//     }

//     return _lazyScreens[index]!;
//   }


// //   Future<void> changeTab(int index) async {
// //     //  debugPrint("Tapped tab: $index");
// //   if (index == 2) {
// //     setState(() => _chatLoading = true);

// //     final provider = context.read<ChatProvider>();

// //     await provider.fetchRooms(widget.token);

// //     if (!mounted) return;

// //     if (provider.rooms.isNotEmpty) {

// //       roomId = provider.rooms.first["_id"];

// //       setState(() => _chatLoading = false);

// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (_) => ChatRoomScreen(
// //             roomId: roomId!,
// //             token: widget.token,
// //           ),
// //         ),
// //       );

// //     } else {

// //       setState(() => _chatLoading = false);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("No chat rooms found"),
// //         ),
// //       );
// //     }

// //     return;
// //   }

// //   setState(() {
// //     currentIndex = index;
// //     _screenForIndex(index);
// //   });
// // }
// // Future<void> changeTab(int index) async {

// //   // Tutors tab clicked
// //   if (index == 1) {

// //     await context.read<TutorProvider>().fetchTutors(
// //       null,
// //       widget.token,
// //     );
// //   }

// //   // Chat tab
// //   if (index == 2) {

// //     setState(() => _chatLoading = true);

// //     final provider = context.read<ChatProvider>();

// //     await provider.fetchRooms(widget.token);

// //     if (!mounted) return;

// //     if (provider.rooms.isNotEmpty) {

// //       roomId = provider.rooms.first["_id"];

// //       setState(() => _chatLoading = false);

// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (_) => ChatRoomScreen(
// //             roomId: roomId!,
// //             token: widget.token,
// //           ),
// //         ),
// //       );

// //     } else {

// //       setState(() => _chatLoading = false);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("No chat rooms found"),
// //         ),
// //       );
// //     }

// //     return;
// //   }

// //   setState(() {
// //     currentIndex = index;
// //   });
// // }

// Future<void> changeTab(int index) async {

//   // Tutors Tab
// //  if (index == 1) {
// //   setState(() {
// //     currentIndex = index;
// //   });

// //   Future.microtask(() {
// //     context.read<TutorProvider>().fetchTutors(
// //       null,
// //       widget.token,
// //     );
// //   });

// //   return;
// // }
// if (index == 1) {
//   setState(() {
//     currentIndex = index;
//   });

//   return;
// }
//   // Chat Tab
//   if (index == 2) {

//     setState(() {
//       _chatLoading = true;
//     });

//     final provider =
//         context.read<ChatProvider>();

//     await provider.fetchRooms(
//       widget.token,
//     );

//     if (!mounted) return;

//     setState(() {
//       _chatLoading = false;
//     });

//     if (provider.rooms.isNotEmpty) {

//       roomId =
//           provider.rooms.first["_id"];

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               ChatRoomScreen(
//                 roomId: roomId!,
//                 token: widget.token,
//               ),
//         ),
//       );
//     } else {

//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         const SnackBar(
//           content:
//               Text("No chat rooms found"),
//         ),
//       );
//     }

//     return;
//   }

//   // Home & Settings
//   setState(() {
//     currentIndex = index;
//   });
// }

//   Widget _buildMainContent() {
//     // debugPrint("Current index: $currentIndex");
//     return Stack(
//       children: [
      
//         // IndexedStack(
//         //   index: currentIndex,

//         //   children: [
//         //     _screenForIndex(0),

//         //     _screenForIndex(1),

//         //    const SizedBox(),

//         //     _screenForIndex(3),
//         //   ],
//         // ),
//         IndexedStack(
//   index: currentIndex > 2 ? 2 : currentIndex,
//   children: [
//     _screenForIndex(0),
//     _screenForIndex(1),
//     const SizedBox(), 
//     _screenForIndex(3),
//   ],
// ),
//         if (_chatLoading)
//           const ColoredBox(
//             color: Color(0x880B023D),
//             child: Center(
//               child: CircularProgressIndicator(color: Colors.white),
              
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final useRail = Responsive.useNavigationRail(context);

//     if (useRail) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF0B023D),
//         body: Row(
//           children: [
//             DashboardNavigationRail(
//               currentIndex: currentIndex,
//               onDestinationSelected: changeTab,
//             ),
//             const VerticalDivider(
//               width: 1,
//               thickness: 1,
//               color: Colors.white12,
//             ),
//             Expanded(child: _buildMainContent()),
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B023D),
//       body: _buildMainContent(),
//       bottomNavigationBar: BottomNavWidget(
//         currentIndex: currentIndex,
//         onTap: changeTab,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/providers/tutor_provider.dart';
import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
import 'package:zindaonlineschool/screens/chat/chat_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
import 'package:zindaonlineschool/screens/settings/settings_screen.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/adaptive_app_navigation.dart';
import 'package:zindaonlineschool/widgets/custom_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  const DashboardScreen({super.key, required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final List<Widget?> _lazyScreens = [null, null, null, null];
  String? roomId;
  bool _chatLoading = false;

  @override
  void initState() {
    super.initState();

    /// Load Home immediately
    _screenForIndex(0);

    /// Pre-create Tutors screen (It will manage its own API load smoothly inside its lifecycle)
    _screenForIndex(1);
  }

  Widget _screenForIndex(int index) {
    if (_lazyScreens[index] != null) {
      return _lazyScreens[index]!;
    }

    switch (index) {
      case 0:
        _lazyScreens[0] = HomeScreen(token: widget.token);
        break;
      case 1:
        _lazyScreens[1] = TutorsScreen(
          courseId: '',
          courseTitle: 'All Tutors',
          token: widget.token,
        );
        break;
      case 2:
        _lazyScreens[2] = const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
        break;
      case 3:
        _lazyScreens[3] = SettingsScreen(token: widget.token);
        break;
    }

    return _lazyScreens[index]!;
  }

 Future<void> changeTab(int index) async {
    // FIX: Force reload "All Tutors" when clicking the bottom nav Tutors tab
    if (index == 1) {
      setState(() {
        currentIndex = index;
      });

      // Fetch all tutors (null means no specific course filter)
      context.read<TutorProvider>().fetchTutors(
        null,
        widget.token,
      );
      return;
    }

    // Chat Tab
  if (index == 2) {
    // Instead of looking for rooms and showing an error,
    // just take the user directly to your ChatScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(token: widget.token),
      ),
    );
    return; // Stop here, don't do anything else.
  }

    // Home & Settings
    setState(() {
      currentIndex = index;
    });
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        IndexedStack(
          // FIX: If index is 2 (Chat), keep displaying the previously selected tab layout 
          // underneath the loader instead of jumping to an empty SizedBox.
          index: currentIndex == 2 ? 0 : currentIndex, 
          children: [
            _screenForIndex(0), // Index 0: Home
            _screenForIndex(1), // Index 1: Tutors
            const SizedBox(),   // Index 2: Placeholder for Chat tab
            _screenForIndex(3), // Index 3: Settings Screen works perfectly now!
          ],
        ),
        if (_chatLoading)
          const ColoredBox(
            color: Color(0x880B023D),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final useRail = Responsive.useNavigationRail(context);

    if (useRail) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B023D),
        body: Row(
          children: [
            DashboardNavigationRail(
              currentIndex: currentIndex,
              onDestinationSelected: changeTab,
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.white12,
            ),
            Expanded(child: _buildMainContent()),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B023D),
      body: _buildMainContent(),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}