import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:ali_pasha_graph/components/home_app_bar/view.dart';
import 'package:ali_pasha_graph/components/product_components/minimize_details_product_component.dart';
import 'package:ali_pasha_graph/components/product_components/minimize_details_product_component_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../components/progress_loading.dart';
import '../../helpers/colors.dart';
import '../../helpers/style.dart';
import '../../routes/routes_url.dart';
import 'logic.dart';

class TendersPage extends StatelessWidget {
  TendersPage({Key? key}) : super(key: key);

  final logic = Get.find<TendersLogic>();
  MainController mainController = Get.find<MainController>();
  ScrollController _scrollController=ScrollController();
bool exit=false;
  @override
  Widget build(BuildContext context) {
    exit=false;
    return WillPopScope(
      child: Scaffold(
          backgroundColor: WhiteColor,
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.80 &&
                  !mainController.loading.value &&
                  logic.hasMorePage.value) {
                logic.nextPage();
              }

              if (scrollInfo is ScrollUpdateNotification) {
                if (scrollInfo.metrics.pixels >
                    scrollInfo.metrics.minScrollExtent) {
                  mainController.is_show_home_appbar(false);
                } else {
                  mainController.is_show_home_appbar(true);
                }
              }
              return true;
            },
            child: Column(
              children: [
                HomeAppBarComponent(selected: 'tender',),
                Expanded(
                    child: Container(
                  child: Obx(() => ListView(
                    controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.02.sw,
                          vertical: 0.02.sh,
                        ),
                        children: [
                          ...List.generate(
                            logic.tenders.length ,
                            (index) {

                                return MinimizeDetailsJobComponent(post: logic.tenders[index],TitleColor: DarkColor,onClick: (){
                                  Get.toNamed(PRODUCT_PAGE,arguments:  logic.tenders[index].id);
                                },);


                            },
                          ),
                          if(logic.loading.value && logic.page.value==1) ...List.generate(6 ,(index) => MinimizeDetailsProductComponentLoading(),),
                          if(logic.loading.value && logic.page.value>1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(child: Container(height: 0.06.sh,child: ProgressLoading())),
                                Flexible(child: Text('جاري جلب المزيد',style: H4GrayTextStyle,))
                              ],
                            ),
                          if (!logic.hasMorePage.value && !logic.loading.value)
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'لا يوجد مزيد من النتائج',
                                style: H3GrayTextStyle,
                              ),
                            )),
                        ],
                      )),
                ))
              ],
            ),
          )),
      onWillPop: (){
        if(exit==true){
          Get.offNamed(HOME_PAGE);
        }else{
          _scrollController.animateTo(0, duration: Duration(microseconds: 100), curve: Curves.linear);
          exit=true;
        }
        return Future.value(false);
      },
    );
  }
}
