import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/error_screen.dart';
import 'package:fyp1/appscreens/home/home_admin.dart';
import 'package:fyp1/appscreens/home/home_student.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/shared/loading.dart';
import 'package:fyp1/shared/globals.dart' as globals;
import 'package:provider/provider.dart';

class Direct extends StatelessWidget {
  final String? uid;
  const Direct({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyUser>(
      future: Provider.of<Future<MyUser>>(context),
      builder: (BuildContext context, AsyncSnapshot<MyUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else {
          if (snapshot.hasError) {
            return const ErrorScreen();

          } else {
            // debugPrint('direct.dart@ User role : ${snapshot.data!.userRole}');
            if (snapshot.data == null) {
              return const ErrorScreen();
            }
            MyUser userModel = MyUser(
                uid: uid,
                email: snapshot.data?.email,
                fullName: snapshot.data?.fullName,
                userRole: snapshot.data?.userRole);
            globals.userModel = userModel;

            if (snapshot.data?.userRole == 'admin') {
              return AdminHomePage(user: userModel);
            } else {
              debugPrint('direct.dart@ User: ${userModel.toString()}');
              // return Provider<MyUser>.value(
              //   value: userModel,
              //   child: const StudentHomePage(),
              // );
              // if provider myuser has value then return studenthomepage
              return const StudentHomePage();
            }
          }
        }
      },
    );
  }
}
