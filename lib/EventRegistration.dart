// To register a new event

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utils/globals.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'DateAndTime.dart';

class EventRegistration extends StatefulWidget {
  const EventRegistration({Key? key}) : super(key: key);

  @override
  State<EventRegistration> createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {

  String _title = '';
  DateTime? _selectedDateTime;
  String _location = '';
  String _organizer = '';
  String _description = '';
  String _contactInformation = '';
  bool _registrationRequired = false;
  DateTime? _registrationDeadline;
  bool isLoading = false;

  // TO POST THE EVENT
  void postEvent() async {

    setState(() {
      isLoading = true;
    });

    try{
      final url = API.POST_EVENT;

      final params = {
        'title': _title,
        'description': _description,
        'date_and_time': _selectedDateTime?.toString(),
        'location': _location,
        'organizer': _organizer,
        'category': 'Dummy Category',
        'registration_required': _registrationRequired,
        'registration_deadline': _registrationDeadline?.toString(),
        'contact_information': _contactInformation,
      };

      print(_selectedDateTime?.toString());
      print(_registrationDeadline?.toString());

      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params));

      if (response.statusCode == 200) {
        // Request successful
        // Successful API call
        Fluttertoast.showToast(msg: "Event registered successfully");

        setState(() {
          isLoading = false;
        });


      } else {
        // Request failed
        Fluttertoast.showToast(msg: "Error in registering Event");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      // Exception occurred
      Fluttertoast.showToast(msg: "Error in registering Event");
      setState(() {
        isLoading = false;
      });
    }
  }

  // TO SELECT THE DATE AND TIME OF THE EVENT
  Future<void> _selectDateTimeForEvent() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDateTimeForDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
            _registrationDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registration'),
      ),
      body:  (isLoading
          ?  Column( children: const [ Expanded(child: Center(child: CircularProgressIndicator()))])
          :  Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _title = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date and Time',
                      ),
                      onTap: () async {
                        await _selectDateTimeForEvent();
                      },
                      controller: TextEditingController(
                        text: _selectedDateTime != null
                            // ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)
                            ? DateAndTime.convertedDateAndTime(_selectedDateTime!.toIso8601String())
                            : '',
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _location = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Organiser',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _organizer = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Information',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _contactInformation = value;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Checkbox(
                          value: _registrationRequired,
                          onChanged: (value) {
                            setState(() {
                              _registrationRequired = value!;
                            });
                          },
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Registration Required',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Registration Deadline',
                      ),
                      onTap: () async {
                        await _selectDateTimeForDeadline();
                      },
                      controller: TextEditingController(
                        text: _registrationDeadline != null
                        // ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)
                            ? DateAndTime.convertedDateAndTime(_registrationDeadline!.toIso8601String())
                            : '',
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Perform submit action
                          postEvent();
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      ),
    );
  }
}
