import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DormLife',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: FutureBuilder( future: SharedPreferences.getInstance(), builder: (context, snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center( child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Text("Some error has occured");
        }
        else if(snapshot.hasData){

          final token = snapshot.data!.getString('token');

          if(token != null){
            return MyHomePage();
          }
          else{
            return LoginScreen();
          }
        }
        else{
          return LoginScreen();
        }
      }),
    );
  }
}
