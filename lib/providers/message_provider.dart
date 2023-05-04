import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_routes.dart';

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
      return jsonDecode(response.body);
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}

Future<bool> sendMessage(String message, String from, String to) async {
  final url = Uri.parse(sendmessageapi);

  // final id = jsonDecode(pref.getString('userId'));
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'from': from, 'to': to, 'message': message});
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
    } else {
      return false;
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}

Future<dynamic> getMessage(String from, String to) async {
  final url = Uri.parse(getmessageapi);

  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'from': from, 'to': to});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}

Future<dynamic> deleteMessage(String from, String to) async {
  final url = Uri.parse(deletemessageapi);

  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'from': from, 'to': to});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}

Future<bool> rateUser(String id, int rating) async {
  final url = Uri.parse(rateUserApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id, 'ratingval': rating});
  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}
