import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/complete_status/complete_component/company_modal_bottom_sheet.dart';
import 'package:bohiba/pages/status/tabs/complete_status/screen/challan_screen/challan_screen.dart';
import 'package:remixicon/remixicon.dart';

class CompleteStatusScreen extends StatelessWidget {
  const CompleteStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChallanScreen(),
                    ),
                  );
                },
                title: const Text('0D 14A 7224'),
                subtitle: const Text('26.59 Tonne'),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return const CompanyModalBottomSheet();
                      },
                    );
                  },
                  icon: const Icon(Remix.more_2_line),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
