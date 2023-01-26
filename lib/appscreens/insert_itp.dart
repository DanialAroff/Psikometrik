import 'package:fyp1/services/database.dart';
import 'package:flutter/material.dart';

class InsertITP extends StatelessWidget {
  const InsertITP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ElevatedButton(
        onPressed: () async {
          debugPrint('insert_itp.dart@ Insert ITP items now');
          DatabaseService().insertITPItems();
        },
        child: const Text('Insert Data'),
      ),
    );
  }
}
