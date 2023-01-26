import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/psychometrictest/score_calc_result.dart';
import 'package:fyp1/models/item_options.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/services/database.dart';
import 'package:fyp1/services/score_calculation.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:fyp1/shared/dialogs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:fyp1/shared/constants.dart';

class PsychometricTestIMK extends StatefulWidget {
  const PsychometricTestIMK(
      {Key? key, required this.user, required this.testCode})
      : super(key: key);
  final MyUser user;
  final String testCode;

  @override
  State<PsychometricTestIMK> createState() => _PsychometricTestIMKState();
}

class _PsychometricTestIMKState extends State<PsychometricTestIMK> {
  Dialogs dialogs = Dialogs();
  StreamSubscription? subscription;
  final PageController _pageController = PageController(initialPage: 0);
  final num maxItemPerPage = 10;
  int pageNumber = 0;
  int totalPages = 1; // no of pages; default/minimum is 1
  List<DocumentSnapshot> documents = []; // documents of IMK items
  List<ItemIMK> items = []; // Holds every item in IMK
  List<List<ItemIMK>> pageList = []; // List of items in pages

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        dialogs.noInternetConnectionDialog(context);
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background1,
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () async {
                bool confirmation = await dialogs.confirmLeaveTest(context);

                if (!mounted) return;
                if (confirmation) {
                  debugPrint("inventori_minat_kerjaya.dart@ Leaving page");
                  Navigator.pop(context);
                } else {
                  debugPrint("");
                }
              },
              icon:
                  const Icon(Icons.keyboard_arrow_left, color: AppColors.text2),
            );
          }),
          title: const Text(
            'Inventori Minat Kerjaya',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: AppColors.text2),
          ),
          backgroundColor: AppColors.background1,
          elevation: 0,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: DatabaseService().testItems(widget.testCode),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text('Ralat');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              // QuerySnapshot.docs to get a list of document snapshot
              // docs on test items
              documents = snapshot.data.docs;
              if (items.isEmpty) {
                for (var i = 0; i < documents.length; i++) {
                  DocumentSnapshot doc = documents[i];
                  items.add(ItemIMK(
                      index: i,
                      question: doc['question'],
                      type: doc['type'],
                      selectedAnswer: ''));
                }
              }
              totalPages = (documents.length / maxItemPerPage).ceil().toInt();
              // Can't use List.add cause it will insert the same instance of List
              // object to the whole list.
              // Use List.generate() instead
              pageList = List.generate(totalPages, (index) => []);
              for (var j = 0; j < documents.length; j++) {
                int page = (j / maxItemPerPage).floor();
                List<ItemIMK> currentPage = pageList[page];
                currentPage.add(items[j]);
              }
            }
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            pageNumber = index;
                          });
                        },
                        children: <Widget>[
                          for (var items in pageList) ...[
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: items.length,
                              addAutomaticKeepAlives: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  shadowColor: AppColors.gray.withOpacity(0.15),
                                  child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Question number and question
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Text(
                                                  '${items[index].index + 1}.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  items[index].question,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 24.0),

                                          // Choice of answers
                                          SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Option(
                                                    value: 'Ya',
                                                    theme: yesTheme,
                                                    selectedAnswer: items[index]
                                                        .selectedAnswer,
                                                    onTap: () {
                                                      setState(() {
                                                        items[index]
                                                                .selectedAnswer =
                                                            'Ya';
                                                      });
                                                    }),
                                                const SizedBox(height: 8.0),
                                                Option(
                                                    value: 'Tidak',
                                                    theme: noTheme,
                                                    selectedAnswer: items[index]
                                                        .selectedAnswer,
                                                    onTap: () {
                                                      setState(() {
                                                        items[index]
                                                                .selectedAnswer =
                                                            'Tidak';
                                                      });
                                                    })
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              })
                        ]
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Text(
                          'm.s ${pageNumber + 1}/$totalPages',
                          style: const TextStyle(
                              color: AppColors.gray,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _isCompleted(items)
                              ? () {
                                  _submitTest(items);
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return AppColors.disabled;
                              } else {
                                return AppColors.option;
                              }
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            minimumSize:
                                MaterialStateProperty.all(const Size(96, 40)),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: const Text('Tamat Ujian'),
                        ),
                      ],
                    ),
                  ),
                )
                ],
              ),
            );
          },
        ));
  }

  bool _isCompleted(List<ItemIMK> items) {
    var answers = ['Ya', 'Tidak'];
    for (ItemIMK item in items) {
      if (!answers.contains(item.selectedAnswer)) {
        return false;
      }
    }
    return true;
  }

  void _submitTest(items) async {
    dynamic confirm = await dialogs.confirmTestCompletion(context);

    if (!mounted) return;
    if (confirm) {
      Map<String, dynamic> scores = ScoreCalculation().calcIMKScore(items);
      await DatabaseService(uid: widget.user.uid).updateIMKScore(scores);
      if (!mounted) return;
      debugPrint('SCORES: ${scores.keys}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestResultScreen(
                  scores: scores,
                )),
      );
    }
  }
}
