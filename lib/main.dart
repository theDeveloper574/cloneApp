import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';

import 'firebase_options.dart';
import 'utils/routes/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance.currentUser != null
        ? setStatus("online", FirebaseAuth.instance.currentUser!.uid)
        : null;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online user
      FirebaseAuth.instance.currentUser != null
          ? setStatus("online", FirebaseAuth.instance.currentUser!.uid)
          : null;
    } else {
      FirebaseAuth.instance.currentUser != null
          ? setStatus("offline", FirebaseAuth.instance.currentUser!.uid)
          : null;
      //offline user
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'roboto',
        appBarTheme: AppBarTheme(
            elevation: 0.0, backgroundColor: AppColors.defaultColor),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColors.lightGreen),
      ),

      ///default route
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? RouteName.home
          : RouteName.signUp,
      // initialRoute: RouteName.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }

  void setStatus(String status, String uid) {
    FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }
}

Future flutterToast({required String message}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.defaultColor,
      textColor: Colors.white,
      fontSize: 14.0);
}
