import 'package:flutter/material.dart';
import 'package:school/screens/News_screen/news_screen.dart';
import 'package:school/screens/home_screen/home_screen.dart';

class MenuBottom extends StatelessWidget {
  const MenuBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, HomeScreen.routeName);
            break;
          case 1:
            Navigator.pushNamed(context, NewsScreen.routeName);
            break;

          default:
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box_rounded),
          label: 'Hồ sơ của tôi',
        ),
      ],
    );
  }
}
