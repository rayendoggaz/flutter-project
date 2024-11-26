import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/homepage.dart';
import 'package:http/http.dart' as http;

class EditDataPage extends StatefulWidget {
  final Map ListData;
  const EditDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nisn = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController location = TextEditingController();

  Future _update() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/simple_api/update.php"),
      body: {
        "id": id.text,
        "nisn": nisn.text,
        "name": name.text,
        "address": address.text,
        "gender": gender.text,
        "location": location.text,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id.text = widget.ListData['id'];
    nisn.text = widget.ListData['nisn'];
    name.text = widget.ListData['name'];
    address.text = widget.ListData['address'];
    gender.text = widget.ListData['gender'];
    location.text = widget.ListData['location'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Data"),
      ),
      body: Form(
        key: formkey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nisn,
                decoration: const InputDecoration(
                  labelText: "NISN",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "NISN cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: gender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Gender cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: location,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Location cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _update().then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Data updated successfully")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Failed to update data")),
                        );
                      }
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const HomePage())),
                            (route) => false);
                  }
                },
                child: const Text("Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
