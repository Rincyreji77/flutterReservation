import 'package:flutter/material.dart';
import 'registration.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String pageCaption = "Passenger Reservation";
  String pageName = "home";

  Widget homePageButtons() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ReservationPage();
              },
            ));
          },
          child: const Text("Registration"),
        ),
         const SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(pageCaption),
          ],
        ),
      ),
      body: homePageButtons(),
    );
  }
}