// This is the homepage class

import 'package:flutter/material.dart';
import 'Utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'functionality_card_home_page.dart';
import 'Login.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('DormLife'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      body: Column(
        children: [

          // TODO: add logo at the home page
          Expanded(
            flex: 4,
            child: Container(
              child: Image.asset(
                'assets/Hostel.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(

            flex: 6,
            child: GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              children: <Widget>[

                // 4 cards made from same class
                // passing name as the argument
                FunctionalityCardHomePage(Utils.MESS, 'assets/Mess.png'),
                FunctionalityCardHomePage(Utils.COMPLAINTS, 'assets/Complaints.png'),
                FunctionalityCardHomePage(Utils.EVENTS, 'assets/Event.jpg'),
                FunctionalityCardHomePage(Utils.COUNCIL, 'assets/Council.jpg')

              ],
            ),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
    );
  }
}

// The side drawer

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late SharedPreferences preferences;
  bool isLoading = true;

  Future<void> getUserData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    getUserData();
  }

  void _logout(){
    preferences.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: ( isLoading ? null : Text(preferences.getString('name').toString())),
          accountEmail: ( isLoading ? null : Text(preferences.getString('email').toString())),
          currentAccountPicture: const CircleAvatar(
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
        ),
        ElevatedButton(onPressed: _logout, child: const Text("Log out")),
      ],
    ),
  );
}


