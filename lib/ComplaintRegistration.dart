// To register complaints

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utils/globals.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

class ComplaintRegistration extends StatefulWidget {
  const ComplaintRegistration({Key? key}) : super(key: key);

  @override
  State<ComplaintRegistration> createState() => _ComplaintRegistrationState();
}

class _ComplaintRegistrationState extends State<ComplaintRegistration> {

  String name = '';
  String complaintTitle = '';
  int roomNo = 0;
  String selectedHostel = 'Hostel 1';
  String description = '';
  bool isLoading = false;

  // TO POST THE COMPLAINT
  void postComplaint() async {

    setState(() {
      isLoading = true;
    });

    try{
      final url = API.POST_COMPLAINT;

      final params = {
        "name" : name,
        "complaint_title" : complaintTitle,
        "room_no": roomNo,
        "hostel" : selectedHostel,
        "description" : description
      };

      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params));

      if (response.statusCode == 200) {
        // Request successful
        // Successful API call
        Fluttertoast.showToast(msg: "Complaint registered successfully");

        setState(() {
          isLoading = false;
        });

      } else {
        // Request failed
        Fluttertoast.showToast(msg: "Error in registering complaint");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      // Exception occurred
      Fluttertoast.showToast(msg: "Error in registering complaint");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Registration'),
      ),
      body: (isLoading
          ? Column( children: const [ Expanded(child: Center(child: CircularProgressIndicator()))])
          : Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Complaint Title',
                      ),
                      onChanged: (value) {
                        setState(() {
                          complaintTitle = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Room No',
                      ),
                      onChanged: (value) {
                        setState(() {
                          roomNo = int.parse(value);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedHostel,
                      items: [
                        'Hostel 1',
                        'Hostel 2',
                        'Hostel 3',
                        'Hostel 4',
                      ].map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHostel = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Meal Type',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      maxLines: null,
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Perform submit action
                          postComplaint();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      )
    );
  }
}
