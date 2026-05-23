import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
import 'package:zindaonlineschool/screens/settings/settings_screen.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/custom_bootom_nav.dart';

class DashboardScreen extends StatefulWidget {

  final String token;

  const DashboardScreen({
    super.key,
    required this.token,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int currentIndex = 0;

  List<Widget> screens = [];

  String? roomId;

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

      const Center(
        child: CircularProgressIndicator(),
      ),

      SettingsScreen(
        token: widget.token,
      ),
    ];
  }

  Future<void> changeTab(
      int index) async {

    /// CHAT TAB
    if (index == 2) {

      final provider =
          context.read<ChatProvider>();

      await provider.fetchRooms(
        widget.token,
      );

      if (provider.rooms.isNotEmpty) {

        roomId =
            provider.rooms.first["_id"];

        screens[2] = ChatRoomScreen(
          roomId: roomId!,
          token: widget.token,
        );

        setState(() {
          currentIndex = 2;
        });

      } else {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(
            content: Text(
              "No chat rooms found",
            ),
          ),
        );
      }

      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      body:
          screens[currentIndex],

      bottomNavigationBar:
          BottomNavWidget(

        currentIndex:
            currentIndex,

        onTap: changeTab,
      ),
    );
  }
}