import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:school/components/menu_bottom.dart';

import 'package:school/constants.dart';
import 'package:school/screens/Document_screen/document_screen.dart';
import 'package:school/screens/News_screen/NewsListScreen.dart';
import 'package:school/screens/Report_Card_screen/report_card_screen.dart';
import 'package:school/screens/Score_screen/score_screen.dart';
import 'package:school/screens/datesheet_screen/datesheet_screen.dart';
import 'package:school/screens/fee_screen/fee_screen.dart';
import 'package:school/screens/login_screen/login_screen.dart';
import 'package:school/screens/my_profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'widgets/student_data.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    const flutterSecureStorage = FlutterSecureStorage();
    return Scaffold(
      bottomNavigationBar: const MenuBottom(),
      body: Column(
        children: [
          //we will divide the screen into two parts
          //fixed height for first half
          Container(
            width: 100.w,
            height: 25.h,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StudentName(
                          studentName: 'Student',
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    StudentPicture(
                        picAddress: 'assets/images/student.png',
                        onPress: () {
                          // go to profile detail screen here
                          Navigator.pushNamed(
                              context, MyProfileScreen.routeName);
                        }),
                  ],
                ),
              ],
            ),
          ),

          //other will use all the remaining height of screen
          Expanded(
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: kOtherColor,
                borderRadius: kTopBorderRadius,
              ),
              child: SingleChildScrollView(
                //for padding
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, ScoreView.routeName);
                          },
                          icon: 'assets/icons/quiz.svg',
                          title: 'Xem điểm',
                        ),
                        HomeCard(
                          onPress: () {
                            //go to assignment screen here
                            Navigator.pushNamed(
                                context, ReportCardScreen.routeName);
                          },
                          icon: 'assets/icons/assignment.svg',
                          title: 'Hạnh kiểm',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, DocumentScreen.routeName);
                          },
                          icon: 'assets/icons/holiday.svg',
                          title: 'Tài liệu',
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, NewsListScreen.routeName);
                          },
                          icon: 'assets/icons/timetable.svg',
                          title: 'Tin tức ',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, DateSheetScreen.routeName);
                          },
                          icon: 'assets/icons/datesheet.svg',
                          title: 'Xem TKB',
                        ),
                        HomeCard(
                          onPress: () {
                            flutterSecureStorage.deleteAll();
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          icon: 'assets/icons/logout.svg',
                          title: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getData() async {
    const storage = FlutterSecureStorage();
    final id = await storage.read(key: 'id');
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('http://10.0.2.2:8080/api/student/' + id.toString());
    final res = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard(
      {Key? key,
      required this.onPress,
      required this.icon,
      required this.title})
      : super(key: key);
  final VoidCallback onPress;
  final String icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              width: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              color: kOtherColor,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}
