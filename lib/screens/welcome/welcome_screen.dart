import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/login/login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Safe area adjusts the child widget to the safe area of device's screen i.e. without obstruction from nav bar, status bar etc.
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            Spacer(flex: 3),
            Text(
              "Welcome to Friendify \nmessaging app",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            Spacer(flex: 1),
            Container(
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: 0.9, // Set the width to 80% of the available width
                child: Text(
                  "Connect safely with strangers using our completely secure app. \nJoin now and start chatting with confidence.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        .color
                        .withOpacity(0.64),
                  ),
                ),
              ),
            ),
            Spacer(flex: 3),
            FittedBox(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: Theme.of(context).textTheme.bodyLarge.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                .color
                                .withOpacity(0.8),
                          ),
                    ),
                    SizedBox(width: mainDefaultPadding / 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .color
                          .withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
