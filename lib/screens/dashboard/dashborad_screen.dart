import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/chat/chat_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
import 'package:zindaonlineschool/screens/profile/profile_screen.dart';
import 'package:zindaonlineschool/screens/tutor/all_tutors_screen.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/custom_bootom_nav.dart';

class DashboardScreen extends StatefulWidget {

  final String token;

  const DashboardScreen({
    super.key,
    required this.token,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// class _DashboardScreenState extends State<DashboardScreen> {

//   int currentIndex = 0;

//   late final List<Widget> screens;

//   @override
//   void initState() {
//     super.initState();

//     screens = [

//       HomeScreen(
//         token: widget.token,
//       ),

//       TutorsScreen(
//         courseId: '',
//         courseTitle: '',
//         token: widget.token,
//       ),


//       // ChatScreen(
//       //   token: widget.token,
//       // ),

//       ProfileScreen(
//         token: widget.token,
//       ),

//     ];
//   }

//   void changeTab(int index) {

//     setState(() {
//       currentIndex = index;
//     });

//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       body: screens[currentIndex],

//       bottomNavigationBar: BottomNavWidget(
//         currentIndex: currentIndex,
//         onTap: changeTab,
//       ),

//     );
//   }
// }

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [

      HomeScreen(
        token: widget.token,
      ),
TutorsScreen(
  courseId: '',   
  courseTitle: 'All Tutors',
  token: widget.token,
),
 ChatScreen(
        token: widget.token,
        //  roomId: ''
      ),

      ProfileScreen(
        token: widget.token,
      ),

    ];
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 2) {
    context.read<ChatProvider>().fetchRooms(widget.token);
  }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavWidget(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),

    );
  }
}