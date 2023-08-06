import 'package:final_year_project/provider/profile_data_provider.dart';
import 'package:final_year_project/provider/student_provider.dart';
import 'package:final_year_project/provider/teacher_provider.dart';
import 'package:final_year_project/provider/user_provider.dart';
import 'package:final_year_project/routes.dart';
import 'package:final_year_project/screens/splash_screen.dart';
import 'package:final_year_project/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:final_year_project/shared/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51NIBZGGP6SirLqJgNhM7GWzn4Q32yLpeM2Wl1GDHHOyk8dXnvQ4fPcemU4G3V2c4grjgAg0Zk5rJkKFuzQJUWDK100rZJecP2h';
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TeacherProvider>(
            create: (context) => TeacherProvider(),
          ),
          ChangeNotifierProvider<StudentProvider>(
            create: (context) => StudentProvider(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider<ProfileProvider>(
              create: (context) => ProfileProvider())
        ],
        child: Sizer(builder: (context, orientation, device) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: CustomTheme().baseTheme,
            home: SplashScreen(),
            // home: const SplashScreen(),
            // routes: {
            //   LoginScreen.routeName: (ctx) => const LoginScreen(),
            //   SignupScreen.routeName: (ctx) => const SignupScreen()
            // },
            //   initialRoute: SplashScreen.routeName,
              routes: routes
          );
        }));
  }
}
