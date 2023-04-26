import 'package:chat/providers/api_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> registerUser(
    String username, String email, String password, String gender) async {
  final url = Uri.parse(registerApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'email': email,
    'password': password,
    'gender': gender
  });
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        print('User registered successfully!');
        final user = responseData['user'];
        return true;
        // We get user object i.e. responseData['user'] from the registerApi, we can do anything onto it now.
      } else {
        final msg = responseData['msg'];
        print(msg);
        return false;
        // This will include an error as to why user was not registered successfully.
      }
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}

Future<bool> loginUser(String username, String password) async {
  final url = Uri.parse(loginApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'username': username, 'password': password});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        final user = responseData['user'];
        final pref = await SharedPreferences.getInstance();
        pref.setBool('isLoggedIn', true);
        pref.setString('userName', username);
        pref.setString('userData', response.body);
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
