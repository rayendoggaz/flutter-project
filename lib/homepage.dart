import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/tambahdata.dart';
import 'package:flutter_crud/editdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  List _filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  Future _getdata() async {
    try {
      final response = await http.get(
          Uri.parse("http://10.0.2.2/simple_api/conn.php"),
          headers: {"Access-Control-Allow-Origin": "*"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _filteredData = data; // Initialize filtered data with all data
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _deletedata(String id) async {
    try {
      final response = await http.post(
          Uri.parse("http://10.0.2.2/simple_api/delete.php"),
          body: {"nisn": id},
          headers: {"Access-Control-Allow-Origin": "*"});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  void _filterData(String query) {
    final filtered = _listdata.where((item) {
      final name = item['name'].toLowerCase();
      final address = item['address'].toLowerCase();
      final nisn = item['nisn'].toLowerCase();
      final gender = item['gender'].toLowerCase(); // Add gender to search
      final location = item['location'].toLowerCase(); // Add location to search
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) ||
          address.contains(searchQuery) ||
          nisn.contains(searchQuery) ||
          gender.contains(searchQuery) ||
          location.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredData = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search by Name, Address, NISN, Gender, or Location",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterData(value); // Filter the data as the user types
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => EditDataPage(
                            ListData: {
                              "id": _filteredData[index]['id'],
                              "nisn": _filteredData[index]['nisn'],
                              "name": _filteredData[index]['name'],
                              "address": _filteredData[index]['address'],
                              "gender": _filteredData[index]['gender'], // Pass gender
                              "location": _filteredData[index]['location'], // Pass location
                            },
                          )),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_filteredData[index]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_filteredData[index]['address']),
                          Text("Gender: ${_filteredData[index]['gender']}"), // Display gender
                          Text("Location: ${_filteredData[index]['location']}"), // Display location
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to delete data for ${_filteredData[index]['name']}?"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _deletedata(_filteredData[index]['nisn'])
                                            .then((value) {
                                          if (value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Data deleted successfully")));
                                            _getdata(); // Refresh data after deletion
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Failed to delete data")));
                                          }
                                        });
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                );
                              }));
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddData()),
          ).then((_) => _getdata()); // Refresh data when returning from AddData
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}