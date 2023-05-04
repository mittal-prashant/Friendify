import 'dart:math';
import '../../../providers/login_provider.dart';
import 'package:chat/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/login/components/gender_selector.dart';

const snackBar = SnackBar(
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

class SelectPhotoScreen extends StatefulWidget {
  String gender;
  SelectPhotoScreen(this.gender) {}
  @override
  _SelectPhotoScreenState createState() => _SelectPhotoScreenState();
}

class _SelectPhotoScreenState extends State<SelectPhotoScreen> {
  @override
  Future<void> initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    List<int> data = [];
    photos.clear();
    var rng = new Random();
    for (var i = 0; i < 8; i++) {
      var randomInt = rng.nextInt(50) + 1;
      while (data.contains(randomInt)) randomInt = rng.nextInt(50) + 1;
      data.add(randomInt);
      // print(widget.gender);
      if (widget.gender == 'male') {
        photos.add('assets/images/male/M$randomInt.jpg');
      } else {
        photos.add('assets/images/female/F$randomInt.jpg');
      }
    }
    // print(photos);
  }

  int _selectedIndex = -1;

  final List<String> photos = [];

  void _handlePhotoSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Avatar'),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _selectedIndex == -1
                    ? null
                    : () {
                        Navigator.pop(context, photos[_selectedIndex]);
                      },
                child: Text('Select'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20), // set the padding value
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: photos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => _handlePhotoSelection(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: _selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(photos[index]),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _email;
  String _password;
  String _gender;
  String _genderError;

  Future<void> _submitForm(String avatarImage) async {
    if (_formKey.currentState.validate() && _gender != null) {
      _formKey.currentState.save();

      // print('Username: $_username');
      // print('Email: $_email');
      // print('Gender: $_gender');

      bool hasRegistered = await registerUser(
          _username, _email, _password, _gender, avatarImage);

      if (hasRegistered) {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      setState(() {
        _genderError = 'Please select a gender';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 64),
                  Text(
                    'What is your gender?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  GenderSelector(
                    onSelect: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    genderError: _genderError,
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) => _username = value,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // if (!value.endsWith('@iitrpr.ac.in')) {
                      //   return 'Please enter a valid IIT Ropar email address';
                      // }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                      // if (value.length < 8) {
                      //   return 'Password must be at least 8 characters';
                      // }
                      // if (!value.contains(new RegExp(
                      //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
                      //   return 'Password should contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                      // }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                  ),
                  SizedBox(height: 32),
                  (_gender != null)
                      ? SizedBox(
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
                              'Continue',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () async {
                              String selectedPhoto =
                                  await showModalBottomSheet<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectPhotoScreen(_gender);
                                },
                              );
                              if (selectedPhoto != null) {
                                // print(selectedPhoto);
                                _submitForm(selectedPhoto);
                              }
                            },
                          ),
                        )
                      : SizedBox(
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
                              'Continue',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
