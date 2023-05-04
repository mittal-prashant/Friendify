import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_routes.dart';

Future<String> registerUser(String username, String email, String password,
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        print('User registered successfully!');
        // return true;
        return "User registered successfully";
      } else {
        final msg = responseData['msg'];
        // print(msg);
        return msg;
      }
    } else {
      print('An error occurred');
      return "Error Occured";
    }
  } catch (error) {
    print('An error occurred: $error');
    return "Error Occured";
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
        final pref = await SharedPreferences.getInstance();
        pref.setBool('isLoggedIn', true);
        pref.setString('username', username);
        pref.setString(
            'randUser', jsonDecode(response.body)['user']['random_username']);
        pref.setString('userId', jsonDecode(response.body)['user']['_id']);
        pref.setString('email', jsonDecode(response.body)['user']['email']);
        pref.setString('gender', jsonDecode(response.body)['user']['gender']);
        pref.setString(
            'avatarImage', jsonDecode(response.body)['user']['avatarImage']);
        pref.setDouble(
            'rating',
            double.parse(
                jsonDecode(response.body)['user']['rating'].toString()));
        pref.setInt('ratedby', jsonDecode(response.body)['user']['ratedby']);
        pref.setBool('isVerified', responseData['user']['isVerified']);

        return true;
      } else {
        final msg = responseData['msg'];
        final pref = await SharedPreferences.getInstance();
        pref.setBool('isVerified', false);
        print(msg);
        return false;
      }
    } else {
      return false;
    }
  } catch (error) {
    print('An error occurred: $error');
    return false;
  }
}

Future<String> getUserInfo(String username) async {
  final url = Uri.parse(getUserInfoApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'username': username});
  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final user = responseData['user'];
      final pref = await SharedPreferences.getInstance();
      pref.setString('friend_name', username);
      pref.setString(
          'friend_email', jsonDecode(response.body)['user']['email']);
      pref.setString(
          'friend_gender', jsonDecode(response.body)['user']['gender']);
      pref.setString(
          'friend_avatar', jsonDecode(response.body)['user']['avatarImage']);
      pref.setDouble('friend_rating',
          double.parse(jsonDecode(response.body)['user']['rating'].toString()));
      pref.setInt(
          'friend_ratedby', jsonDecode(response.body)['user']['ratedby']);
      print(user);
      return user;
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}

Future<bool> addFriend(String sender, String receiver) async {
  final url = Uri.parse(addFriendApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'senderid': sender, 'receiverid': receiver});
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData['status']);
      return responseData['status'];
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}

Future<void> setRandomUsername(String randomName) async {
  final url = Uri.parse(setRandomUsernameApi);
  final pref = await SharedPreferences.getInstance();
  final id = pref.getString('userId');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id, 'random_username': randomName});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData['random_username']);
      pref.setString('randUser', responseData['random_username']);
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}

Future<void> getRating() async {
  final url = Uri.parse(getRatingApi);
  final pref = await SharedPreferences.getInstance();
  final id = pref.getString('userId');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      pref.setDouble('rating', double.parse(responseData['rating'].toString()));
      pref.setInt('ratedby', responseData['ratedby']);
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}
