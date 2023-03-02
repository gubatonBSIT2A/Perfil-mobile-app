import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:perfil/screens/account_screen.dart';
import 'package:perfil/screens/exam_record_screen.dart';
import 'package:perfil/screens/home_screen.dart';
import 'package:perfil/screens/notification_screen.dart';
import 'package:perfil/screens/schedule_screen.dart';



class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const ExamRecordScreen(),
    const ScheduleScreen(),
    const NotificationScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Exam Record',
          ),
          const BottomNavigationBarItem (
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.notifications_rounded),
                // Badge(
                //   badgeColor: Colors.blue,
                //   padding: const  EdgeInsets.all(5),
                //   // position: BadgePosition.topEnd(top: -2, end: -2),
                //   badgeContent:const  Text(
                //       '1',
                //       style: TextStyle(
                //           color: Colors.white)
                //   ),
                // )
              ],
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
    );
  }
}
