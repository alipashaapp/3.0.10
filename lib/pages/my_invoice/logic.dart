import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:ali_pasha_graph/models/invoice_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';

class MyInvoiceLogic extends GetxController {
  RxBool loading = RxBool(false);
  RxBool changeLoading = RxBool(false);
  RxBool hasMorePage = RxBool(false);
  RxInt page = RxInt(1);

  RxList<InvoiceModel> invoices = RxList([]);
  MainController mainController = Get.find<MainController>();

  nextPage() {
    if (hasMorePage.value) {
      page++;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ever(page, (value){
      getMyInvoices();
    });
  }

  @override
  void onReady() {

    super.onReady();
    getMyInvoices();
  }

  getMyInvoices() async {
    loading.value = true;
    mainController.query.value = '''
    query MyInvoice {
    myInvoice(first: 35, page: ${page.value}) {
        paginatorInfo {
            hasMorePages
        }
        data {
            id
            status
            created_at
            total
            shipping
            address
            phone
            seller {
                seller_name
                phone
                image
            }
            items {
                qty
                price
                total
                product {
                    name
                    image
                }
            }
        }
    }
}
    ''';
    try {
      dio.Response? res = await mainController.fetchData();
      mainController.logger.f(res?.data);
      if (res?.data?['data']?['myInvoice']['paginatorInfo'] != null) {
        hasMorePage.value =
            res?.data?['data']?['myInvoice']['paginatorInfo']?['hasMorePages'];
      }
      if (res?.data?['data']?['myInvoice']['data'] != null) {
        for (var item in res?.data?['data']?['myInvoice']['data']) {
          invoices.add(InvoiceModel.fromJson(item));
        }
      }
    } catch (e) {}
    loading.value = false;
  }


  changeStatus(
      {required int invoiceId,
        required String status,
        String? msg = ''}) async {
    changeLoading.value=true;
    mainController.query.value='''
    mutation ChangeStatusInvoice {
    changeStatusInvoice(invoiceId: "$invoiceId}", status: "$status" , msg:"$msg") {
         id
            status
            created_at
            total
            shipping
            address
            phone
            seller {
                seller_name
                phone
                image
            }
            items {
                qty
                price
                total
                product {
                    name
                    image
                }
            }
    }
}

    ''';
    try{
      dio.Response? res = await mainController.fetchData();
Logger().f(res?.data);
      if(res?.data?['data']?['changeStatusInvoice']!=null){
        int index=invoices.indexWhere((el)=>el.id==invoiceId);
        if(index>-1){
          invoices[index]=InvoiceModel.fromJson(res?.data?['data']?['changeStatusInvoice']);
        }
        mainController.showToast(text: 'تم تعديل حالة الطلب بنجاح');
      }
    }catch(e){

    }
    changeLoading.value=false;
  }
}
