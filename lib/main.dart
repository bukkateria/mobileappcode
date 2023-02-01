// @dart=2.9
import 'dart:io';

import 'package:bukateria/bloc/auth/auth_bloc.dart';
import 'package:bukateria/cubit/account_cubit/account_cubit.dart';
import 'package:bukateria/cubit/onboarding_cubit/onboard_cubit.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/place_search_cubit/place_search_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/cubit/reset_password/reset_cubit.dart';
import 'package:bukateria/cubit/role_view_cubit/roleview_cubit.dart';
import 'package:bukateria/cubit/signin_cubit.dart';
import 'package:bukateria/cubit/signup_cubit.dart';
import 'package:bukateria/cubit/splash_cubit/splash_cubit.dart';
import 'package:bukateria/cubit/user_info/userinfo_cubit.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/repository/order_repository.dart';
import 'package:bukateria/repository/postRepository/post_repository.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as setting;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'my_preference.dart';

Future main() async {
  print("---------------");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MyPref myPref = MyPref.getInstance();
  myPref.getData();
  await setting.Settings.init(cacheProvider: setting.SharePreferenceCache());

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  var androidInitialize = new AndroidInitializationSettings('ic_launcher');
  var iOSInitialize = new IOSInitializationSettings();
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  plugin.initialize(
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize),
      onSelectNotification: (String payload) {
    if (payload != null && payload.isNotEmpty) {
      print("-----------clicked------------");
    }

    return;
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('---------notify------- Got a message whilst in the foreground!');
    print('---------notify-------Message data: ${message.data}');

    if (message.notification != null) {
      // MyNotification.showNotification(message, plugin, true);
      showTextNotification(message.notification.title ?? "",
          message.notification.body ?? "", 'abc', plugin);
      print(
          'Message also contained a notification: ${message.notification.title}');
    }
  });

  runApp(MyApp(
    myPref: myPref,
  ));
}

Future<void> showTextNotification(String title, String body, String tripId,
    FlutterLocalNotificationsPlugin fln) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    playSound: true,
    importance: Importance.max,
    priority: Priority.max,
    sound: RawResourceAndroidNotificationSound('arrived_msg'),
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await fln.show(0, title, body, platformChannelSpecifics, payload: "Click");
}

class MyApp extends StatelessWidget {
  MyPref myPref;

  MyApp({this.myPref, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* return MaterialApp(
      home: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
        ),
      ),
    );*/

    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("------handle-----${message}");
    Navigator.pushNamed(context, AppPages.INITIAL);
  }

  @override
  initState() {
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => PostRepository()),
        RepositoryProvider(create: (context) => OrderRepository())
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>()),
            ),
            BlocProvider<SignupCubit>(
                create: (context) => SignupCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<SigninCubit>(
                create: (context) => SigninCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<ResetCubit>(
                create: (context) =>
                    ResetCubit(authRepository: context.read<AuthRepository>())),
            BlocProvider<UserInfoCubit>(
                create: (context) => UserInfoCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<RoleViewCubit>(
                create: (context) => RoleViewCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<OnboardCubit>(
                create: (context) => OnboardCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<SplashCubit>(
                create: (context) => SplashCubit(
                    authRepository: context.read<AuthRepository>())),
            BlocProvider<PostCubit>(
                create: (context) => PostCubit(
                    authRepository: context.read<AuthRepository>(),
                    postRepository: context.read<PostRepository>())),
            BlocProvider<PlaceSearchCubit>(
                create: (context) => PlaceSearchCubit(
                    authRepository: context.read<AuthRepository>(),
                    postRepository: context.read<PostRepository>())),
            BlocProvider<OrderCubit>(
                create: (context) => OrderCubit(
                    orderRepository: context.read<OrderRepository>())),
            BlocProvider<AccountCubit>(
                create: (context) => AccountCubit(
                    authRepository: context.read<AuthRepository>(),
                    postRepository: context.read<PostRepository>())),
          ],
          child: GetMaterialApp(
            title: "Bukkateria",
            initialRoute: AppPages.INITIAL,
            theme: ThemeData(
                primaryColor: primary,
                appBarTheme: AppBarTheme(color: primary)),
            getPages: AppPages.routes,
            // home: AddRecipeWidget(),
            debugShowCheckedModeBanner: false,
          )),
    );
  }
}
