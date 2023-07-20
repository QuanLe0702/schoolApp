import 'package:school/screens/Document_screen/document_screen.dart';
import 'package:school/screens/News_screen/NewsListScreen.dart';
import 'package:school/screens/Report_Card_screen/report_card_screen.dart';
import 'package:school/screens/login_screen/login_screen.dart';
import 'package:school/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'screens/News_screen/news_screen.dart';
import 'screens/datesheet_screen/datesheet_screen.dart';
import 'screens/fee_screen/fee_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  FeeScreen.routeName: (context) => FeeScreen(),
  DateSheetScreen.routeName: (context) => DateSheetScreen(),
  NewsScreen.routeName: (context) => NewsScreen(),
  NewsListScreen.routeName: (context) => const NewsListScreen(),
  DocumentScreen.routeName: (context) => const DocumentScreen(),
  ReportCardScreen.routeName: (context) => const ReportCardScreen(),
};
