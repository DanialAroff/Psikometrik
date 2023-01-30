import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/wrapper.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:fyp1/shared/globals.dart' as globals;

class TestResultScreen extends StatelessWidget {
  final num dsScore;
  final num dkScore;
  final num dsPercentageScore;
  final num dkPercentageScore;

  const TestResultScreen(
      {Key? key,
      this.dsScore = 0,
      this.dkScore = 0,
      this.dsPercentageScore = 0,
      this.dkPercentageScore = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num totalPercentage = (dsScore + dkScore) * 2;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.background1,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Text(
                      'Skor Inventori Kematangan Kerjaya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text1,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    CircularPercentIndicator(
                      radius: 125,
                      lineWidth: 12.0,
                      percent: totalPercentage / 100,
                      animation: true,
                      animationDuration: 1200,
                      reverse: true,
                      center: Text(
                        '$totalPercentage%',
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text2,
                        ),
                      ),
                      progressColor: AppColors.primary,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Divider(
                      color: AppColors.text1.withOpacity(0.4),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Domain Sikap',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const Spacer(),
                        Text(
                          '${dsPercentageScore.toInt()}%',
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Divider(
                    //   color: AppColors.text1.withOpacity(0.4),
                    // ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Domain Kecekapan',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const Spacer(),
                        Text(
                          '${dkPercentageScore.toInt()}%',
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Divider(
                    //   color: AppColors.text1.withOpacity(0.4),
                    // ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 48.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: const Wrapper(),
                                type: PageTransitionType.fade),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            )),
                        child: const Text(
                          'Kembali ke Laman Utama',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}