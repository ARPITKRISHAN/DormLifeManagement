// To display the information about council member
// Council member card

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Utils/globals.dart';

class CouncilMember extends StatefulWidget {

  String? councilID;
  CouncilMember({Key? key, this.councilID}) : super(key: key);

  @override
  State<CouncilMember> createState() => _CouncilMemberState(councilID);
}

class _CouncilMemberState extends State<CouncilMember> {

  String? councilID;
  // list to contain the objects of the Council members data
  List<dynamic>? list;
  int? listSize;
  bool isLoading = false;

  // To get all the council members
  void fetchData(String? id) async {

    isLoading = true;

    var url = Uri.parse('${API.GET_ALL_COUNCIL_MEMBERS}${id}');
    var response = await http.get(url);

    try{
      if (response.statusCode == 200) {
        // Request successful, parse the response data

        List<dynamic> data = json.decode(response.body);

        setState(() {
          list = data.map<CouncilMemberData>((json) => CouncilMemberData.fromJson(json)).toList();
          listSize = list?.length;
          isLoading = false;
        });

      }
      else {
        Fluttertoast.showToast(msg: "Error in fetching data");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error in fetching data");
      setState(() {
        isLoading = false;
      });
    }

  }

  _CouncilMemberState(this.councilID){
    fetchData(councilID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Council Members'),
      ),
      body: (isLoading
          ?  Column( children: const [ Expanded(child: Center(child: CircularProgressIndicator()))])
          :  Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listSize,
              itemBuilder: (context, index) {
                return CouncilMemberCard(councilMemberData: list?[index]);
              },
            ),
          ),
        ],
      )
      ),
    );
  }
}

class CouncilMemberCard extends StatelessWidget {

  CouncilMemberData? councilMemberData;
  
  CouncilMemberCard({Key? key, this.councilMemberData}):super(key: key);
  
  @override
  Widget build(BuildContext context) {

      return Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 165,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${councilMemberData?.name}" ,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${councilMemberData?.number}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class CouncilMemberData {
  int? memberId;
  String? name;
  String? number;
  int? councilId;
  String? createdAt;
  String? updatedAt;

  CouncilMemberData(
      {this.memberId,
        this.name,
        this.number,
        this.councilId,
        this.createdAt,
        this.updatedAt});

  CouncilMemberData.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    name = json['name'];
    number = json['number'];
    councilId = json['council_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = memberId;
    data['name'] = name;
    data['number'] = number;
    data['council_id'] = councilId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
