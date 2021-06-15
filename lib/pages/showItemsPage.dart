import 'dart:convert';

import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/pages/createItemPage.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:badges/badges.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class ShowItemsPage extends StatefulWidget {
  final bagID;

  bool comingFromPage = false;

  ShowItemsPage.comingFromPage(this.comingFromPage, {this.bagID = null});

  ShowItemsPage({Key key, this.bagID, this.comingFromPage = false})
      : super(key: key);
  @override
  _ShowItemsPageState createState() => _ShowItemsPageState();
}

Controller showItemsPagecontroller;

List<Item> selectedItems = [];
//List<Item> itemList = [];

class _ShowItemsPageState extends State<ShowItemsPage> {
  //DONE: Show all items from database
  @override
  void initState() {
    super.initState();
    showItemsPagecontroller = new Controller();

    getAllItems();
  }

  @override
  void dispose() {
    showItemsPagecontroller.dispose();
    super.dispose();
  }

  //DONE: Implement delete item

  List<dynamic> allItems = [];

  getAllItems() async {
    allItems.removeRange(0, allItems.length);
    showItemsPagecontroller.itemList
        .removeRange(0, showItemsPagecontroller.itemList.length);
    showItemsPagecontroller.setIsLoading();
    var url = UrlApp.url + "/showAllItems.php?email=" + UserEmail.userEmail;
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
          text: item['itemName'],
          quantity: int.parse(item['quantity']),
          image: image,
          itemID: item['itemId'],
          state: widget.comingFromPage,
        );
        showItemsPagecontroller.itemList.add(temp);
      }
      showItemsPagecontroller.itemList =
          showItemsPagecontroller.itemList.reversed.toList();
      showItemsPagecontroller.setNotLoadingLoading();
    }).catchError((error) {
      Get.snackbar("Error", "No Internet");
      showItemsPagecontroller.setNotLoadingLoading();
    });
  }

  addItems() async {
    Get.back();
    showItemsPagecontroller.setIsLoading();
    var str;
    for (var item in selectedItems) {
      print("ITEMID: " + item.itemID);
      print("BAGID: " + widget.bagID.toString());
      var url = UrlApp.url +
          "/addItemToBag.php?itemId=" +
          item.itemID +
          "&bagId=" +
          widget.bagID.toString() +
          "&email=" +
          UserEmail.userEmail;
      Response response = await http.get(url).then((value) {
        str = value.body;
        print("Added Item: " + item.itemID);
      }).catchError((error) {
        Get.snackbar("Error", "No Internet");
      });
    }
    selectedItems.removeRange(0, selectedItems.length);
    showItemsPagecontroller.setQuantityToZero();
    showItemsPagecontroller.setNotLoadingLoading();
    Get.back();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));

    Get.snackbar("Done!", str);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkColor,
        child: FaIcon(FontAwesomeIcons.plus),
        onPressed: () {
          Get.to(CreateItemPage(widget.bagID), transition: Transition.zoom);
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(
          () => showItemsPagecontroller.getLoading()
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    //APPBAR
                    Container(
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.chevronLeft),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              Text(
                                "Your Items",
                                style: GoogleFonts.montserrat(
                                    color: AppColors.darkColor,
                                    fontSize: Get.width * 0.07,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          !widget.comingFromPage
                              ? Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      if (showItemsPagecontroller
                                              .getQuantity() >
                                          0) {
                                        Get.defaultDialog(
                                            title: "Add these items?",
                                            titleStyle: GoogleFonts.montserrat(
                                                color: Colors.white),
                                            backgroundColor:
                                                AppColors.darkColor,
                                            content: Container(),
                                            actions: [
                                              GestureDetector(
                                                onTap: () => Get.back(),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.red),
                                                  child: Text(
                                                    "No",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  //DONE: Add items to bag
                                                  addItems();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          AppColors.mainColor),
                                                  child: Text(
                                                    "Yes",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ),
                                              ),
                                            ]);
                                      }
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 20, top: 5),
                                      child: Badge(
                                        shape: BadgeShape.circle,
                                        toAnimate: true,
                                        badgeColor: AppColors.darkColor,
                                        position: BadgePosition.topStart(),
                                        badgeContent: Text(
                                          showItemsPagecontroller.quantity
                                              .toString(),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white),
                                        ),
                                        child:
                                            Icon(Icons.shopping_bag_outlined),
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),

                    //BODY PAGE
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          return getAllItems();
                        },
                        child: Obx(
                          () => showItemsPagecontroller.getLoading()
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : showItemsPagecontroller.itemList.length != 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: showItemsPagecontroller
                                          .itemList.length,
                                      itemBuilder: (context, index) {
                                        return showItemsPagecontroller
                                            .itemList[index];
                                      })
                                  : Expanded(
                                      child: Center(
                                        child: Text(
                                          "You have no items available.",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final image;
  final text;
  int quantity;
  final itemID;
  bool state;

  Item(
      {Key key, this.image, this.text, this.quantity, this.itemID, this.state});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Color selectedColor = AppColors.darkColor;
  bool click = false;
  int initQuantity = 0;
  @override
  void initState() {
    super.initState();
    initQuantity = widget.quantity;
  }

  deleteItem() async {
    var url = UrlApp.url + "/deleteItem.php?itemId=" + widget.itemID.toString();
    Response response = await http.get(url).then((value) {
      Get.back();
      Get.to(() => ShowItemsPage(), transition: Transition.noTransition);
      Get.snackbar("Done!", "Item deleted correctly");
    }).catchError((error) {
      Get.snackbar("Error", "No Internet");
    });
  }

  updateItem() async {
    if (widget.quantity == 0) {
      //Elimino l'elemento
      deleteItem();
    } else {
      //Aggiorno l'elemento
      var url = UrlApp.url +
          "/updateItemQuantity.php?itemId=" +
          widget.itemID +
          "&quantity=" +
          widget.quantity.toString();
      Response response = await http.get(url).then((value) {
        print("Done!");
        Get.snackbar("Done!", "Item updated correctly");
        setState(() {
          initQuantity = widget.quantity;
        });
      }).catchError((error) {
        Get.snackbar("Error", "No Internet.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!widget.state) if (!click) {
            if (widget.quantity != 0) {
              selectedColor = Colors.green;
              click = !click;
              selectedItems.add(widget);
              showItemsPagecontroller.incrementQuantity();
              selectedItems.forEach((element) {
                print(element.itemID);
              });
            }
          } else {
            selectedItems.remove(widget);
            showItemsPagecontroller.decrementQuantity();
            selectedColor = AppColors.darkColor;
            click = !click;
            print(selectedItems);
          }
        });
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: [
          GestureDetector(
            onTap: () {
              deleteItem();
            },
            child: CupertinoCard(
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
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: Get.width,
          height: 100,
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: Get.width / 4,
                  child: Image.asset(widget.image)),
              Container(
                width: Get.width / 4,
                child: Center(
                  child: Text(
                    widget.text,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                //width: Get.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Colors.white,
                              size: Get.width * 0.03,
                            ),
                            onPressed: () {
                              if (!click) {
                                if (widget.quantity > 0) {
                                  setState(() {
                                    widget.quantity--;
                                  });
                                }
                              }
                            }),
                        Text(
                          widget.quantity.toString(),
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                              size: Get.width * 0.03,
                            ),
                            onPressed: () {
                              if (!click) {
                                setState(() {
                                  widget.quantity++;
                                });
                              }
                            }),
                      ],
                    ),
                    (initQuantity != widget.quantity && !click)
                        ? GestureDetector(
                            onTap: () async {
                              //DONE: implement update item

                              updateItem();
                            },
                            child: Container(
                              //width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Center(
                                child: Text(
                                  "Update",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
