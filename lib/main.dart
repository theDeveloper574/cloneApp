import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'firebase_options.dart';
import 'utils/routes/route.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'roboto',
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: AppColors.defaultColor
        )
        // primarySwatch:,
      ),
      // home:const Home(),
      // home: SignUpView(),
      initialRoute: FirebaseAuth.instance.currentUser !=null? RouteName.home: RouteName.signUp,
      // initialRoute: RouteName.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

Future flutterToast({required String message}){
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.defaultColor,
      textColor: Colors.white,
      fontSize: 14.0
  );
}