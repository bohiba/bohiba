import '/dist/app_enums.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/all_recieved_request_controller.dart';
import '../../../model/user_model.dart';
import '/pages/driver/open_driver_tile.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllReceivedRequestPage extends GetView<AllRecievedRequestController> {
  const AllReceivedRequestPage({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);

    return Scaffold(
      appBar: TitleAppbar(
        title: 'Connection Request',
      ),
      body: Obx(
        () {
          RefreshController refreshController = RefreshController();
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              await controller.allRequest(showLoading: false, refresh: true);
              refreshController.refreshCompleted();
            },
            child: controller.recvdRequest.isEmpty
                ? Center(
                    child: SizedBox(
                      width: ScreenUtils.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.strHeaderMsg.value,
                            style: bohibaTheme.textTheme.headlineLarge,
                          ),
                          Text(
                            controller.strDescription.value,
                            textAlign: TextAlign.center,
                            style: bohibaTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                      left: ScreenUtils.height15,
                      right: ScreenUtils.height15,
                      top: ScreenUtils.height10,
                    ),
                    itemCount: controller.recvdRequest.length,
                    itemBuilder: (context, index) {
                      UserModel openDriver = controller.recvdRequest[index];
                      return OpenDriverTile(
                        onTap: () {},
                        onReject: () async {
                          navigatorState.pop();
                          int rejected = await controller.updateStatus(ConnectionType.reject, openDriver.id!);
                          if (rejected > 0) {
                            await controller.allRequest(refresh: true);
                          }
                        },
                        onAccept: () async {
                          navigatorState.pop();
                          int accepted = await controller.updateStatus(ConnectionType.accept, openDriver.id!);
                          if (accepted > 0) {
                            await controller.allRequest(refresh: true);
                          }
                        },
                        showStatus: true,
                        openDriver: openDriver,
                        showDialog: controller.showAgain,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
