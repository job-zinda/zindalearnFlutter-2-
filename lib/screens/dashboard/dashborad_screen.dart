import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zindaonlineschool/core/utils/responsive.dart';
import 'package:zindaonlineschool/providers/chat_provider.dart';
import 'package:zindaonlineschool/screens/chat/chat_room_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';
import 'package:zindaonlineschool/screens/settings/settings_screen.dart';
import 'package:zindaonlineschool/screens/tutor/tutor_screen.dart';
import 'package:zindaonlineschool/widgets/adaptive_app_navigation.dart';
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

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Widget?> _lazyScreens = [null, null, null, null];

  String? roomId;
  bool _chatLoading = false;

  @override
  void initState() {
    super.initState();
    _screenForIndex(0);
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
    if (index == 2) {
      setState(() => _chatLoading = true);

      final provider = context.read<ChatProvider>();
      await provider.fetchRooms(widget.token);

      if (!mounted) return;

      if (provider.rooms.isNotEmpty) {
        roomId = provider.rooms.first["_id"];
        _lazyScreens[2] = ChatRoomScreen(
          roomId: roomId!,
          token: widget.token,
        );
        setState(() {
          currentIndex = 2;
          _chatLoading = false;
        });
      } else {
        setState(() => _chatLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No chat rooms found")),
        );
      }
      return;
    }

    setState(() {
      currentIndex = index;
      _screenForIndex(index);
    });
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        IndexedStack(
          index: currentIndex,
          children: List.generate(
            4,
            (i) => _lazyScreens[i] ?? const SizedBox.shrink(),
          ),
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
            const VerticalDivider(width: 1, thickness: 1, color: Colors.white12),
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
