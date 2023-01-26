import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/models/item_options.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/services/database.dart';
import 'package:fyp1/services/score_calculation.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:fyp1/shared/dialogs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'score_calc_result.dart';

class PsychometricTestITP extends StatefulWidget {
  const PsychometricTestITP(
      {Key? key, required this.user, required this.testCode})
      : super(key: key);
  final MyUser user;
  final String testCode;

  @override
  State<PsychometricTestITP> createState() => _PsychometricTestITPState();
}

class _PsychometricTestITPState extends State<PsychometricTestITP> {
  Dialogs dialogs = Dialogs();
  // true if the connection lost dialog is showing
  dynamic connectionDialog;
  StreamSubscription? subscription;
  final PageController _pageController = PageController(initialPage: 0);
  final num maxItemPerPage = 15;
  int pageNumber = 0;
  int totalPages = 1; // no of pages; default/minimum is 1
  List<DocumentSnapshot> documents = []; // documents of ITP items
  List<ItemITP> items = []; // Holds every item in ITP
  List<List<ItemITP>> pageList = []; // List of items in pages

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        connectionDialog = dialogs.noInternetConnectionDialog(context);
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        // if (connectionDialog != null) {
        //   Navigator.pop(context);
        // }
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription!.cancel();
    items.clear();
  }

  // PageView and PageController for multiple pages
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
                debugPrint("inventori_trait_personaliti.dart@ Leaving page");
                Navigator.pop(context);
              } else {
                debugPrint("");
              }
            },
            icon: const Icon(Icons.keyboard_arrow_left, color: AppColors.text2),
          );
        }),
        title: const Text(
          'Inventori Trait Personaliti',
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
                items.add(ItemITP(
                    index: i,
                    question: doc['question'],
                    answer: doc['answer'],
                    trait: doc['trait'],
                    selectedAnswer: ''));
              }
            }

            // Pre select for testing
            for (ItemITP item in items) {
              if (item.selectedAnswer == '') {
                item.selectedAnswer = 'Ya';
              }
            }

            totalPages = (documents.length / maxItemPerPage).ceil().toInt();
            debugPrint(
                'inventori_trait_personaliti.dart@ Total pages: $totalPages');
            // Can't use List.add cause it will insert the same instance of List
            // object to the whole list.
            // Use List.generate() instead
            pageList = List.generate(totalPages, (index) => []);
            for (var j = 0; j < documents.length; j++) {
              int page = (j / maxItemPerPage).floor();
              List<ItemITP> currentPage = pageList[page];
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
                                                width: 36.0,
                                                child: Text(
                                                  '${items[index].index + 1}.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                              ),
                                              const SizedBox(width: 4.0),
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
                        if (pageNumber > 0) ...[
                          navigatePageButton(
                              pageNumber, _pageController, -1, '<')
                        ],
                        const SizedBox(width: 6.0),
                        pageNumber < totalPages - 1
                            ? navigatePageButton(
                                pageNumber, _pageController, 1, '>')
                            : ElevatedButton(
                                onPressed: _isCompleted(items)
                                    ? () {
                                        _submitTest(items);
                                      }
                                    : null,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return AppColors.disabled;
                                    } else {
                                      return AppColors.option;
                                    }
                                  }),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(96, 40)),
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
      ),
    );
  }

  bool _isCompleted(List<ItemITP> items) {
    var answers = ['Ya', 'Tidak'];
    for (ItemITP item in items) {
      if (!answers.contains(item.selectedAnswer)) {
        return false;
      }
    }
    return true;
  }

  Widget navigatePageButton(
      int pageNumber, PageController pageController, int value, String text) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            pageNumber = pageNumber - 1;
            pageController.animateToPage(pageController.page!.toInt() + value,
                duration: const Duration(milliseconds: 110),
                curve: Curves.easeInOut);
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.option;
            } else {
              return Colors.white;
            }
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return AppColors.option;
          }),
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.option.withOpacity(0.5);
            }
            return Colors.transparent;
          }),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: AppColors.option, width: 0.85))),
          minimumSize: MaterialStateProperty.all(const Size(72, 40)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)));
    // child: const Icon(Icons.keyboard_arrow_right, ));
  }

  void _submitTest(items) async {
    dynamic confirm = await dialogs.confirmTestCompletion(context);

    if (!mounted) return;
    if (confirm) {
      Map<String, dynamic> scores = ScoreCalculation().calcITPScore(items);
      await DatabaseService(uid: widget.user.uid).updateITPScore(scores);
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
