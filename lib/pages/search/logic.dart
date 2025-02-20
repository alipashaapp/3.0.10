import 'package:ali_pasha_graph/exceptions/custom_exception.dart';
import 'package:ali_pasha_graph/models/filter_model.dart';
import 'package:ali_pasha_graph/models/product_model.dart';
import 'package:ali_pasha_graph/models/user_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../Global/main_controller.dart';

class SearchLogic extends GetxController {
  MainController mainController = Get.find<MainController>();
  RxBool hasMorePage = RxBool(false);

  RxBool loading = RxBool(false);
  RxInt page = RxInt(1);
  RxList<ProductModel> products = RxList<ProductModel>([]);
  RxList<UserModel> sellers = RxList<UserModel>([]);
  FilterModel? filterModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    filterModel = Get.arguments;
    ever(page,(value){
      search();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    search();
  }

  nextPage() {
    if (hasMorePage.value) {
      page.value++;
    }
  }

  Future<void> search() async {
    sellers([]);
    loading.value = true;
    try {
      if(filterModel!.type!='seller'){
        mainController.query.value = '''
      query Products {
    products(
        ${filterModel?.type != null ? 'type: "${filterModel!.type!}"' : ""}
        ${filterModel?.cityId != null ? "city_id: ${filterModel!.cityId!}" : ""}
         ${filterModel?.sellerId != null ? "user_id: ${filterModel!.sellerId!}" : ""}
       ${filterModel?.categoryId != null ? "category_id: ${filterModel!.categoryId!}" : ""}
         ${filterModel?.sub1Id != null ? "sub1_id: ${filterModel!.sub1Id!}" : ""}
       ${filterModel?.colors?.length != 0 ? "colors: ${filterModel!.colors!}" : ""}
        ${filterModel?.startPrice !=null ? "min_price: ${filterModel!.startPrice!}" : ""}
          ${filterModel?.endPrice !=null ? "max_price: ${filterModel!.endPrice!}" : ""}
      
        first: 25
        page: ${page.value}
        search: "${filterModel?.search ?? ''}"
    ) {
        data {
            id
            user {
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
            name
            expert
            weight
            start_date
            end_date
            
            price
            discount
            is_discount
            type
            views_count
            turkey_price {
                price
                discount
            }
            image
            created_at
        }
        paginatorInfo {
            hasMorePages
        }
    }
}

      ''';
      }else{
        mainController.query.value = '''
        query SearchSeller {
    
    searchSeller(search: "${filterModel?.search ?? ''}",${filterModel?.cityId != null ? "city_id: ${filterModel!.cityId!}" : ""}) {
        id
        seller_name
        level
        image
        is_verified
        address
        city {
            name
        }
    }
}
      ''';
      }

      dio.Response? res = await mainController.fetchData();

      if (res?.data['data']['products'] != null) {
        hasMorePage.value = res?.data['data']['products']['paginatorInfo']
                ['hasMorePages'] ??
            false;
        if (res?.data['data']['products']['data'] != null) {
          for (var item in res?.data['data']['products']['data']) {
            products.add(ProductModel.fromJson(item));
          }
        }
      }

      if(res?.data?['data']?['searchSeller']!=null){
        for(var item in res?.data?['data']?['searchSeller']){
          sellers.add(UserModel.fromJson(item));
        }
      }
      loading.value = false;
    } on CustomException catch (e) {
      mainController.logger.e(e.message);
    }
    loading.value = false;
  }
}
