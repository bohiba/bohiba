import 'package:bohiba/dist/enums/api_status_code.dart';
import 'package:bohiba/dist/enums/app_enums.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/global_service.dart';

import '/core/network/dio_serivce.dart';
import '/model/ticket_model.dart';
import '/services/api_end_point.dart';
import 'package:get/get.dart';

class TicketService extends GetxService {
  static final DioService _dioService = DioService();

  static Future<List<TicketModel>?> getAllTickets({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      ApiResponse response = await _dioService.get(
        ApiEndPoint.apiTickets,
      );
      List<TicketModel> ticketList = (response.data as List)
          .map((x) => TicketModel.fromJson(x as Map<String, dynamic>))
          .toList();
      return ticketList;
    } catch (e) {
      GlobalService.printHandler(
        'TicketService.getAllTickets() $e',
      );
      return null;
    }
  }

  static Future<bool> createTicket({
    required Map<String, dynamic> ticketData,
  }) async {
    try {
      if (!await DeviceInfoService.hasInternet()) return false;

      GlobalService.showProgress();
      ApiResponse response = await _dioService.post(
        ApiEndPoint.apiTickets,
        body: ticketData,
      );
      GlobalService.dismissProgress();
      StatusCode status = StatusCode.fromCode(response.statusCode);
      switch (status) {
        case StatusCode.ok:
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            desc: response.message,
          );
          return true;
        case StatusCode.notFound:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            desc: response.errorMessage,
          );
          return false;
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            desc: response.errorMessage,
          );
          return false;
      }
    } catch (e) {
      GlobalService.dismissProgress();
      GlobalService.printHandler(
        'TicketService.createTicket() $e',
      );
      return false;
    }
  }
}
