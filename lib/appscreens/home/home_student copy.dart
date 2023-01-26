import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  const StudentHomePage({Key? key, required this.user}) : super(key: key);
  final MyUser user;

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  DateTime? currentBackPressTime;
  List<String> testCodes = ['IKK', 'ITP', 'IMK'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _promptExit,
      child: StreamProvider<DocumentSnapshot?>.value(
        value: DatabaseService(uid: widget.user.uid).currentUserIKKScore,
        initialData: null,
        child: Scaffold(
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
                      style: TextStyle(fontSize: 11, color: AppColors.text2)),
                  TextSpan(
                      text: '\n${widget.user.fullName}',
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
          drawer: AppDrawer(user: widget.user),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                        TestCard(testCode: testCodes[i], user: widget.user),
                      const SizedBox(height: 6.0),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SKOR UJIAN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text(
                          'Skor Ujian',
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text2),
                        ),
                      ),

                      // Test Scores
                      StreamBuilder<DocumentSnapshot>(
                          stream: DatabaseService(uid: widget.user.uid)
                              .currentUserIKKScore,
                          builder: (BuildContext buildContext,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data!.exists) {
                                return ScoreCard(
                                    scores: snapshot.data!,
                                    title: 'Inventori Kematangan Kerjaya');
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              // need to add a spinkit
                              return const ScoreLoading();
                            }
                          }),
                      const SizedBox(height: 12),
                      StreamBuilder<DocumentSnapshot>(
                          stream: DatabaseService(uid: widget.user.uid)
                              .currentUserScore('inventori_trait_personaliti'),
                          builder: (BuildContext buildContext,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data!.exists) {
                                return ScoreCard(
                                    scores: snapshot.data!,
                                    title: 'Inventori Trait Personaliti',
                                    construct: personalityTraits);
                              } else {
                                debugPrint(
                                    'home_student.dart@ No snapshot data');
                                return const SizedBox.shrink();
                              }
                            } else {
                              // need to add a spinkit
                              return const ScoreLoading();
                            }
                          }),
                      const SizedBox(height: 12),
                      _scores('IMK', personalityTypes)
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<DocumentSnapshot> _scores(String testCode,
      [List<String>? construct]) {
    String testName = testCodeNames[testCode] ?? '';
    return StreamBuilder(
        stream:
            DatabaseService(uid: widget.user.uid).currentUserScore(testName),
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
