import 'dart:convert';

import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/pages/createItemPage.dart';
import 'package:SenesiMotorsport/pages/notesandfoldersPage.dart';
import 'package:SenesiMotorsport/pages/showItemsPage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_choices/search_choices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  Controller countNameLetters = new Controller();
  Controller countDescLetters = new Controller();

  int maxNameLetters = 15;
  int maxDescLetters = 20;

  List<dynamic> allItems = [];

  Controller mainPageController = new Controller();

  @override
  void initState() {
    super.initState();
    getAllBags();
  }

  getAllBags() async {
    allItems.removeRange(0, allItems.length);
    mainPageController.setIsLoading();
    var url = UrlApp.url + "/showAllBags.php";
    Response res = await http.get(url).then((value) {
      allItems = jsonDecode(value.body);
      print(allItems);
      mainPageController.setNotLoadingLoading();
    }).catchError((error) {
      Get.snackbar("Error", "No Internet");
      mainPageController.setNotLoadingLoading();
    });
  }

  final createBagKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.listAlt,
                color: Colors.white,
              ),
              onPressed: null)
        ],
        title: Text(
          "Your Bags",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, fontSize: Get.width * 0.07),
        ),
        backgroundColor: Colors.transparent,
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            backgroundColor: AppColors.darkColor,
            title: "Create your bag!",
            titleStyle: GoogleFonts.montserrat(color: Colors.red),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: createBagKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TitleTile(title: "Name"),
                        Obx(
                          () => TitleTile(
                            title: countNameLetters.getQuantity().toString() +
                                "/" +
                                maxNameLetters.toString(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          countNameLetters
                              .setQuantity(nameController.text.length);
                        },
                        controller: nameController,
                        validator: (value) {
                          if (value.length > maxNameLetters) {
                            return "Name too long.";
                          }
                          if (value.isEmpty) {
                            return "Please insert a name.";
                          }
                        },
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Max 10 characters",
                          hintStyle: GoogleFonts.montserrat(),
                        ),
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TitleTile(title: "Description"),
                        Obx(
                          () => TitleTile(
                            title: countDescLetters.getQuantity().toString() +
                                "/" +
                                maxDescLetters.toString(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          countDescLetters
                              .setQuantity(descController.text.length);
                        },
                        controller: descController,
                        validator: (value) {
                          if (value.length > 20) {
                            return "Description too long.";
                          }
                          if (value.isEmpty) {
                            return "Please insert a description.";
                          }
                        },
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Max 20 characters",
                          hintStyle: GoogleFonts.montserrat(),
                        ),
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        //DONE: Add bag

                        if (createBagKey.currentState.validate()) {
                          Get.back();
                          print(nameController.text.trim());

                          var url = UrlApp.url +
                              "/createBag.php?bagName=" +
                              nameController.text.trim() +
                              "&desc=" +
                              descController.text.trim();
                          Response response = await http.get(url).then((value) {
                            countDescLetters.setQuantity(0);
                            countNameLetters.setQuantity(0);
                            Get.snackbar("Done!", "Bag created successfully!");
                            nameController.text = "";
                            descController.text = "";
                            getAllBags();
                          }).catchError((error) {
                            Get.snackbar("Error", "No internet.");
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Create",
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: FaIcon(FontAwesomeIcons.plus),
        backgroundColor: AppColors.darkColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            return getAllBags();
          },
          child: Obx(
            () => mainPageController.getLoading()
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.stickyNote,
                                color: AppColors.darkColor,
                              ),
                              onPressed: () {
                                Get.to(
                                    NoteAndFolders("mainpage", "Your folders"));
                              }),
                        ),
                      ),
                      allItems.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text("No items available.",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: Get.width * 0.05,
                                    )),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: StaggeredGridView.countBuilder(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  itemCount: allItems.length,
                                  itemBuilder: (context, index) {
                                    return new BagTile(
                                      image: "assets/bag.png",
                                      title: allItems[index]['bagName'],
                                      desc: allItems[index]['description'],
                                      bagID: allItems[index]['bagID'],
                                    );
                                  },
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(1)),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class TitleTile extends StatelessWidget {
  final title;

  const TitleTile({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toString(),
      textAlign: TextAlign.left,
      style: GoogleFonts.montserrat(color: Colors.white),
    );
  }
}

class BagTile extends StatefulWidget {
  final title; //Title must be MAX: 10 WORDS
  final desc;
  final image;
  final bagID;

  const BagTile({Key key, this.title, this.desc, this.image, this.bagID})
      : super(key: key);

  @override
  _BagTileState createState() => _BagTileState();
}

class _BagTileState extends State<BagTile> {
  @override
  void initState() {
    super.initState();
    getBagItems(int.parse(widget.bagID));
  }

  List<dynamic> allItems;
  List<Widget> list = [];
  getBagItems(int bagID) async {
    var url = UrlApp.url + "/getAllItemsFromBag.php?bagId=" + bagID.toString();
    Response res = await http.get(url).then((value) {
      allItems = jsonDecode(value.body);
      for (var item in allItems) {
        var image = "";
        switch (item['categoryName']) {
          case 'Tools':
            image = "assets/tool.png";
            break;
          case 'Tyres':
            image = "assets/tyres.png";
            break;
          case 'Oils':
            image = "assets/oil.png";
            break;
          default:
            image = "assets/default.png";
            break;
        }
        Item temp = new Item(
          image: image,
          text: item['itemName'],
          category: item['categoryName'],
          itemID: item['itemId'],
          quantity: int.parse(item['quantity'].toString()),
          list: list,
        );
        list.add(temp);
      }
    }).catchError((error) {
      print(error);
      Get.snackbar("Error", "No internet", snackPosition: SnackPosition.BOTTOM);
    });
  }

  deleteBag(int bagID) async {
    var url = UrlApp.url + "/deleteBag.php?bagId=" + bagID.toString();
    Response response = await http.get(url).then((value) {
      Get.back();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));

      Get.snackbar("Done!", "Bag deleted correctly!");
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    //DONE: Implement "Delete Bag"
    return GestureDetector(
      onTap: () => showCupertinoModalBottomSheet(
        expand: false,
        context: context,
        duration: Duration(milliseconds: 1300),
        builder: (context) {
          return Material(
              child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: Container(),
              backgroundColor: AppColors.darkColor,
              middle: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                      () => ShowItemsPage(
                            bagID: widget.bagID,
                          ),
                      transition: Transition.zoom);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Add Item",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.darkColor,
            child: SafeArea(
              child: ListView(
                reverse: false,
                shrinkWrap: true,
                controller: ModalScrollController.of(context),
                physics: BouncingScrollPhysics(),
                children: list,
              ),
            ),
          ));
        },
      ),
      onLongPress: () {
        Get.defaultDialog(
          content: Text("Are you sure you want to delete this bag?",
              style: GoogleFonts.montserrat(color: Colors.white)),
          backgroundColor: AppColors.darkColor,
          title: "Delete this bag?",
          textConfirm: "Yes",
          confirmTextColor: Colors.white,
          textCancel: "No",
          titleStyle: GoogleFonts.montserrat(color: Colors.white),
          onConfirm: () {
            deleteBag(int.parse(widget.bagID));
            Get.back();
          },
        );
      },
      child: Container(
        height: 250,
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image.toString(),
            ),
            Text(
              widget.title.toString(),
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: Get.width * 0.04),
            ),
            Text(
              widget.desc.toString().length > 25
                  ? widget.desc.toString().substring(0, 23) + "..."
                  : widget.desc.toString(),
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: Get.width * 0.04),
            )
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final image;
  final text;
  final category;
  final itemID;
  int quantity;
  List list;

  bool changed = false;

  Item(
      {Key key,
      this.category,
      this.image,
      this.text,
      this.quantity,
      this.itemID,
      this.list});
  @override
  Widget build(BuildContext context) {
    Controller controller = new Controller();
    controller.initializeQuantity(quantity);
    return GestureDetector(
      onLongPress: () async {
        //TODO: Redirect to website if category
        if (category == "Oils") {
          const _url =
              'https://senesimotorsport.com/product-category/oli-al-silicone/';

          await canLaunch(_url)
              ? await launch(_url)
              : throw 'Could not launch $_url';
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: Get.width,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(width: Get.width / 4, child: Image.asset(image)),
            Container(
              width: Get.width / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: Get.width * 0.03,
                          ),
                          onPressed: () {
                            controller.decrementQuantity();
                            if (quantity > 0) quantity--;
                            //TODO: Implement other categories
                            if (category == 'Oils' &&
                                controller.getQuantity() == 0) {
                              Get.defaultDialog(
                                  backgroundColor: AppColors.darkColor,
                                  titleStyle: GoogleFonts.montserrat(
                                      color: Colors.white),
                                  title: "Do you want to buy new oils?",
                                  content: Container(),
                                  actions: [
                                    GestureDetector(
                                      onTap: () => Get.back(),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.red),
                                        child: Text(
                                          "No",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        const _url =
                                            'https://senesimotorsport.com/product-category/oli-al-silicone/';

                                        await canLaunch(_url)
                                            ? await launch(_url)
                                            : throw 'Could not launch $_url';
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.mainColor),
                                        child: Text(
                                          "Yes",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ]);
                            }
                            if (controller.getQuantity() == quantity) {
                              controller.setToNotChanged();
                            } else {
                              controller.setToChanged();
                            }
                          }),
                      Obx(
                        () => Text(
                          controller.quantity.toString(),
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                      IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: Get.width * 0.03,
                          ),
                          onPressed: () {
                            controller.incrementQuantity();
                            quantity++;
                            if (controller.getQuantity() == quantity) {
                              controller.setToNotChanged();
                            } else {
                              controller.setToChanged();
                            }
                          }),
                    ],
                  ),
                  Obx(
                    () => controller.getChanged()
                        ? GestureDetector(
                            onTap: () async {
                              //FIXME: Fix Update not fading away
                              if (controller.getQuantity() == 0) {
                                //DONE: Delete Item
                                var url = UrlApp.url +
                                    "/deleteItem.php?itemId=" +
                                    itemID.toString();
                                Response response =
                                    await http.get(url).then((value) {
                                  controller.setToNotChanged();
                                  list.remove(this);
                                  Get.back();
                                  Get.snackbar(
                                      "Done!", "Item deleted correctly");
                                }).catchError((error) {
                                  Get.snackbar("Error", error.toString());
                                });
                              } else {
                                var url = UrlApp.url +
                                    "/updateItemQuantity.php?itemId=" +
                                    itemID +
                                    "&quantity=" +
                                    controller.getQuantity().toString();
                                Response response =
                                    await http.get(url).then((value) {
                                  controller.setToNotChanged();
                                  Get.back();
                                  Get.snackbar(
                                      "Done!", "Item updated correctly");
                                }).catchError((error) {
                                  Get.snackbar("Error", error.toString());
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Center(
                                child: Text(
                                  "Update",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
