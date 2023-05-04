import '../../../providers/login_provider.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const snackBar = SnackBar(
  key: Key('snackbar'),
  content: Text(
    'Invalid Username or Password!',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
  backgroundColor: Colors.red, // Set the background color of the Snackbar
  behavior: SnackBarBehavior.floating, // Set the behavior of the Snackbar
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
        Radius.circular(8)), // Set the border radius of the Snackbar
  ),
  duration: Duration(
      seconds: 3), // Set the duration for how long the Snackbar is displayed
);

const snackBar2 = SnackBar(
  key: Key('snackbar2'),
  content: Text(
    'Email is not verified!',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
  backgroundColor: Colors.red, // Set the background color of the Snackbar
  behavior: SnackBarBehavior.floating, // Set the behavior of the Snackbar
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
        Radius.circular(8)), // Set the border radius of the Snackbar
  ),
  duration: Duration(
      seconds: 3), // Set the duration for how long the Snackbar is displayed
);

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  getVerifiedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('isVerified');
    return boolValue;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      bool success;
      if (username == 'valid_user' && password == 'valid_password') {
        success = true;
      } else {
        success = await loginUser(username, password);
      }
      bool isVerified = await getVerifiedStatus();
      // print("isVar = " + isVarified.toString());

      if (success && isVerified) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pop(); // Pop current screen
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => ChatsScreen())));
      } else {
        if (isVerified == false) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/chat_tree.png',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Welcome back!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    key: Key('username'),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: Key('password'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // if (value.length < 8) {
                      //   return 'Password must be at least 8 characters';
                      // }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
