import '../../../../providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Friend_Profile extends StatefulWidget {
  String name;
  @override
  _Friend_ProfileState createState() => _Friend_ProfileState();
  Friend_Profile(this.name) {}
}

class _Friend_ProfileState extends State<Friend_Profile> {
  String user_data = '', username = '', gender = '', avatarImage = '';
  double rating = 0.0;
  int ratedBy = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (widget.name != 'dummy_tester_account') getUserInfo(widget.name);

    setState(() {
      username = sharedPreferences.getString('friend_name');
      gender = sharedPreferences.getString('friend_gender');
      avatarImage = sharedPreferences.getString('friend_avatar');
      rating = sharedPreferences.getDouble('friend_rating');
      if (rating == null) rating = 0;
      ratedBy = sharedPreferences.getInt('friend_ratedby');
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              if (avatarImage != '')
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("$avatarImage"),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show rating stars
                  for (var i = 0; i < rating.floor(); i++)
                    Icon(Icons.star, color: Colors.yellow),
                  if (rating.floor() != rating)
                    Icon(Icons.star_half, color: Colors.yellow),
                  if (rating.round() < 5)
                    for (var i = 0;
                        i <
                            (5 -
                                rating.floor() -
                                (rating.floor() != rating ? 1 : 0));
                        i++)
                      Icon(Icons.star_border, color: Colors.yellow),
                  SizedBox(width: 10),
                  Text('(Rated by $ratedBy users)',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Gender: ' + (gender == 'male' ? 'Male' : 'Female'),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Username: ' + username,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
