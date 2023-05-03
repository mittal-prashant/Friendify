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
    print(response.statusCode);
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
        pref.setDouble('rating', double.parse(jsonDecode(response.body)['user']['rating'].toString()));
        pref.setInt('ratedby', jsonDecode(response.body)['user']['ratedby']);
        pref.setBool('isVerified', responseData['user']['isVerified']);

        return true;
      } else {
        final msg = responseData['msg'];
        final pref = await SharedPreferences.getInstance();
        pref.setBool('isVerified', false);
        print(pref.getBool('isVerified'));
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

Future<String> getUserInfo(String id) async {
  final url = Uri.parse(getUserInfoApi);
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id});
  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final user = responseData['user'];
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
    // print(response.statusCode);
    // print(response);
    //   final responseData = jsonDecode(response.body);
    //     print(responseData);

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

Future<bool> setRandomUsername(String randomName) async {
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
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred: $error');
    return null;
  }
}

Future<bool> getRating() async {
  final url = Uri.parse(getRatingApi);
  final pref = await SharedPreferences.getInstance();
  final id = pref.getString('userId');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'id': id});
  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("done");
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
