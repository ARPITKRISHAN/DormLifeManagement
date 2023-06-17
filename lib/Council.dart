// Council landing page
// to display all the council committees and their members

import 'package:flutter/material.dart';
import 'CouncilMember.dart';

class Council extends StatefulWidget {
  const Council({Key? key}) : super(key: key);

  @override
  State<Council> createState() => _CouncilState();
}

class _CouncilState extends State<Council> {
  @override

    Widget build(BuildContext context) {
      return GridCardExample();
    }
}


class GridCardExample extends StatelessWidget {
  final List<GridItem> items = [
    GridItem(
      name: 'Hostel Warden',
      image: 'assets/HostelWarden.jpg',
    ),
    GridItem(
      name: 'General Secretary',
      image: 'assets/GeneralSecretary.jpg',
    ),
    GridItem(
      name: 'Sports Secretary',
      image: 'assets/SportsSecretary.jpg',
    ),
    GridItem(
      name: 'Hostel Secretary',
      image: 'assets/HostelSecretary.jpg',
    ),
    GridItem(
      name: 'Mess Committee',
      image: 'assets/MessCommittee.png',
    ),
    GridItem(
      name: 'Maintenance',
      image: 'assets/Maintenance.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Council'),
      ),
      body: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CouncilMember(councilID: (index + 1).toString())
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      items[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text(
                      items[index].name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridItem {
  final String name;
  final String image;

  GridItem({
    required this.name,
    required this.image,
  });
}