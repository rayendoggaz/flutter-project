import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2/simple_api/login.php'),
    body: {
      'email': email,
      'password': password,
    },
  );
  print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data == 'Success') {
      return 'Success';
    } else {
      return 'Error';
    }
  } else {
    throw Exception('Failed to connect to server');
  }
}