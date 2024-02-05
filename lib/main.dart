// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vokeo/controller/providers/comments/comment_provider.dart';
import 'package:vokeo/controller/providers/edit_posts/edit_post_provider.dart';
import 'package:vokeo/controller/providers/home_provider.dart';
import 'package:vokeo/controller/providers/posts/post_provider.dart';
import 'package:vokeo/controller/providers/user_provider.dart';
import 'package:vokeo/views/authentication_screens/signin_screen.dart';
import 'package:vokeo/controller/utils/utils.dart';
import 'views/bottom_nav/bottom_nav_screen.dart';

// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   LocalNotificationService.initialize();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   ErrorWidget.builder = (FlutterErrorDetails details) {
//     return const Center(
//       child: CircularProgressIndicator(
//         color: Colors.white,
//       ),
//     );
//   };
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCVlAzOvDD7dYYw8ILGRuxnX6gyFck5d_0",
            appId: "1:660454702638:android:d5322f45f086e0268429bf",
            messagingSenderId: "660454702638	",
            projectId: "vokeo-4db4d",
          ),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostCardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditPostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentProvider(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vokeo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
              .copyWith(background: Colors.black),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const BottomNavScreen();
              }
              if (snapshot.hasError) {
                showSnackbar(
                  context,
                  snapshot.error.toString(),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const SigninScreen();
          },
        ),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.toString());
}
