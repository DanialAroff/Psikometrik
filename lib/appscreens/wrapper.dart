import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/authenticate/authenticate.dart';
import 'package:fyp1/models/user_id.dart';
import 'package:fyp1/services/internet_connection.dart';
import 'package:provider/provider.dart';
import 'direct.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId?>(context);
    // String id = user != null ? user.uid : '';

    if (user != null) {
      return Direct(uid: user.uid);
    }
    // If user = null then redirect to auth page
    return const Authenticate();
  }

  dynamic connectionStatus() async {
    final stats = await ConnectivityStatus().tryConnection();
    return stats;
  }
}
