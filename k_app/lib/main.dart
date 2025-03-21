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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
/*     SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    ); */
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
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
