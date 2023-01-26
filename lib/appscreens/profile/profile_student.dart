import 'package:flutter/material.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/models/user.dart';
// import 'package:provider/provider.dart';

class StudentProfile extends StatelessWidget {
  final MyUser user;

  const StudentProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('profile_student.dart@ User: $user');
    return Scaffold(
      backgroundColor: AppColors.background1,
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: AppColors.text2,
              ));
        }),
        title: const Text(
          'Profil',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: AppColors.text2),
        ),
        backgroundColor: AppColors.background1,
        elevation: 0,
      ),
      body: SafeArea(
          right: false,
          left: false,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                children: [
                  userDetail('Nama', user.fullName ?? ''),
                  const SizedBox(
                    height: 8.0,
                  ),
                  userDetail('Emel', user.email ?? ''),
                  const SizedBox(
                    height: 8.0,
                  ),
                  userDetail('UID', user.uid ?? ''),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 80.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color.fromARGB(255, 229, 229, 229).withOpacity(0.15),
                      //     blurRadius: 12.0,
                      //     spreadRadius: 0.0,
                      //   )
                      // ]
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.key, color: AppColors.gray),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text('Tukar Kata Laluan'),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              // To change pass page
                            },
                            icon: const Icon(Icons.keyboard_arrow_right))
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget userDetail(String title, String value) {
    return Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.text2,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.text2,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
