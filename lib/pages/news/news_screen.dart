import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TitleAppbar(
          title: "News",
        ),
        body: Center(
          child: Text("News Screen"),
        ));
  }
}
