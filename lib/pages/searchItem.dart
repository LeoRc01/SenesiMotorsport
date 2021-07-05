import 'dart:convert';

import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/main.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:SenesiMotorsport/pages/showItemsPage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchItemPage extends StatelessWidget {
  Controller controller = new Controller();

  TextEditingController nameController = new TextEditingController();

  Future<dynamic> foundItems(String like) async {
    controller.itemList.removeRange(0, controller.itemList.length);
    if (like != "") {
      controller.setIsLoading();
      var url = UrlApp.url + "/searchItem.php?like=" + like;
      Response request = await http.get(url).then((value) {
        controller.itemList = jsonDecode(value.body);
        print(controller.itemList);
        controller.setNotLoadingLoading();
      }).catchError((onError) {
        controller.setNotLoadingLoading();
        Get.snackbar("Error", onError.toString(),
            colorText: colorController.getBackGroundColorTheme());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.darkColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(
          () => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: colorController.getBackGroundColorTheme(),
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.getLoading()
                    ? Center(child: CircularProgressIndicator())
                    : controller.itemList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: controller.itemList.length,
                            itemBuilder: (context, index) {
                              return FoundItemTile(
                                  controller.itemList[index]["itemName"],
                                  controller.itemList[index]["itemId"],
                                  controller.itemList[index]["bagName"]);
                            })
                        : Text("No items found.",
                            style: GoogleFonts.montserrat(
                                color:
                                    colorController.getBackGroundColorTheme(),
                                fontSize: Get.width * 0.05)),
              ),
              //BUILDING THE BOTTOM TEXTFIELD THAT STICKS TO THE KEYBOARD
              SafeArea(
                top: false,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: colorController.getBackGroundColorTheme(),
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.bottomCenter,
                  child: TextFormField(
                    autofocus: true,
                    enabled: true,
                    autocorrect: false,
                    style: GoogleFonts.montserrat(
                        color: colorController.getTextColorTheme()),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: "Insert the name of the item",
                        hintStyle: GoogleFonts.montserrat(color: Colors.grey)),
                    controller: nameController,
                    onChanged: (value) {
                      //print(value);
                      if (value.isEmpty) {
                        print("empti");
                        controller.itemList
                            .removeRange(0, controller.itemList.length);
                      } else {
                        foundItems(nameController.text);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoundItemTile extends StatelessWidget {
  String itemName;
  String itemId;
  String bagName;

  FoundItemTile(this.itemName, this.itemId, this.bagName);

  deleteItem() async {
    var url = UrlApp.url + "/deleteItem.php?itemId=" + itemId.toString();
    Response response = await http.get(url).then((value) {
      Get.back();
      Get.offAll(() => MainPage());
      Get.snackbar("Done!", "Item deleted correctly",
          colorText: colorController.getBackGroundColorTheme());
    }).catchError((error) {
      Get.snackbar("Error", "No Internet",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        GestureDetector(
          onTap: () {
            deleteItem();
          },
          child: CupertinoCard(
            margin: EdgeInsets.only(bottom: 10, right: 5),
            color: Colors.red,
            radius: BorderRadius.all(new Radius.circular(50)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FaIcon(FontAwesomeIcons.trash, color: Colors.white),
                Text(
                  "Delete",
                  style: GoogleFonts.montserrat(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: Get.width,
        decoration: BoxDecoration(
          color: colorController.getBackGroundColorTheme(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mainColor),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(itemName,
                style: GoogleFonts.montserrat(
                    color: colorController.getTextColorTheme(),
                    fontSize: Get.width * 0.045)),
            FaIcon(
              FontAwesomeIcons.arrowDown,
              color: colorController.getTextColorTheme(),
            ),
            Text(bagName,
                style: GoogleFonts.montserrat(
                    color: colorController.getTextColorTheme(),
                    fontSize: Get.width * 0.045))
          ],
        ),
      ),
    );
  }
}
