import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:http/http.dart';
import '../models/user_id.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email, String name, String role) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'name': name,
      'user_role': role,
    });
  }

  // Get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  // Get the current user logged in
  Stream<DocumentSnapshot> get currentUser {
    return userCollection.doc(uid).snapshots();
  }

  Future<MyUser> get getUser async {
    try {
      DocumentSnapshot userData = await userCollection.doc(uid).get();
      debugPrint('database.dart@getUser - User data: ${userData.data()}');
      if (userData.data() == null) {
        return defaultUser;
      }
      return MyUser.fromData(uid, userData.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint(
          'database.dart@getUser - Failed to fetch user data: ${e.toString()}');
      return defaultUser;
    }
  }

  Future<UserId> get getUserId async {
    try {
      DocumentSnapshot userData = await userCollection.doc(uid).get();
      return UserId(userData.id);
    } catch (e) {
      debugPrint('database.dart@ Failed to get user id ${e.toString()}');
      return UserId('X-000');
    }
  }

  Stream<DocumentSnapshot>? get currentUserIKKScore {
    try {
      CollectionReference scoreIKK = FirebaseFirestore.instance
          .collection('skor_inventori_kematangan_kerjaya');
      return scoreIKK.doc(uid).snapshots();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>>? getIKKScore(String uid) async {
    try {
      CollectionReference scoreIKK = FirebaseFirestore.instance
          .collection('skor_inventori_kematangan_kerjaya');
      DocumentSnapshot doc = await scoreIKK.doc(uid).get();
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      // debugPrint('database.dart@ ${map['domain_kecekapan']}');
      return map;
    } catch (e) {
      debugPrint(
          'database.dart@ Failed to get score: Score does not exist for user ($uid)');
      return Future.value({});
    }
  }

  Future<double>? getTotalIKKScore(String uid) async {
    try {
      double totalScore = 0;
      Map<String, dynamic>? map = await getIKKScore(uid);
      if (map != null) {
        totalScore = (map['domain_sikap'] + map['domain_kecekapan']) / 2;
      }
      return totalScore;
    } catch (e) {
      debugPrint('database.dart@ Failed to get total score for $uid');
      return Future.value(0.0);
    }
  }

  Stream<DocumentSnapshot>? currentUserScore(String testName) {
    String collectionName = 'skor_$testName';
    CollectionReference scoreCollection =
        FirebaseFirestore.instance.collection(collectionName);
    try {
      return scoreCollection.doc(uid).snapshots();
    } catch (e) {
      debugPrint('database.dart@ Failed to fetch score data: $e');
      return null;
    }
  }

  Future<bool?> isScoreExists() async {
    try {
      List<String> testNames = [
        'skor_inventori_kematangan_kerjaya',
        'skor_inventori_trait_personaliti',
        'skor_inventori_minat_kerjaya'
      ];
      bool exist = false;
      await Future.forEach(testNames, (test) async {
        CollectionReference scoreCollection =
            FirebaseFirestore.instance.collection(test.toString());
        dynamic doc = await scoreCollection.doc(uid).get();
        debugPrint('database.dart@ isScoreExists - >> ${doc.data()}');
        if (doc.exists) exist = true;
      });
      return exist;
    } catch (e) {
      return null;
    }
  }

  // Fetch all item of an inventory as a QuerySnapshot
  Future<QuerySnapshot> testItems(String testCode) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(testCodeNames[testCode]!);
    return await collection.get();
  }

  // Update score for Inventori Kematangan Kerjaya
  // taking the percentage score for Domain Sikap & Domain Kecekapan
  // as the parameters
  Future updateIKKScore(num dsPercentageScore, num dkPercentageScore) {
    CollectionReference scoreIKK = FirebaseFirestore.instance
        .collection('skor_inventori_kematangan_kerjaya');
    return scoreIKK.doc(uid).set({
      'domain_kecekapan': dkPercentageScore,
      'domain_sikap': dsPercentageScore,
    });
  }

  Future updateITPScore(Map<String, dynamic> scores) {
    CollectionReference scoreITP = FirebaseFirestore.instance
        .collection('skor_inventori_trait_personaliti');
    var input = {for (var v in personalityTraits) v: scores[v]};
    return scoreITP.doc(uid).set(input);
  }

  Future updateIMKScore(Map<String, dynamic> scores) {
    CollectionReference scoreIMK =
        FirebaseFirestore.instance.collection('skor_inventori_minat_kerjaya');
    var input = {for (var v in personalityTypes) v: scores[v]};
    return scoreIMK.doc(uid).set(input);
  }

  Future<List<MyUser>> getUserList() async {
    // return a list of maps
    // the maps structure is:
    // {user_role: role, name: name, email: email}
    try {
      QuerySnapshot snapshots = await userCollection
          .get(const GetOptions(source: Source.serverAndCache));

      List<Map<String, dynamic>> list = [];
      List<MyUser> userList = [];
      for (var doc in snapshots.docs) {
        dynamic data = doc.data();
        list.add(data);
        userList.add(MyUser(
            uid: doc.id,
            fullName: data['name'],
            email: data['email'],
            userRole: data['user_role']));
      }
      return userList;
    } catch (e) {
      debugPrint('database.dart@getUserList ${e.toString()}');
      return [];
    }
  }

  // UTILS
  // Insert ITP items into Firebase
  void insertITPItems() async {
    try {
      String initialDocName = 'itp_';

      CollectionReference imkCollection =
          FirebaseFirestore.instance.collection('inventori_trait_personaliti');
      var url = Uri.parse("https://api.npoint.io/8d877417412221f76bb4");
      Response response = await http.get(url);
      List data = jsonDecode(response.body);
      List<Map<String, dynamic>> items = [];
      for (var element in data) {
        items.add(element);
      }

      debugPrint('${items[0]['ITEM']}');

      var traitIndex = 0;
      for (var i = 0; i < items.length; i++) {
        String docName = initialDocName + (i + 1).toString().padLeft(3, '0');
        Map<String, dynamic> item = items[i];
        var trait = personalityTraits[traitIndex++];
        if (traitIndex % 15 == 0) {
          traitIndex = 0;
        }
        imkCollection
            .doc(docName)
            .set({'answer': 'Ya', 'question': item['ITEM'], 'trait': trait})
            .then((value) => debugPrint("Item $docName Added"))
            .catchError((error) => debugPrint("Failed to add: $error"));
      }
    } catch (e) {
      debugPrint('database.dart@ Error inserting ITP $e');
    }
  }

  void insertIMKItems() async {
    try {
      String initialDocName = 'itp_';

      CollectionReference imkCollection =
          FirebaseFirestore.instance.collection('inventori_minat_kerjaya');
      var url = Uri.parse("https://api.npoint.io/8d877417412221f76bb4");
      Response response = await http.get(url);
      List data = jsonDecode(response.body);
      List<Map<String, dynamic>> items = [];
      for (var element in data) {
        items.add(element);
      }

      debugPrint('${items[0]['ITEM']}');

      var traitIndex = 0;
      for (var i = 0; i < items.length; i++) {
        String docName = initialDocName + (i + 1).toString().padLeft(3, '0');
        Map<String, dynamic> item = items[i];
        var trait = personalityTypes[traitIndex++];
        if (traitIndex % 15 == 0) {
          traitIndex = 0;
        }
        imkCollection
            .doc(docName)
            .set({'answer': 'Ya', 'question': item['ITEM'], 'trait': trait})
            .then((value) => debugPrint("Item $docName Added"))
            .catchError((error) => debugPrint("Failed to add: $error"));
      }
    } catch (e) {
      debugPrint('database.dart@ Error inserting ITP $e');
    }
  }
}
