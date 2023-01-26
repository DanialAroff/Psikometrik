import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ConnectivityStatus {
  bool _isConnectionSuccessful = true;

  Future tryConnection() async {
    // have to use other functions if app running from web
    try {
      debugPrint('internet_connection.dart@WEB - $kIsWeb');
      if (kIsWeb) {
        // final response = await InternetAddress.lookup('google.com');
        final response = await http.get(Uri.parse('google.com'));
        _isConnectionSuccessful = response.statusCode == 200 ? true : false;
      } else {
        final response = await http.get(Uri.parse('https://google.com'));
        _isConnectionSuccessful = response.statusCode == 200 ? true : false;
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      _isConnectionSuccessful = false;
    }
    return _isConnectionSuccessful;
  }
}
