import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/psychometrictest/inventori_kematangan_kerjaya.dart';
import 'package:fyp1/appscreens/psychometrictest/inventori_minat_kerjaya.dart';
import 'package:fyp1/appscreens/psychometrictest/inventori_trait_personaliti.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:fyp1/shared/string_extension.dart';
import 'appcolors.dart';

class TestCard extends StatelessWidget {
  final String testCode;
  final MyUser? user;
  const TestCard({Key? key, required this.testCode, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String testName = testCodeNames[testCode]!;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Card(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 2.0,
                  offset: const Offset(0, 2.0),
                  spreadRadius: 1.0,
                )
              ],
              gradient: const LinearGradient(colors: [
                AppColors.primary,
                AppColors.primary,
              ], begin: Alignment.topCenter)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                // Format test name to title case
                testName.replaceAll('_', ' ').titleCase,
                style: const TextStyle(
                    fontFamily: primaryFont,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.start,
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  debugPrint('testcard.dart@ Selecting $testCode');
                  if (testCode == 'IKK') {
                    _routeTo(
                        context,
                        PsychometricTestIKK(
                          user: user!,
                          testCode: testCode,
                        ));
                  } else if (testCode == 'ITP') {
                    _routeTo(context,
                        PsychometricTestITP(user: user!, testCode: testCode));
                  } else if (testCode == 'IMK') {
                    _routeTo(context,
                        PsychometricTestIMK(user: user!, testCode: testCode));
                  }
                },
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(130, 40),
                    side: const BorderSide(color: Colors.white, width: 0.8),
                    splashFactory: InkRipple.splashFactory),
                child: const Text(
                  'Jawab Ujian',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: primaryFont,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _routeTo(BuildContext context, testPage) {
  Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (_, __, ___) => testPage,
          transitionDuration: Duration.zero));
}
