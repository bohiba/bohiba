import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Documents",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        leadingWidth: 25,
        elevation: 0,
      ),
      body: const Center(
        // TO-DO DOCUMENTS
        child: Text('DOCUMENTS'),
      ),
    );
  }
}
