import 'package:flutter/material.dart';

import '../../../component/bohiba_appbar/notify_appbar.dart';
import '../notify_string/notify_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotifyAppBar(title: NotifyScreen.notification),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            children: List.generate(12, (index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
                child: ListTile(
                  title: Text("Title"),
                  subtitle: Text("Subtitle"),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
