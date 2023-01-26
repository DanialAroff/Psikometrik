// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/wrapper.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/services/auth.dart';
import 'package:fyp1/services/database.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/models/user_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCjglAu-JvXUF_KcXq65ry-HzAji3EpR1Q",
          appId: "1:508220552077:android:37630b4df037c9ae2fc3c4",
          messagingSenderId: "508220552077",
          projectId: "fyp-pt"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserId?>.value(
            value: AuthService().userId, initialData: UserId('not-logged-in')),
        ProxyProvider<UserId?, Future<MyUser>?>(
          // create: (BuildContext context) => DatabaseService(
          //         uid: Provider.of<UserId?>(context, listen: false)!.uid)
          //     .getUser,
          update: (BuildContext context, UserId? id, Future<MyUser>? user) {
            if (id != null) {
              return DatabaseService(uid: id.uid).getUser;
            }
            return null;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
        theme: ThemeData(
            fontFamily: 'Nunito Sans',
            unselectedWidgetColor: AppColors.primary),
      ),
    );
  }
}
