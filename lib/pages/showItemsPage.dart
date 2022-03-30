import 'dart:convert';

import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/main.dart';
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

//List<Item> selectedItems = [];
//List<Item> itemList = [];

class _ShowItemsPageState extends State<ShowItemsPage>
    with TickerProviderStateMixin {
  //DONE: Show all items from database
  @override
  void initState() {
    super.initState();
    showItemsPagecontroller = new Controller();
    _tabController = new TabController(length: 5, vsync: this);
    getAllItems();
  }

  @override
  void dispose() {
    showItemsPagecontroller.dispose();

    super.dispose();
  }

  //DONE: Implement delete item

  List<dynamic> allItems = [];
  List<Tab> tabList = [
    Tab(
      text: "Recently added",
    ),
    Tab(
      text: "Tyres",
    ),
    Tab(
      text: "Oils",
    ),
    Tab(
      text: "Engines",
    ),
    Tab(
      text: "Tools",
    ),
  ];

  TabController _tabController;

  getAllItems() async {
    showItemsPagecontroller.selectedItems
        .removeRange(0, showItemsPagecontroller.selectedItems.length);
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
          case 'Engine':
            image = "assets/engine.png";
            break;
          default:
            image = "assets/default.png";
            break;
        }
        Item temp = new Item(
          pageController: showItemsPagecontroller,
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
      Get.snackbar("Error", "No Internet",
          colorText: colorController.getBackGroundColorTheme());
      showItemsPagecontroller.setNotLoadingLoading();
    });
  }

  addItems() async {
    Get.back();
    showItemsPagecontroller.setIsLoading();
    var str;
    for (var item in showItemsPagecontroller.selectedItems) {
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
        Get.snackbar("Error", "No Internet",
            colorText: colorController.getBackGroundColorTheme());
      });
    }
    showItemsPagecontroller.selectedItems
        .removeRange(0, showItemsPagecontroller.selectedItems.length);
    showItemsPagecontroller.setQuantityToZero();
    showItemsPagecontroller.setNotLoadingLoading();
    Get.back();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));

    Get.snackbar("Done!", str,
        colorText: colorController.getBackGroundColorTheme());
  }

  firstTab() {
    return RefreshIndicator(
      onRefresh: () {
        return getAllItems();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: showItemsPagecontroller.itemList.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder(
              child: showItemsPagecontroller.itemList[index],
              tween: Tween(end: .0, begin: 1.0),
              curve: Curves.ease,
              duration: Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Transform.translate(
                    child: child,
                    offset: Offset(.0, ((300 + (100 * index)) * value)));
              },
            );
          }),
    );
  }

  secondTab() {
    return RefreshIndicator(
      onRefresh: () {
        return getAllItems();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: showItemsPagecontroller.itemList.length,
          itemBuilder: (context, index) {
            if (showItemsPagecontroller.itemList[index].image ==
                "assets/tyres.png") {
              return TweenAnimationBuilder(
                child: showItemsPagecontroller.itemList[index],
                tween: Tween(end: .0, begin: 1.0),
                curve: Curves.ease,
                duration: Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.translate(
                      child: child,
                      offset: Offset(.0, ((300 + (100 * index)) * value)));
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }

  thirdTab() {
    return RefreshIndicator(
      onRefresh: () {
        return getAllItems();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: showItemsPagecontroller.itemList.length,
          itemBuilder: (context, index) {
            if (showItemsPagecontroller.itemList[index].image ==
                "assets/oil.png") {
              return TweenAnimationBuilder(
                child: showItemsPagecontroller.itemList[index],
                tween: Tween(end: .0, begin: 1.0),
                curve: Curves.ease,
                duration: Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.translate(
                      child: child,
                      offset: Offset(.0, ((300 + (100 * index)) * value)));
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }

  fourthTab() {
    return RefreshIndicator(
      onRefresh: () {
        return getAllItems();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: showItemsPagecontroller.itemList.length,
          itemBuilder: (context, index) {
            if (showItemsPagecontroller.itemList[index].image ==
                "assets/engine.png") {
              return TweenAnimationBuilder(
                child: showItemsPagecontroller.itemList[index],
                tween: Tween(end: .0, begin: 1.0),
                curve: Curves.ease,
                duration: Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.translate(
                      child: child,
                      offset: Offset(.0, ((300 + (100 * index)) * value)));
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }

  fifthTab() {
    return RefreshIndicator(
      onRefresh: () {
        return getAllItems();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: showItemsPagecontroller.itemList.length,
          itemBuilder: (context, index) {
            if (showItemsPagecontroller.itemList[index].image ==
                "assets/tool.png") {
              return TweenAnimationBuilder(
                child: showItemsPagecontroller.itemList[index],
                tween: Tween(end: .0, begin: 1.0),
                curve: Curves.ease,
                duration: Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.translate(
                      child: child,
                      offset: Offset(.0, ((300 + (100 * index)) * value)));
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorController.getBackGroundColorTheme(),
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: colorController.getTextColorTheme(),
        ),
        onPressed: () {
          Get.to(() => CreateItemPage(widget.bagID));
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          !widget.comingFromPage
              ? Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (showItemsPagecontroller.selectedItems.length > 0) {
                        Get.defaultDialog(
                            title: "Add these items?",
                            titleStyle: GoogleFonts.montserrat(
                                color: colorController.getTextColorTheme()),
                            backgroundColor:
                                colorController.getBackGroundColorTheme(),
                            content: Container(),
                            actions: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                  //DONE: Add items to bag
                                  addItems();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20, top: 5),
                      child: Badge(
                        shape: BadgeShape.circle,
                        toAnimate: true,
                        badgeColor: colorController.getBackGroundColorTheme(),
                        position: BadgePosition.topStart(),
                        badgeContent: Text(
                          showItemsPagecontroller.selectedItems.length
                              .toString(),
                          style: GoogleFonts.montserrat(
                              color: colorController.getTextColorTheme()),
                        ),
                        child: FaIcon(FontAwesomeIcons.suitcase,
                            color: colorController.getBackGroundColorTheme()),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorController.getBackGroundColorTheme(),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Your Items",
          style: GoogleFonts.montserrat(
              color: colorController.getBackGroundColorTheme(),
              fontSize: Get.width * 0.07,
              fontWeight: FontWeight.w500),
        ),
      ),
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
              : showItemsPagecontroller.itemList.length != 0
                  ? SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: TabBar(
                              isScrollable: true,
                              controller: _tabController,
                              tabs: tabList,
                              labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500),
                              unselectedLabelStyle: GoogleFonts.montserrat(),
                              labelColor:
                                  colorController.getBackGroundColorTheme(),
                              unselectedLabelColor:
                                  colorController.getBackGroundColorTheme(),
                              indicator: BoxDecoration(
                                  border: Border.all(
                                      color: colorController
                                          .getBackGroundColorTheme(),
                                      width: .5),
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  firstTab(),
                                  secondTab(),
                                  thirdTab(),
                                  fourthTab(),
                                  fifthTab(),
                                ]),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "You have no items available.",
                        style: GoogleFonts.montserrat(
                            color: colorController.getBackGroundColorTheme()),
                      ),
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
  Controller pageController;

  Item(
      {Key key,
      this.image,
      this.text,
      this.quantity,
      this.itemID,
      this.state,
      @required this.pageController});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Color selectedColor = colorController.getBackGroundColorTheme();
  bool click = false;
  int initQuantity = 0;

  @override
  void initState() {
    super.initState();
    initQuantity = widget.quantity;
  }

  deleteItem() async {
    widget.pageController.setIsLoading();
    var url = UrlApp.url + "/deleteItem.php?itemId=" + widget.itemID.toString();
    Response response = await http.get(url).then((value) {
      Future.delayed(Duration(milliseconds: 500), () {
        // 5 seconds over, navigate to Page2.
        widget.pageController.setNotLoadingLoading();
        Get.back();
        Get.to(() => ShowItemsPage(), transition: Transition.noTransition);
      });
    }).catchError((error) {
      widget.pageController.setNotLoadingLoading();
      Get.snackbar("Error", "No Internet",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  updateItem() async {
    //Aggiorno l'elemento
    widget.pageController.setNotLoadingLoading();
    var url = UrlApp.url +
        "/updateItemQuantity.php?itemId=" +
        widget.itemID +
        "&quantity=" +
        widget.quantity.toString();
    Response response = await http.get(url).then((value) {
      widget.pageController.setNotLoadingLoading();
      print("Done!");
      //Get.snackbar("Done!", "Item updated correctly",
      //colorText: colorController.getBackGroundColorTheme());
      setState(() {
        initQuantity = widget.quantity;
      });
    }).catchError((error) {
      widget.pageController.setNotLoadingLoading();
      Get.snackbar("Error", "No Internet.",
          colorText: colorController.getBackGroundColorTheme());
    });
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
              showItemsPagecontroller.selectedItems.add(widget);
              showItemsPagecontroller.incrementQuantity();
              showItemsPagecontroller.selectedItems.forEach((element) {
                print(element.itemID);
              });
            }
          } else {
            showItemsPagecontroller.selectedItems.remove(widget);
            showItemsPagecontroller.decrementQuantity();
            selectedColor = colorController.getBackGroundColorTheme();
            click = !click;
            print(showItemsPagecontroller.selectedItems);
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
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: Get.width,
          height: 100,
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.mainColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: Get.width / 4,
                  child: Image.asset(widget.image)),
              Container(
                width: Get.width / 4,
                child: Center(
                  child: Text(
                    widget.text,
                    style: GoogleFonts.montserrat(
                        color: colorController.getTextColorTheme()),
                  ),
                ),
              ),
              Expanded(
                //width: Get.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.minus,
                                color: colorController.getTextColorTheme(),
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
                            style: GoogleFonts.montserrat(
                                color: colorController.getTextColorTheme()),
                          ),
                          IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.plus,
                                color: colorController.getTextColorTheme(),
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
                    ),
                    (initQuantity != widget.quantity && !click)
                        ? GestureDetector(
                            onTap: () async {
                              //DONE: implement update item

                              updateItem();
                            },
                            child: Container(
                              //width: Get.width * 0.2,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
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
