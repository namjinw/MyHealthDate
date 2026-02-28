import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_health_date/page/alarm.dart';
import 'package:my_health_date/page/component/my.dart';
import 'package:my_health_date/page/workout.dart';
import 'package:my_health_date/utils.dart';

import 'home.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, String>> itemImg = [
    {'icon': 'home-1-svgrepo-com.svg', 'label': 'Home'},
    {'icon': 'alarm-clock-svgrepo-com.svg', 'label': 'Alarm'},
    {
      'icon': 'run-on-treadmill-exercise-work-out-run-svgrepo-com.svg',
      'label': 'Workout',
    },
    {'icon': 'user-svgrepo-com.svg', 'label': 'My Page'},
  ];
  int crrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      bottomNavigationBar: bottomBar(),
      backgroundColor: background,
      body: IndexedStack(index: crrentIndex, children: [
        HomePage(),
        AlarmPage(),
        WorkoutPage(),
        MyPage(),
      ]),
    );
  }

  AppBar appbar() => AppBar(
    backgroundColor: appBarColor,
    title: const Text(
      'My Health DATA',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: background,
        fontFamily: fonts,
        fontSize: 16,
      ),
    ),
    actions: [
      Center(
        child: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: background),
          color: background,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text(
                  'Sign-out',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: fonts,
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    ],
  );

  BottomNavigationBar bottomBar() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: crrentIndex,
    selectedItemColor: background,
    unselectedItemColor: iconColor,
    onTap: (value) {
      crrentIndex = value;
      setState(() {});
    },
    unselectedLabelStyle: const TextStyle(color: background, fontWeight: FontWeight.w500, fontFamily: fonts),
    selectedLabelStyle: const TextStyle(color: background, fontWeight: FontWeight.w700, fontFamily: fonts),
    backgroundColor: appBarColor,
    showUnselectedLabels: true,
    items: [
      ...List.generate(
        itemImg.length,
        (index) => navItem(itemImg[index]['icon'], itemImg[index]['label'], index),
      ),
    ],
  );

  BottomNavigationBarItem navItem(svg, text, index) => BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 4.0),
      child: SvgPicture.asset(
        'assets/images/$svg',
        height: 32,
        colorFilter: ColorFilter.mode(crrentIndex == index ? background : iconColor, BlendMode.srcIn),
      ),
    ),
    label: text,
    backgroundColor: Colors.black,
  );
}
