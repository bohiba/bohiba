import 'package:bohiba/component/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/home/home_string/home_strings.dart';

import '../../../news/news_screen.dart';

class HomeNewsSection extends StatefulWidget {
  const HomeNewsSection({super.key});

  @override
  State<HomeNewsSection> createState() => _HomeNewsSectionState();
}

class _HomeNewsSectionState extends State<HomeNewsSection> {
  final int notifyLength = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(
            right: BohibaResponsiveScreen.width15,
            left: BohibaResponsiveScreen.width15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                HomeNewsString.news,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const NewsScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(
                      HomeNewsString.seeAll,
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          color: Theme.of(context).primaryColor),
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(height: height * 0.005),

        // Home News
        Column(
          children: List.generate(3, (index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.grey.shade50,
            );
          }),
        )
      ],
    );
  }
}
