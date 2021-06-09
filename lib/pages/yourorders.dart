import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/logs/loginPage.dart';
import 'package:SenesiMotorsport/pages/createItemPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:woocommerce/models/order.dart';

class YourOrders extends StatefulWidget {
  @override
  _YourOrdersState createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  Widget appBar() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: [
              Container(
                child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: AppColors.darkColor,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
              ),
              Text(
                "Your orders",
                style: GoogleFonts.montserrat(
                    color: AppColors.darkColor,
                    fontSize: Get.width * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Controller controller;

  @override
  void initState() {
    controller = new Controller();
    getOrderHistory();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<LineItems> orderedItems = [];

  getOrderHistory() async {
    controller.setIsLoading();
    woocommerce.getOrders().then((value) {
      for (var item in value) {
        Map<String, dynamic> order = item.toJson();
        Map<String, dynamic> billing = order["billing"];

        //print(billing["email"]);
        if (billing["email"] == UserEmail.userEmail) {
          controller.setHasOrderedSomething(true);
          for (var product in item.lineItems) {
            orderedItems.add(product);
            print(product.name);
            print(product.quantity);
          }
        }
      }
      if (!controller.getHasOrderedSomething()) {
        print("User has not made any orders yet.");
      }
      controller.setNotLoadingLoading();
    }).catchError((error) {
      controller.setNotLoadingLoading();
      Get.snackbar("Error!", error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() => controller.getLoading()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  appBar(),
                  controller.getHasOrderedSomething()
                      ? Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return OrderItemTile(orderedItems[index]);
                                  })),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              "You don't have any orders from SenesiMotorSport",
                              style:
                                  GoogleFonts.montserrat(color: Colors.black),
                            ),
                          ),
                        ),
                ],
              )),
      ),
    );
  }
}

class OrderItemTile extends StatelessWidget {
  LineItems product;

  OrderItemTile(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: AppColors.darkColor,
        border: Border.all(color: AppColors.mainColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Item name",
                  style: GoogleFonts.montserrat(
                      color: AppColors.darkLighterColor,
                      fontSize: Get.width * 0.035)),
              Text(product.name.toString().substring(0, 9) + "...",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: Get.width * 0.04))
            ],
          ),
          /*
          Column(
            children: [
              Text("Order date",
                  style: GoogleFonts.montserrat(
                      color: AppColors.darkLighterColor,
                      fontSize: Get.width * 0.035)),
              Text("06/08/2021",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: Get.width * 0.04))
            ],
          ),*/
          Column(
            children: [
              Text("Quantity",
                  style: GoogleFonts.montserrat(
                      color: AppColors.darkLighterColor,
                      fontSize: Get.width * 0.035)),
              Text(product.quantity.toString(),
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: Get.width * 0.04))
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => CreateItemPage.fromOrders(product, true));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Create Item",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
