import 'package:chat/providers/api_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> registerUser(String username, String email, String password,
    String gender, String avatarImage) async {
  final url = Uri.parse(registerApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'email': email,
    'password': password,
    'gender': gender,
    'avatarImage': avatarImage
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
        pref.setString('username', username);
        pref.setString(
            'randUser', jsonDecode(response.body)['user']['random_username']);
        pref.setString('userId', jsonDecode(response.body)['user']['_id']);
        pref.setString('email', jsonDecode(response.body)['user']['email']);
        pref.setString('gender', jsonDecode(response.body)['user']['gender']);
        pref.setBool(
            'isAvatar', jsonDecode(response.body)['user']['isAvatarImageSet']);
        pref.setString(
            'avatarImage', jsonDecode(response.body)['user']['avatarImage']);
        // pref.setString('friends', jsonDecode(response.body)['user']['friends']);
        // pref.setString(
        //     'onlineStatus', jsonDecode(response.body)['user']['onlineStatus']);
        // pref.setString('__v', jsonDecode(response.body)['user']['__v']);
        // print(pref.getString('userId'));
        // getUserInfo();
        print("okk");
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

Future<void> logoutUser() async {
  final pref = await SharedPreferences.getInstance();
  final id = pref.getString('userId');
  final url = Uri.parse(logoutApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id});

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      // handle successful logout
      pref.setBool('isLoggedIn', false);
      pref.remove('userName');
      pref.remove('userData');
    } else {
      // handle non-200 status code
    }
  } catch (e) {
    // handle exception
    print('An error occurred: $e');
  }
}

Future<void> setAvatar(String avatar) async {
  final pref = await SharedPreferences.getInstance();
  final id = jsonDecode(pref.getString('userId'));
  final url = Uri.parse(logoutApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id, 'avatar': avatar});

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {}
  } catch (e) {
    // handle exception
    print('An error occurred: $e');
  }
}

Future<bool> getUserInfo() async {
  final url = Uri.parse(getUserInfoApi);
  final pref = await SharedPreferences.getInstance();
  final id = pref.getString('userId');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id});
  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        final user = responseData;
        print(user);
        // okk implement here
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
