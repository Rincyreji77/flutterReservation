import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'global.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController passengerName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController passengerAge = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String passengerId = "";

  List<Passenger> passengerList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Registration Page"),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  clearScreen();
                },
                child: const Text("New")),
            ElevatedButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    saveRecord();
                  }
                },
                child: const Text("Save"))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formGlobalKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                },
                controller: passengerName,
                decoration: const InputDecoration(labelText: "Name"),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: address,
                decoration: const InputDecoration(labelText: "Address"),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextFormField(
                controller: passengerAge,
                decoration: const InputDecoration(labelText: "Age"),
              ),
            ),
            FutureBuilder(
              future: getList(),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: passengerList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 130, 200, 61),
                            border: Border(
                                bottom: BorderSide(color: Color.fromARGB(255, 7, 7, 7)))),
                        child: InkWell(
                          onTap: () {
                            passengerId = passengerList[index].id.toString();
                            passengerName.text =
                                passengerList[index].passengerName ?? "";
                            passengerAge.text =
                                passengerList[index].passengerAge.toString();
                          },
                          child: ListTile(
                            leading: const Icon(Icons.man),
                            title:
                                Text(passengerList[index].passengerName ?? ""),
                            
                             subtitle: Text(
                                " Age : ${passengerList[index].passengerAge}"),
                            trailing: 
                            ElevatedButton(
                                onPressed: () {
                                  passengerId =
                                      passengerList[index].id.toString();
                                  deleteRecord();
                                },
                                child: const Text("Delete")),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> saveRecord() async {
    try {
      Map<String, dynamic> body = {
        'id': passengerId,
        'passenger_name': passengerName.text,
        'address': address.text,
        'passenger_age': passengerAge.text,
      };

      Uri url = Uri.parse("http://localhost:8080/passenger/createRecord");
      if (passengerId.isNotEmpty) {
        url = Uri.parse("http://localhost:8080/passenger/updateRecord");
      }

      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        showMessage(context, msg);
        if (passengerId.isEmpty) {
          passengerId = data["id"].toString();
        }
        clearScreen();
        setState(() {});
        print("msg = $msg");
      } else {
        showMessage(context, msg);
        print("msg = $msg");
      }
    } catch (e) {
      showMessage(context, "Error : $e");
      print("msg = $e}");
    }
  }

  Future<void> getList() async {
    try {
      Map<String, dynamic> body = {
        'user_id': "test",
      };

      Uri url = Uri.parse("http://localhost:8080/passenger/getList");

      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        var jsonData = data["listData"];

        passengerList.clear();
        jsonData.forEach((jsonItem) {
          Passenger passenger = Passenger();
          passenger.id = jsonItem['id'];
          passenger.passengerName = jsonItem['passenger_name'];
          passenger.address = jsonItem['address'];
          passenger.passengerAge = jsonItem['passenger_age'];

          passengerList.add(passenger);
        });

        print(passengerList.length);

        //clearScreen();
        print("msg = $msg");
      } else {
        showMessage(context, msg);
        print("msg = $msg");
      }
    } catch (e) {
      showMessage(context, "Error : $e");
      print("msg = $e}");
    }
  }

  Future<void> deleteRecord() async {
    try {
      Map<String, dynamic> body = {
        'id': passengerId,
        'passenger_name': passengerName.text,
        'address': address.text,
        'passenger_age': passengerAge.text,
      };

      if (passengerId.isEmpty) {
        showMessage(context, "Select a record...");
      }

      Uri url = Uri.parse("http://localhost:8080/passenger/deleteRecord");

      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        showMessage(context, msg);

        clearScreen();
        setState(() {});
        print("msg = $msg");
      } else {
        showMessage(context, msg);
        print("msg = $msg");
      }
    } catch (e) {
      showMessage(context, "Error : $e");
      print("msg = $e}");
    }
  }

  void clearScreen() {
    passengerId = "";
    passengerName.text = "";
    address.text = "";
    passengerAge.text = "";
  }
}

class Passenger {
  int? id;
  String? passengerName;
  String? address;
  int? passengerAge;
}
