import 'package:chat/providers/api_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getFriends() async {
  final url = Uri.parse(getFriendsApi);
  final pref = await SharedPreferences.getInstance();
  final senderid = pref.getString('userId');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': senderid});
  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // final responseData = jsonDecode(response.body);
      // print(responseData);
      return jsonDecode(response.body);
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}


Future<bool> sendMessage(String message) async {
  final url = Uri.parse(sendMessageApi);
  final pref = await SharedPreferences.getInstance();
  final id = jsonDecode(pref.getString('userId'));
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id, 'message': message});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'sent') {
        return true;
        // do something with the user object
      } else {
        final msg = responseData['msg'];
        print(msg);
        return false;
        // handle error
      }
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}
