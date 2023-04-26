import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final Function(String) onSelect;
  final String genderError;
  GenderSelector({@required this.onSelect, @required this.genderError});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'male';
                });
                widget.onSelect('male');
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/male.png'),
                    backgroundColor:
                        _selectedGender == 'male' ? Colors.blue : Colors.grey,
                    radius: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Male',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'female';
                });
                widget.onSelect('female');
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/female.png'),
                    backgroundColor:
                        _selectedGender == 'female' ? Colors.blue : Colors.grey,
                    radius: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Female',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        widget.genderError != null && _selectedGender == null
            ? Text(
                widget.genderError,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
