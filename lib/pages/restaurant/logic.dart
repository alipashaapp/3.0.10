import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:ali_pasha_graph/models/user_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class RestaurantLogic extends GetxController {
  MainController mainController = Get.find<MainController>();
  RxBool loading = RxBool(false);
  RxBool hasMorePage = RxBool(false);
  RxList<UserModel> users = RxList([]);
  RxnInt categoryId = RxnInt(Get.arguments);
  RxInt page = RxInt(1);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDataFromStorage();
    ever(page, (value) {
      getRestaurant();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getRestaurant();
  }

  nextPage() {
    if (hasMorePage.value) {
      page.value++;
    }
  }

  getRestaurant() async {
    loading.value = true;
    mainController.query.value = '''
  query UsersByCategory {
    usersByCategory(category_id: ${categoryId.value}, first: 25, page: ${page.value}) {
        data {
            id
            name
            seller_name
            level
            address
            image
            is_restaurant
            category {
                id
                name
            }
            city{
            name
            }
        }
        paginatorInfo {
            hasMorePages
        }
    }
}
    ''';

    try {
      dio.Response? res = await mainController.fetchData();
      if (res?.data?['data']?['usersByCategory']?['paginatorInfo'] != null) {
        hasMorePage.value = res?.data?['data']?['usersByCategory']
            ?['paginatorInfo']['hasMorePages'];
      }
      if (res?.data?['data']?['usersByCategory']?['data'] != null) {
        if(page.value==1){
          users.clear();
        }
        for (var item in res?.data?['data']?['usersByCategory']?['data']) {
          users.add(UserModel.fromJson(item));
        }
        if(mainController.storage.hasData('sellers-${categoryId.value}')){
          mainController.storage.remove('sellers-${categoryId.value}');
        }
        await mainController.storage.write('sellers-${categoryId.value}', res?.data?['data']?['usersByCategory']?['data']);
      }
    } catch (e) {}
    loading.value = false;
  }

  getDataFromStorage() {
    var listProduct = mainController.storage.read('sellers-${categoryId.value}')??[];

    for (var item in listProduct) {
      users.add(UserModel.fromJson(item));
    }
  }
}
