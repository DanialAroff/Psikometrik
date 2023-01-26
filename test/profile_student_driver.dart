import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'testvalues/test_object.dart';
import 'package:fyp1/appscreens/profile/profile_student.dart';
import 'package:fyp1/shared/appcolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCjglAu-JvXUF_KcXq65ry-HzAji3EpR1Q",
        appId: "1:508220552077:android:37630b4df037c9ae2fc3c4",
        messagingSenderId: "508220552077",
        projectId: "fyp-pt"));
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentProfile(
        user: testUser1,
      ),
      theme: ThemeData(
        fontFamily: 'Nunito Sans',
        unselectedWidgetColor: AppColors.primary
      ),
    );
  }
}
