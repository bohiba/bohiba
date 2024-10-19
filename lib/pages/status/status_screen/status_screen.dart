import 'package:bohiba/pages/status/tabs/book_status/screens/book_status_screen.dart';
import 'package:bohiba/pages/status/tabs/load_status/screens/load_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/pages/status/status_string/status_string.dart';

import '../../../component/bohiba_appbar/status_appbar.dart';
import '../tabs/complete_status/screen/complete_status_screen.dart';

class StatusPage extends StatefulWidget {
  final int moveToTab;

  const StatusPage({
    Key? key,
    this.moveToTab = 0,
  }) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: widget.moveToTab,
        child: Scaffold(
          appBar: StatusAppBar(title: StatusString.title),
          body: Column(
            children: [
              TabBar(
                isScrollable: false,
                labelColor: bohibaColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: bohibaColors.primaryColor,
                tabs: const [
                  Tab(
                    text: 'Book',
                  ),
                  Tab(
                    text: 'Load',
                  ),
                  Tab(
                    text: 'Complete',
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(children: [
                  BookStatusScreen(),
                  LoadStatusScreen(),
                  CompleteStatusScreen(),
                ]),
              ),
            ],
          ),
        ));
  }
}
