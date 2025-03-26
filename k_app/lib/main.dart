import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_app/client/screen-components/home/v2/customBottomNav2.dart';
import 'package:k_app/global.dart';
import 'package:k_app/router.dart';
import 'package:k_app/client/screens/welcome.dart';
import 'package:k_app/server/database/bloc/appointmemt_bloc.dart';
import 'package:k_app/server/database/bloc/billing_bloc.dart';
import 'package:k_app/server/database/objectBox.dart';
//import 'package:k_app/server/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late ObjectBox objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create(); // Initialize ObjectBox

  //Run the app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppointmentBloc(objectBox: objectBox)),
        BlocProvider(create: (context) => BillingBloc(objectBox: objectBox)),
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      // routes: routes,
      onGenerateRoute: generateRoute,
      home: const CustomBottomNav2(),
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
