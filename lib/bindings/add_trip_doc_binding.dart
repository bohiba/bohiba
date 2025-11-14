import '/controllers/add_trip_document_controller.dart';
import 'package:get/get.dart';

class AddTripDocBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTripDocumentController>(() => AddTripDocumentController());
  }
}
