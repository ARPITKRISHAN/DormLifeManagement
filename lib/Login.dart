import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Registration.dart';
import 'dart:convert';
import 'Utils/globals.dart';
import 'package:http/http.dart' as http;
import 'MyHomePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      // loading circle
      showDialog(
          context: context,
          builder: (context){
            return Center(
                child: CircularProgressIndicator()
            );
          }
      );

      // Perform the login logic here
      // Assume the login function returns a boolean indicating success
      bool loginSuccess = await login(email, password);

      if (loginSuccess) {

        Navigator.of(context).pop();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
      else{
        // call of the loader
        Navigator.of(context).pop();
      }

    }
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }


  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }

    // Add your own email validation logic here
    // You can use regular expressions or other validation techniques

    // Example email validation using regular expression
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: _validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _navigateToRegistration,
                  child: const Text(
                    'New User? Register',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simulated login function
Future<bool> login(String email, String password) async {

  try{
    final url = API.LOGIN_USER;

    final params = {
      "email" : email,
      "password": password,
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params));

    final responseBody = json.decode(response.body);

    if (responseBody['status'] == 200) {
      // Request successful
      // Successful API call
      Fluttertoast.showToast(msg: responseBody['message']);

      // Store the login details using shared preferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('user_id', responseBody['user']['id']);
      preferences.setString('name', responseBody['user']['name']);
      preferences.setString('email', responseBody['user']['email']);
      preferences.setString('token', responseBody['token']);

      // Simulating a successful login
      return true;

    } else {
      // Request failed
      Fluttertoast.showToast(msg: responseBody['message']);
      return false;
    }
  }
  catch(e){
    // Exception occurred

    print('An error occurred: $e');

    Fluttertoast.showToast(msg: "Error while letting you in");
    return false;

  }

}
