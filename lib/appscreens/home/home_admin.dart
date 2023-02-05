import 'package:flutter/material.dart';
import 'package:fyp1/main.dart';
// import 'package:flutter/services.dart';
import 'package:fyp1/models/user.dart';
// import 'package:fyp1/services/auth.dart';
import 'package:fyp1/services/database.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/constants.dart';
import 'package:fyp1/shared/drawer.dart';
import 'package:fyp1/shared/loading.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, required this.user}) : super(key: key);
  final MyUser user;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DateTime? currentBackPressTime;
  TextEditingController searchController = TextEditingController();
  late FocusNode focusNode;
  // final AuthService _auth = AuthService();
  String searchQuery = '';
  // List<String> suggestions = ['A', 'B', 'C', 'Danial Harith', 'E', 'F', 'I'];
  List<MyUser> userList = [];
  List<MyUser> _searchedUsers = [];
  bool isSearching = false;
  bool isListComplete = false;
  MyUser? user;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    Future<List<MyUser>> future = DatabaseService().getUserList();
    future.then((value) => userList = value);
    future.whenComplete(() => isListComplete = true);

    Future.delayed(Duration.zero, () {
      _initUser().then((value) {
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

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<MyUser> _initUser() async {
    MyUser user = await Provider.of<Future<MyUser>>(context, listen: false);
    debugPrint('home_admin.dart@ USER: $user');
    return user;
  }
  
  Future<void> _filterSuggestions(String query) async {
    // userList = await DatabaseService().getUserList();
    while (!isListComplete) {}
    if (query.isEmpty) {
      _searchedUsers = [];
    } else {
      _searchedUsers = userList
          .where((e) => e.fullName!.toLowerCase().contains(query))
          .toList();
      debugPrint('home_admin.dart@_filterSuggestions $_searchedUsers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _promptExit,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                if (isSearching) {
                  // FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isSearching = false;
                  });
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
              icon: Icon(isSearching ? Icons.arrow_back : Icons.menu,
                  color: AppColors.text2),
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
        drawer: AdminAppDrawer(user: widget.user),
        body: SafeArea(
            right: false,
            left: false,
            child: Container(
              color: AppColors.background1,
              child: isSearching
                  ? _searchView()
                  : ListView(
                      padding: const EdgeInsets.all(10.0),
                      children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  // controller: searchController,
                                  // focusNode: focusNode,
                                  decoration: searchInputDecoration,
                                  cursorColor: AppColors.text2,
                                  maxLines: 1,
                                  onTap: () {
                                    setState(() {
                                      isSearching = true;
                                    });
                                  },
                                  onChanged: (value) => {
                                    setState(() {
                                      debugPrint('home_admin.dart@ $value');
                                      searchQuery = value;
                                      isSearching = true;
                                    })
                                  },
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Statistik',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _displayStats(),
                              const SizedBox(height: 12.0),
                              const Text(
                                'Intervensi Kaunselor',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              _displayNeedStudents(),
                            ],
                          ),
                        ]),
            )),
      ),
    );
  }

  Widget _displayStats() {
    // return Card(
    //   elevation: 0,
    //   color: Colors.white,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         RichText(
    //           text: const TextSpan(children: <TextSpan>[
    //             TextSpan(
    //                 text: 'Jumlah Pelajar',
    //                 style: TextStyle(color: AppColors.text2)),
    //             TextSpan(
    //                 text: '\n200',
    //                 style: TextStyle(
    //                   color: AppColors.secondary,
    //                   fontSize: 24,
    //                 ))
    //           ]),
    //         ),
    //         const SizedBox(height: 8.0),
    //         _numberOfAttempts('Inventori Kematangan Kerjaya', '100'),
    //         _numberOfAttempts('Inventori Minat Kerjaya', '100'),
    //         _numberOfAttempts('Inventori Trait Personaliti', '100'),
    //       ],
    //     ),
    //   ),
    // );
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Column(
              children: const [
                Text('Jumlah', style: TextStyle(color: Colors.white, fontSize: 20)),
                Text('289', style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              _countCard('Inventori Minat Kerjaya', '200/200'),
              const SizedBox(width: 8.0),
              _countCard('Inventori Kematangan Kerjaya', '200/200'),
              const SizedBox(width: 8.0),
              _countCard('Inventori Trait Personaliti', '200/200'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _displayNeedStudents() {
    return Card(
        elevation: 0,
        color: Colors.white,
        child: FutureBuilder<List<MyUser>>(
          future: getStudentIk(),
          builder:
              (BuildContext context, AsyncSnapshot<List<MyUser>> snapshot) {
            if (snapshot.hasError) {
              return const Text("Ralat");
            }
            if (!snapshot.hasData) {
              return const ScoreLoading();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List<MyUser> users = snapshot.data!;
              for (MyUser user in users) {
                debugPrint('$user');
              }
              return Column(
                children: [
                  for (MyUser user in users)
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        const Icon(Icons.person, color: AppColors.grayIcon),
                        const SizedBox(width: 8.0),
                        Text('${user.fullName}')
                      ]),
                    ),
                ],
              );
            }

            return const ScoreLoading();
          },
        )
        // child: const Text('placeholder'),
        );
  }

  /// Takes the 2 arguments; title and count and return an Expanded widget that
  /// displays the numbers in container
  Widget _countCard(title, count) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          children: [
            Center(
              child: Text(
                '$title',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
                child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            )),
          ],
        ),
      ),
    );
  }

  Widget _searchView() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: searchController,
              focusNode: focusNode,
              autofocus: true,
              decoration: searchInputDecoration,
              cursorColor: AppColors.text2,
              maxLines: 1,
              onTap: () {
                setState(() {
                  isSearching = true;
                });
              },
              onChanged: (value) async {
                await _filterSuggestions(value);
                setState(() {
                  searchQuery = value;
                  debugPrint('home_admin.dart@onChanged $value');
                  debugPrint('home_admin.dart@onChanged $_searchedUsers');
                });
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(0),
              child: _searchedUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchedUsers.length,
                      itemBuilder: (context, index) {
                        final MyUser user = _searchedUsers[index];
                        return Material(
                          child: ListTile(
                            title: Text('${user.fullName}'),
                            onTap: () {},
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.search_off_outlined,
                              size: 32, color: AppColors.grayIcon),
                          SizedBox(height: 4.0),
                          Text(
                            'Tiada hasil ditemui',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.gray),
                          )
                        ],
                      ),
                    )),
          // ListView.builder(
          //   itemBuilder: itemBuilder
          // )
        ],
      ),
    );
  }

  // Return a list of students who need counselor's intervention
  Future<List<MyUser>> getStudentIk() async {
    List<MyUser> intervStudents = [];
    userList = await DatabaseService().getUserList();
    // for (MyUser user in userList) {
    //   if (user.userRole == 'student') {
    //     double? totalScore =
    //         await DatabaseService().getTotalIKKScore(user.uid!);
    //     if (totalScore! < 50) {
    //       intervStudents.add(user);
    //     }
    //   }
    // }
    await Future.forEach(userList, (MyUser user) async {
      if (user.userRole == 'student') {
        double? totalScore =
            await DatabaseService().getTotalIKKScore(user.uid!);
        if (totalScore! < 50) {
          intervStudents.add(user);
        }
      }
    });
    debugPrint('students need intervention - $intervStudents $userList');
    return intervStudents;
  }

  // Ask user for the second time to confirm exit
  // Reference: https://stackoverflow.com/questions/53496161/how-to-write-a-double-back-button-pressed-to-exit-app-using-flutter
  Future<bool> _promptExit() async {
    DateTime now = DateTime.now();
    if (isSearching) {
      setState(() {
        isSearching = false;
      });
      return Future.value(false);
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tekan sekali lagi untuk keluar'),
        ));
        debugPrint('home_admin.dart@_promptExit - false');
        getStudentIk();
        return Future.value(false);
      }
      debugPrint('home_admin.dart@_promptExit - true');
    }

    return Future.value(true);
  }
}
