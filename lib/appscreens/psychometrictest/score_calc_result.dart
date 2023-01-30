import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/wrapper.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/string_extension.dart';
import 'package:page_transition/page_transition.dart';

class TestResultScreen extends StatelessWidget {
  final Map<String, dynamic> scores;
  const TestResultScreen({Key? key, required this.scores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Column(children: <Widget>[
                const Text(
                  'Skor Trait Personaliti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.text1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 32.0),
                const SizedBox(
                  height: 32.0,
                ),
                Divider(
                  color: AppColors.text1.withOpacity(0.4),
                ),
                // Trait score
                Column(
                  children: [
                    for (var trait in scores.keys)
                      _traitScore(trait.inCaps, scores[trait])
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Spacer(),
                ElevatedButton(
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
                                BorderRadius.all(Radius.circular(12.0))),
                        minimumSize: const Size(double.infinity, 48.0)),
                    child: const Text(
                      'Kembali ke Laman Utama',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _traitScore(trait, score) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            '$trait',
            style: const TextStyle(fontSize: 18.0),
          ),
          const Spacer(),
          Text(
            '${score.toInt()}%',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
