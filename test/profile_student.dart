import 'package:flutter/material.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/models/user.dart';

class StudentProfile extends StatelessWidget {
  final MyUser? user;

  const StudentProfile({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background1, 
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.keyboard_arrow_left,color: AppColors.text2,)
              );
            }
          ),
          title: const Text(
            'Profilo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: AppColors.text2
            ),
          ),
          backgroundColor: AppColors.background1,
          elevation: 0,
        ),
      )
    );
  }
}