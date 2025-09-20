import '/theme/bohiba_theme.dart';

import '/dist/component_exports.dart';
import 'package:flutter/material.dart';

class HomeImageSliderSection extends StatefulWidget {
  const HomeImageSliderSection({super.key});

  @override
  State<HomeImageSliderSection> createState() => _HomeImageSliderSectionState();
}

class _HomeImageSliderSectionState extends State<HomeImageSliderSection> {
  List<String> imageData = [
    "https://img.freepik.com/free-vector/gradient-abstract-fluid-technology-linkedin-banner_23-2149171998.jpg?w=1060&t=st=1686304561~exp=1686305161~hmac=0b8b4301f143ee286653addc1116eb9c7243169fc6ab57dd4c3bef0a5c15612d",
    "https://img.freepik.com/free-vector/various-agricultural-machinery-infographic-elements_1284-62912.jpg?w=1060&t=st=1686304271~exp=1686304871~hmac=652ffda67270d26068fb7b66a2c3f0f62e31ae8b54d754273cb4c33ab1e57e3d",
    "https://img.freepik.com/free-vector/flat-design-geometric-metaverse-twitch-banner_23-2149437712.jpg?w=1060&t=st=1686304454~exp=1686305054~hmac=c9eedc3164bba515a0522cf6033163bdbde0104540616b24631fd82c423a2118",
    "https://img.freepik.com/free-vector/flat-minimal-technology-twitter-header_23-2149088093.jpg?w=1060&t=st=1686304529~exp=1686305129~hmac=2e27e0408ee242e4907ff0379aebb6503eec46daaa707c52ed874729a0d307f3"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenUtils.width15,
        bottom: ScreenUtils.height10,
      ),
      child: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, s) =>
            s.connectionState == ConnectionState.done
                ? SizedBox(
                    width: ScreenUtils.width,
                    height: ScreenUtils.height * 0.12,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageData.length,
                      itemBuilder: (_, index) {
                        String img = imageData[index];
                        return Container(
                          margin: EdgeInsets.only(right: ScreenUtils.width10),
                          width: ScreenUtils.width * 0.9,
                          height: ScreenUtils.height65,
                          decoration: BoxDecoration(
                            color: bohibaTheme.cardColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    width: ScreenUtils.width,
                    height: ScreenUtils.height * 0.12,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageData.length,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.only(right: ScreenUtils.width10),
                          width: ScreenUtils.width * 0.9,
                          height: 140,
                          decoration: BoxDecoration(
                            color: bohibaTheme.primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
