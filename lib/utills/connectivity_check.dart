

import 'dart:io';

Future<bool> checkConnectivity() async {

  bool isConnected=false;
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected=true;
      print('connected');
    }
  } on SocketException catch (_) {
    isConnected=false;
    print('not connected');
  }
  return isConnected;
}