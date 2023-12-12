import 'package:DeedBalancer/component/add_note.dart';
import 'package:DeedBalancer/pages/home_screen.dart';
import 'package:DeedBalancer/pages/login_screen.dart';
import 'package:DeedBalancer/pages/register_screen.dart';
import 'package:DeedBalancer/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        debugShowCheckedModeBanner: false,
        title: 'DeedBalancer',
        home: const Splash(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/add-notes': (context) => const AddNote()
        },
      ),
    );
  }
}

// Loading Page in Splash
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome To",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Image(
                  image: AssetImage("images/db-logo.png"),
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
