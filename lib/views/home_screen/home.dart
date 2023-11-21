import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:emart_seller/views/home_screen/home_screen.dart';
import 'package:emart_seller/views/orders_screen/orders_screen.dart';
import 'package:emart_seller/views/products_screen/products_screen.dart';
import 'package:emart_seller/views/profile_screen/profile_screen.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreen = [
      HomeScreen(),
      ProductsScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ];
    var bottomNavbar = [
      BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 24, color: darkGrey), label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(icProducts, width: 24, color: darkGrey),
          label: products),
      BottomNavigationBarItem(
          icon: Image.asset(icOrders, width: 24, color: darkGrey),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(icGeneralSettings, width: 24, color: darkGrey),
          label: settings)
    ];
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.navIndex.value = index;
          },
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          unselectedItemColor: darkGrey,
          items: bottomNavbar,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
