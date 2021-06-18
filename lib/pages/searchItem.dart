import 'dart:convert';

import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SearchItemPage extends StatefulWidget {
  @override
  _SearchItemPageState createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  Controller controller = new Controller();

  TextEditingController nameController = new TextEditingController();

  Future<dynamic> foundItems(String like) async {
    controller.itemList.removeRange(0, controller.itemList.length);
    if (like != "") {
      controller.setIsLoading();
      var url = UrlApp.url + "/searchItem.php?like=" + like;
      Request request = await http.get(url).then((value) {
        controller.itemList = jsonDecode(value.body);
        controller.setNotLoadingLoading();
      }).catchError((onError) {
        controller.setNotLoadingLoading();
        Get.snackbar("Error", onError.toString());
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
                            color: AppColors.darkColor,
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
                                  controller.itemList[index]["bagName"]);
                            })
                        : Text("No items found.",
                            style: GoogleFonts.montserrat(
                                fontSize: Get.width * 0.05)),
              ),
              SafeArea(
                top: false,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.darkColor,
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.bottomCenter,
                  child: TextFormField(
                    autofocus: true,
                    enabled: true,
                    autocorrect: false,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: "Insert the name of the item",
                        hintStyle: GoogleFonts.montserrat(color: Colors.grey)),
                    controller: nameController,
                    onChanged: (value) {
                      //print(value);
                      foundItems(nameController.text);
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
  String bagName;

  FoundItemTile(this.itemName, this.bagName);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.darkColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mainColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(itemName,
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: Get.width * 0.045)),
          FaIcon(
            FontAwesomeIcons.arrowDown,
            color: Colors.white,
          ),
          Text(bagName,
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: Get.width * 0.045))
        ],
      ),
    );
  }
}
