import 'package:bohiba/pages/status/tabs/book_status/screens/book_status_screen.dart';
import 'package:bohiba/pages/status/tabs/load_status/screens/load_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/status_string/status_string.dart';

import '../../../component/bohiba_appbar/status_appbar.dart';
import '../tabs/complete_status/screen/complete_status_screen.dart';

class StatusPage extends StatefulWidget {
  final int moveToTab;

  const StatusPage({
    super.key,
    this.moveToTab = 0,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List tabs = ["Book", "Load", "Compelete"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        initialIndex: widget.moveToTab,
        child: Scaffold(
          appBar: StatusAppBar(title: StatusString.title),
          body: Column(
            children: [
              TabBar(
                isScrollable: false,
                controller: _tabController,
                tabs: List.generate(
                  tabs.length,
                  (index) {
                    return Tab(text: tabs[index]);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BookStatusScreen(),
                    LoadStatusScreen(),
                    CompleteStatusScreen(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
