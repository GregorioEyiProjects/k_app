import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_app/global.dart';
import 'package:k_app/router.dart';
import 'package:k_app/client/screens/welcome.dart';
import 'package:k_app/server/database/objectBox.dart';
import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late ObjectBox objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create(); // Initialize ObjectBox

  //Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider(objectBox))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //Initializes the shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _setRepeat();
  }

  //Method to navigate to HOME or LOGIN screen based on the state
  void _navigateBasedOnState() async {
    SharedPreferences prefs = await _prefs; //Is it logged in?
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      //Navigate to home screen
      navigatorKey.currentState?.pushReplacementNamed('/home');
    } else {
      //Navigate to login screen
      navigatorKey.currentState?.pushReplacementNamed("/home"); //Welcome
    }
  }

  void _setRepeat() async {
    final SharedPreferences prefs = await _prefs;
    isFirstTime = prefs.getBool('repeated') ?? true;
    isFirstTime = (prefs.getBool('isFirstTime') ?? false);
    setState(() {
      prefs.setBool('repeated', false);
      _navigateBasedOnState();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: "/welcome",
      // routes: routes,
      onGenerateRoute: generateRoute,
      builder: (context, child) {
        MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
    );
  }
}
