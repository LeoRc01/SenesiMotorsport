import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/pages/showItemsPage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CreateItemPage extends StatefulWidget {
  final bagID;

  CreateItemPage(this.bagID);

  @override
  _CreateItemPageState createState() => _CreateItemPageState();
}

/*
item: 
- Category
|
 --Image based on category
- Name (max 15 caratteri)
- Initial Quantity 

*/

final int maxItemNameLetters = 25;

bool hasBeenSelected = false;
String categoryName = "";

class _CreateItemPageState extends State<CreateItemPage> {
  TextEditingController nameController = new TextEditingController();

  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
        value: "Tyres",
        child: Text(
          "Tyres",
          style: GoogleFonts.montserrat(color: Colors.white),
        )),
    DropdownMenuItem(
        value: "Engine",
        child: Text(
          "Engine",
          style: GoogleFonts.montserrat(color: Colors.white),
        )),
    DropdownMenuItem(
        value: "Tools",
        child: Text(
          "Tools",
          style: GoogleFonts.montserrat(color: Colors.white),
        )),
    DropdownMenuItem(
        value: "Oils",
        child: Text(
          "Oils",
          style: GoogleFonts.montserrat(color: Colors.white),
        )),
  ];

  Controller getX_Controller = new Controller();
  Controller countItemNameLettersController = new Controller();

  @override
  void initState() {
    getX_Controller.changeCategoryValue(items[0].value.toString());
    super.initState();
  }

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        width: Get.width,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.darkColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleTile(text: "Name"),
                InputTile(
                  controller: nameController,
                  hintText: "Name",
                  getController: countItemNameLettersController,
                ),
                TitleTile(
                  text: "Category",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width / 2.7,
                      child: DropdownButton<String>(
                        elevation: 0,
                        dropdownColor: AppColors.darkColor,
                        isExpanded: true,
                        hint: Obx(
                          () => Text(
                            getX_Controller.selectedCategoryValue.toString(),
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                        ),
                        items: items,
                        onChanged: (clickedItem) {
                          getX_Controller.changeCategoryValue(clickedItem);
                        },
                      ),
                    ),
                    /*
                        Text(
                          "or",
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            //TODO: create popup menu with GETX
                          },
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Create a new one",
                              style: GoogleFonts.montserrat(color: Colors.white),
                            ),
                          ),
                        ),*/
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.minus,
                          color: AppColors.mainColor,
                        ),
                        onPressed: () {
                          getX_Controller.decrementQuantity();
                        }),
                    Obx(
                      () => Text(getX_Controller.quantity.toString(),
                          style: GoogleFonts.montserrat(
                              color: AppColors.mainColor,
                              fontSize: Get.width * 0.06)),
                    ),
                    IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.plus,
                          color: AppColors.mainColor,
                        ),
                        onPressed: () {
                          getX_Controller.incrementQuantity();
                        }),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          //FIXME: "Personal category" still to be implemented
                          //DONE: Create item DONE!
                          if (key.currentState.validate()) {
                            if (getX_Controller.getQuantity() == 0) {
                              Get.snackbar("Error", "Quantity can't be 0");
                            } else {
                              try {
                                var itemName = nameController.text;
                                var quantity = getX_Controller.getQuantity();
                                categoryName =
                                    getX_Controller.getCategoryValue();
                                print("name: " + categoryName);
                                var url = UrlApp.url +
                                    "/insertItem.php?name=" +
                                    itemName +
                                    "&quantity=" +
                                    quantity.toString() +
                                    "&categoryName=" +
                                    categoryName +
                                    "&email=" +
                                    UserEmail.userEmail;
                                Response res =
                                    await http.get(url).then((value) {
                                  if (value.body == "1") {
                                    Get.back();
                                    Get.back();
                                    Get.to(
                                        () => ShowItemsPage(
                                              bagID: widget.bagID,
                                            ),
                                        transition: Transition.rightToLeft);
                                    Get.snackbar(
                                        "Done!", "Item inserted correctly");
                                  } else {
                                    Get.snackbar("Error", value.body,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                }).catchError((error) {
                                  print(error);
                                  Get.snackbar("Error", "No internet",
                                      snackPosition: SnackPosition.BOTTOM);
                                });
                              } catch (e) {
                                Get.snackbar("Error", e.toString(),
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            }
                          }
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: Get.height / 8),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 50),
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text("Create",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: Get.width * 0.045)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        const _url = 'https://senesimotorsport.com/';

                        await canLaunch(_url)
                            ? await launch(_url)
                            : throw 'Could not launch $_url';
                      },
                      child: Text(
                        "www.senesimotorsport.com",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatefulWidget {
  final categoryName;

  const CategoryButton({Key key, this.categoryName}) : super(key: key);
  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  Color selectedColor = AppColors.mainColor;
  int click = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!hasBeenSelected || this.click == 1) {
          if (click == 0) {
            setState(() {
              selectedColor = Colors.green;
              hasBeenSelected = true;
              this.click++;
              categoryName = widget.categoryName;
            });
          } else {
            setState(() {
              selectedColor = AppColors.mainColor;
              hasBeenSelected = false;
              this.click--;
              categoryName = "";
            });
          }
        }
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: selectedColor),
        child: Center(
            child: Text(
          widget.categoryName,
          style: GoogleFonts.montserrat(color: Colors.white),
        )),
      ),
    );
  }
}

class TitleTile extends StatelessWidget {
  final text;

  const TitleTile({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          color: AppColors.mainColor,
          fontSize: Get.width * 0.06,
          fontWeight: FontWeight.w600),
    );
  }
}

class InputTile extends StatelessWidget {
  TextEditingController controller;
  final hintText;
  Controller getController;

  InputTile({Key key, this.controller, this.hintText, this.getController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 25,
      onChanged: (value) {
        if (hintText == 'Name') {
          getController.setQuantity(controller.text.length);
        }
      },
      controller: controller,
      validator: (value) {
        if (hintText == "Name") {
          if (value.isEmpty) {
            return "Please insert a name";
          } else if (value.length > maxItemNameLetters) {
            return "Max 20 characters";
          }
        }
      },
      style: GoogleFonts.montserrat(color: Colors.white),
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        errorStyle: GoogleFonts.montserrat(color: AppColors.mainColor),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(color: Colors.grey),
      ),
    );
  }
}
