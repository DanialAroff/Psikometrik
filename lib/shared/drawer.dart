import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/profile/profile_student.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/shared/dialogs.dart';

const Color iconColor = AppColors.darkGrayIcon;

class AppDrawer extends StatelessWidget {
  final MyUser user;

  const AppDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('drawer.dart@ $user');
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito Sans',
                    fontSize: 12,
                  ),
                ),
                Text(
                  user.fullName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito Sans',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                menuItem(Icons.home_outlined, 'Laman Utama'),
                menuItem(Icons.person_outline, 'Profil', onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              StudentProfile(user: user),
                          transitionDuration: Duration.zero));
                }),
                menuItem(Icons.logout, 'Log Keluar', onTap: () {
                  Dialogs().logOutConfirmation(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminAppDrawer extends StatelessWidget {
  final MyUser user;

  const AdminAppDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 4.0),
            menuItem(Icons.home_outlined, 'Laman Utama', active: false),
            menuItem(Icons.logout, 'Log Keluar', onTap: () {
              Dialogs().logOutConfirmation(context);
            })
          ],
        ),
      ),
    );
  }
}

Widget menuItem(IconData icon, String title,
    {VoidCallback? onTap, bool active = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: InkWell(
      onTap: onTap ?? () {},
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      // splashColor: AppColors.secondary,
      splashColor: AppColors.secondaryTransparent,
      highlightColor: AppColors.secondaryTransparent,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text(
          title,
          style: TextStyle(color: active ? AppColors.primary : AppColors.text2),
        ),
        tileColor: active ? AppColors.primary.withOpacity(0.3) : null,
        leading: Icon(icon,
            color: active ? AppColors.primary.withOpacity(0.8) : iconColor),
      ),
    ),
  );
}
