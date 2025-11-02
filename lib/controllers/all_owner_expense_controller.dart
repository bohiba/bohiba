import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/owner_expenses.dart';
import 'package:bohiba/services/owner_expense_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllOwnerExpenseController extends GetxController {
  final RefreshController refreshTruckList = RefreshController();

 // Driver Details
  RxList<OwnerExpense> arrOwnerExp = <OwnerExpense>[].obs;

  RxBool isFav = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getOwnerExpenseList();
    });
  }
 Future<List<OwnerExpense>> getOwnerExpenseList({
    MethodType methodType = MethodType.api,
    bool resetList = false,
  }) async {
    

    List<OwnerExpense> truckList =
        await OwnerExpenseService.getOwnerExpenseList(type: methodType, reset: resetList);
    arrOwnerExp.clear();
    arrOwnerExp.addAll(truckList);
    return arrOwnerExp;
  }
 @override
  void dispose() {
   
    super.dispose();
  }
  
}