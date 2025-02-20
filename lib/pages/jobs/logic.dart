import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:ali_pasha_graph/exceptions/custom_exception.dart';
import 'package:ali_pasha_graph/models/product_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class JobsLogic extends GetxController {
  RxBool loading =RxBool(false);
  RxBool hasMorePage = RxBool(false);
  RxInt page = RxInt(1);
  MainController mainController = Get.find<MainController>();
  RxList<ProductModel> jobs = RxList<ProductModel>([]);
RxString typeJob=RxString('');
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDataFromStorage();
    ever(page, (value) {
      getJobs();
    });
    ever(typeJob, (value) {
      jobs.clear();
      if(page==1){
        getJobs();
      }else{
        page.value=1;
      }
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getJobs();
  }

  void nextPage() {
    if (hasMorePage.value) {
      page.value += 1;
    }
  }

  Future<void> getJobs() async {
    mainController.query.value = '''
    query Products {
    products(type: "job",sub_type:"${typeJob.value}", first: 25, page: ${page.value}) {
        paginatorInfo {
            hasMorePages
        }
        data {
            id
            user {
            id
                seller_name
                logo
                image
                  is_verified
            }
            city {
                name
            }
            category {
                name
            }
            sub1 {
                name
            }
            expert
            name
            level
            address
            start_date
            end_date
            code
            type
            views_count
            created_at
        }
    }
}

    ''';
    try {
      loading.value=true;
      dio.Response? res = await mainController.fetchData();
      mainController.logger.e(res?.data);
      if (res?.data?['data']?['products']?['paginatorInfo'] != null) {
        hasMorePage.value = bool.tryParse(
                "${res?.data?['data']?['products']?['paginatorInfo']?['hasMorePages']}") ??
            false;
      }
      if (res?.data?['data']?['products']?['data'] != null) {
        if(page.value==1){
          jobs.clear();
        }
        for (var item in res?.data?['data']?['products']?['data']) {
          jobs.add(ProductModel.fromJson(item));
        }
        if(mainController.storage.hasData('jobs')){
          mainController.storage.remove('jobs');
        }
        await mainController.storage.write('jobs', res?.data?['data']?['products']?['data'] );
      }
      if(res?.data?['errors']?[0]?['message']!=null){
        mainController.showToast(text:'${res?.data['errors'][0]['message']}',type: 'error' );
      }
    } on CustomException catch (e) {
      mainController.logger.e("Error Jobs Pge ${e.message}");
    }
    loading.value=false;
  }

  getDataFromStorage() {
    var listProduct = mainController.storage.read('jobs')??[];

    for (var item in listProduct) {
      jobs.add(ProductModel.fromJson(item));
    }
  }
}
