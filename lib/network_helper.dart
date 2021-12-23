import 'package:login/constants.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:convert' as convert;

Future post(String endPoint, Map<String, dynamic> body) async {
  Uri uri = Uri.parse(baseUrl + endPoint);
  return await http.post(
    uri,
    headers: {
      "content-type": "application/json",
      "v": "1.0.5",
      "ApiKey": "eynpaQcc7nihvcYuZOuU0TeP7tlNC6o5",
      "ArtistId": "5eccb7e918a01f39da4b1b82",
      "Product": "desiplex",
      "Platform": "android"
    },
    body: convert.jsonEncode(body),
  );
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult == ConnectivityResult.mobile) ||
      (connectivityResult == ConnectivityResult.wifi);
}
