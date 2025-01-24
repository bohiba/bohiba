import 'package:flutter/material.dart';

class LoadHistoryScreen extends StatelessWidget {
  const LoadHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Load History"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                onTap: () {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const BookChallanScreen()));
                },
                title: const Text('0D 14A 7224'),
                subtitle: const Text('26.59 Tonne'),
                trailing: const Text('OMC - JSW'),
              ),
            );
          },
        ),
      ),
    );
  }
}
