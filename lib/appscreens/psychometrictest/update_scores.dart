import 'package:flutter/material.dart';
import 'package:fyp1/shared/globals.dart' as globals;
import 'package:fyp1/services/database.dart';

class UpdateIKKScore {
  final num dsScore;
  final num dkScore;
  num dsPercentageScore = 0.0;
  num dkPercentageScore = 0.0;
  num totalPercentage = 0.0;

  UpdateIKKScore(this.dsScore, this.dkScore) {
    _init();
  }

  void _init() {
    _calculatePercentageForEachDomain();
    _calculateTotalPercentage();
  }

  _calculatePercentageForEachDomain() {
    dsPercentageScore = dsScore / globals.dsItemCount.toDouble() * 100;
    dkPercentageScore = dkScore / globals.dkItemCount.toDouble() * 100;
  }

  _calculateTotalPercentage() {
    totalPercentage = (dsScore + dkScore) * 2;
  }

  Future updateScoretoFirebase() async {
    String? uid = globals.userModel.uid;
    debugPrint('update_scores.dart@ Updating....');
    return await DatabaseService(uid: uid)
        .updateIKKScore(dsPercentageScore, dkPercentageScore);
  }
}

class UpdateITPScore {
  // find percentage for every traits 
  final num score = 0;
  
  Future updateScoretoFirebase() async {
    // String? uid = 
    // return await DatabaseService(uid: uid)
  }
}
