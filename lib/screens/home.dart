import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.yellow[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(

            alignment:Alignment.center,
              padding: EdgeInsets.all(10),
              color: Colors.lightBlue, // Background color
              child: Text(
                'group1',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 20), // Spacer
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.lightBlue, // Background color
              child: Text(
                'Hello, world!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Row(


            )
          ],
        ),
      ),
    );
  }
}


