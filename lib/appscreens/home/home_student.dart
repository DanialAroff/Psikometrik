import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/error_screen.dart';
import 'package:fyp1/main.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/services/database.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:fyp1/shared/loading.dart';
import 'package:fyp1/shared/drawer.dart';
import 'package:fyp1/shared/scorecards.dart';
import 'package:fyp1/shared/string_extension.dart';
import 'package:fyp1/shared/testcard.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  DateTime? currentBackPressTime;
  List<String> testCodes = ['IKK', 'ITP', 'IMK'];
  MyUser? user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initUser().then((value) {
        debugPrint('home_student.dart@ INITUSER: ${value.userRole}');
        Provider<MyUser>.value(value: value);
        if (value.userRole != 'student') {
          return const MyApp();
        }
        setState(() {
          user = value;
        });
      });
    });
  }

  Future<MyUser> _initUser() async {
    Future future = Provider.of<Future<MyUser>>(context, listen: false);
    MyUser user = await future;
    debugPrint('home_student.dart@ USER: ${user.userRole}');
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // final user = defaultUser;
    return WillPopScope(
      onWillPop: _promptExit,
      child: user == null
          ? const Loading()
          : Scaffold(
              appBar: AppBar(
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: AppColors.text2),
                  );
                }),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Selamat Datang',
                          style:
                              TextStyle(fontSize: 11, color: AppColors.text2)),
                      TextSpan(
                          text: '\n${user!.fullName}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text2)),
                    ],
                  ),
                ),
                backgroundColor: AppColors.background1,
                elevation: 0,
              ),
              drawer: AppDrawer(user: user!),
              body: SafeArea(
                right: false,
                left: false,
                // Main container
                child: Container(
                  color: AppColors.background1,
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              'Ujian Psikometrik',
                              style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text2),
                            ),
                          ),
                          // The test cards
                          for (var i = 0; i < testCodes.length; i++)
                            TestCard(testCode: testCodes[i], user: user),
                          const SizedBox(height: 6.0),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // SKOR UJIAN
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              'Skor Ujian',
                              style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text2),
                            ),
                          ),
                          FutureBuilder(
                            future:
                                DatabaseService(uid: user!.uid).isScoreExists(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ScoreLoading();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done && snapshot.data == true) {
                                return Column(
                                  children: [
                                    // Test Score Cards
                                    _scores('IKK', user!),
                                    const SizedBox(height: 12),
                                    _scores('ITP', user!, personalityTraits),
                                    const SizedBox(height: 12),
                                    _scores('IMK', user!, personalityTypes)
                                  ],
                                );
                              }
                              return Container(
                                constraints: const BoxConstraints(
                                  minHeight: 100,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white
                                ), 
                                child: const Center(
                                  child: Text('Tiada data', style: TextStyle(
                                    color: AppColors.gray
                                  ),),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  StreamBuilder<DocumentSnapshot> _scores(String testCode, MyUser user,
      [List<String>? construct]) {
    String testName = testCodeNames[testCode] ?? '';
    return StreamBuilder(
        stream: DatabaseService(uid: user.uid).currentUserScore(testName),
        builder: (BuildContext buildContext,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.exists) {
              return ScoreCard(
                  scores: snapshot.data!,
                  title: testName.replaceAll('_', ' ').titleCase,
                  construct: construct);
            } else {
              debugPrint('home_student.dart@ No snapshot data');
              return const SizedBox.shrink();
            }
          } else {
            // need to add a spinkit
            return const ScoreLoading();
          }
        });
  }

  // Ask user for the second time to confirm exit
  // Reference: https://stackoverflow.com/questions/53496161/how-to-write-a-double-back-button-pressed-to-exit-app-using-flutter
  Future<bool> _promptExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tekan sekali lagi untuk keluar'),
      ));
      debugPrint('home_student.dart@_promptExit - false');
      return Future.value(false);
    }
    debugPrint('home_student.dart@_promptExit - true');
    return Future.value(true);
  }
}
