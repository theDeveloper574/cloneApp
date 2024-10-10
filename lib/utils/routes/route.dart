import 'package:flutter/material.dart';
import 'package:maanaap/screens/call_info_view.dart';
import 'package:maanaap/screens/contacts_view.dart';
import 'package:maanaap/screens/home_settings_view.dart';
import 'package:maanaap/screens/home_view.dart';
import 'package:maanaap/screens/login_view.dart';
import 'package:maanaap/screens/my_profile_view.dart';
import 'package:maanaap/screens/sign_up_view.dart';
import 'package:maanaap/screens/user_profile_view.dart';
import 'package:maanaap/utils/routes/routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.signUp:
        return MaterialPageRoute(builder: (context) => const SignUpView());
      case RouteName.logIn:
        return MaterialPageRoute(builder: (context) => const LogInView());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case RouteName.contact:
        return MaterialPageRoute(builder: (context) => const ContactView());
      // case RouteName.singleChatView:
      //   return MaterialPageRoute(builder: (context) => const SingleChatView());
      case RouteName.userProfileView:
        return MaterialPageRoute(builder: (context) => const UserProfileView());
      case RouteName.callInfoView:
        return MaterialPageRoute(builder: (context) => const CallInfoView());
      case RouteName.homeSettingsView:
        return MaterialPageRoute(builder: (context) => HomeSettingsView());
      case RouteName.myProfileView:
        return MaterialPageRoute(builder: (context) => const MyProfileView());
      // case RouteName.newChatView:
      // return MaterialPageRoute(builder: (context) => const NewChatView());
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
