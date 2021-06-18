import 'dart:convert';
import 'package:SenesiMotorsport/main.dart';
import 'package:SenesiMotorsport/pages/searchItem.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:SenesiMotorsport/pages/yourorders.dart';
import 'package:flutter/services.dart';
import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/logs/loginPage.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  Controller countNameLetters;
  Controller countDescLetters;
  Controller mainPageController = new Controller();

  int maxNameLetters = 15;
  int maxDescLetters = 20;

  SharedPreferences sharedPreferences;

  Future initializeSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializeSharedPrefs().then((value) {
      countNameLetters = new Controller();
      countDescLetters = new Controller();

      UserEmail.userEmail = sharedPreferences.getString("email");
      getAllBags();
/*
      woocommerce
          .get("https://senesimotorsport.com/my-account/orders/")
          .then((value) {
        print(value);
      });*/
    });

    //woocommerce.getOrders();
    super.initState();
  }

  getAllBags() async {
    mainPageController.itemList
        .removeRange(0, mainPageController.itemList.length);
    mainPageController.setIsLoading();
    var url = UrlApp.url + "/showAllBags.php?email=" + UserEmail.userEmail;
    Response res = await http.get(url).then((value) {
      mainPageController.itemList = jsonDecode(value.body);
      print(mainPageController.itemList);
      mainPageController.setNotLoadingLoading();
    }).catchError((error) {
      Get.snackbar("Error", "No Internet");
      mainPageController.setNotLoadingLoading();
    });
  }

  final createBagKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(
              backgroundColor: colorController.getBackGroundColorTheme(),
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
                          color: colorController.getTextColorTheme(),
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
                            hintStyle: GoogleFonts.montserrat(
                                color:
                                    colorController.getBackGroundColorTheme()),
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
                          color: colorController.getTextColorTheme(),
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
                            hintStyle: GoogleFonts.montserrat(
                                color:
                                    colorController.getBackGroundColorTheme()),
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
                                descController.text.trim() +
                                "&email=" +
                                UserEmail.userEmail;
                            Response response =
                                await http.get(url).then((value) {
                              countDescLetters.setQuantity(0);
                              countNameLetters.setQuantity(0);
                              Get.snackbar(
                                  "Done!", "Bag created successfully!");
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
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
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: colorController.getTextColorTheme(),
          ),
          backgroundColor: colorController.getBackGroundColorTheme(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.signOutAlt,
                                      color: colorController
                                          .getBackGroundColorTheme(),
                                    ),
                                    onPressed: () {
                                      woocommerce.logUserOut();
                                      Get.off(() => LoginPage());
                                    }),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: FaIcon(
                                          colorController.isDarkTheme.value
                                              ? FontAwesomeIcons.sun
                                              : FontAwesomeIcons.moon,
                                          color: colorController
                                              .getBackGroundColorTheme(),
                                        ),
                                        onPressed: () {
                                          print(colorController
                                              .isDarkTheme.value);
                                          colorController.isDarkTheme.value
                                              ? colorController
                                                  .changeToLightTheme()
                                              : colorController
                                                  .changeToDarkTheme();
                                        }),
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.search,
                                          color: colorController
                                              .getBackGroundColorTheme(),
                                        ),
                                        onPressed: () {
                                          Get.to(() => SearchItemPage());
                                        }),
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.listAlt,
                                          color: colorController
                                              .getBackGroundColorTheme(),
                                        ),
                                        onPressed: () {
                                          Get.to(() =>
                                              ShowItemsPage.comingFromPage(
                                                  true));
                                        }),
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.user,
                                          color: colorController
                                              .getBackGroundColorTheme(),
                                        ),
                                        onPressed: () {
                                          Get.to(() => YourOrders());
                                        }),
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.stickyNote,
                                          color: colorController
                                              .getBackGroundColorTheme(),
                                        ),
                                        onPressed: () {
                                          Get.to(() => NoteAndFolders(
                                              "mainpage", "Your folders"));
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        mainPageController.itemList.length == 0
                            ? Expanded(
                                child: Center(
                                  child: Text("No items available.",
                                      style: GoogleFonts.montserrat(
                                        color:
                                            colorController.getTextColorTheme(),
                                        fontSize: Get.width * 0.05,
                                      )),
                                ),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: StaggeredGridView.countBuilder(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      itemCount:
                                          mainPageController.itemList.length,
                                      itemBuilder: (context, index) {
                                        return new BagTile(
                                          image: "assets/bag.png",
                                          title: mainPageController
                                              .itemList[index]['bagName'],
                                          desc: mainPageController
                                              .itemList[index]['description'],
                                          bagID: mainPageController
                                              .itemList[index]['bagID'],
                                          mainPageController:
                                              mainPageController,
                                        );
                                      },
                                      staggeredTileBuilder: (index) =>
                                          StaggeredTile.fit(1)),
                                ),
                              ),
                      ],
                    ),
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
      style: GoogleFonts.montserrat(
        color: colorController.getTextColorTheme(),
      ),
    );
  }
}

class BagTile extends StatefulWidget {
  final title; //Title must be MAX: 10 WORDS
  final desc;
  final image;
  final bagID;
  Controller mainPageController;

  BagTile(
      {Key key,
      this.title,
      this.desc,
      this.image,
      this.bagID,
      this.mainPageController})
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
    var url = UrlApp.url +
        "/getAllItemsFromBag.php?bagId=" +
        bagID.toString() +
        "&email=" +
        UserEmail.userEmail;
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
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  deleteBag(int bagID) async {
    var url = UrlApp.url + "/deleteBag.php?bagId=" + bagID.toString();
    Response response = await http.get(url).then((value) {
      widget.mainPageController.itemList
          .removeWhere((element) => element["bagID"] == widget.bagID);
      print(widget.mainPageController.itemList);
      Get.forceAppUpdate();
      //Navigator.pushReplacement(
      //context, MaterialPageRoute(builder: (context) => MainPage()));

      Get.snackbar("Done!", "Bag deleted correctly!");
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    //DONE: Implement "Delete Bag"
    return GestureDetector(
      onTap: () => list.length == 0
          ? Get.to(
              () => ShowItemsPage(
                    bagID: widget.bagID,
                  ),
              transition: Transition.zoom)
          : showCupertinoModalBottomSheet(
              expand: false,
              context: context,
              //duration: Duration(milliseconds: 800),
              builder: (context) {
                return Material(
                    child: CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    leading: Container(),
                    backgroundColor: colorController.getBackGroundColorTheme(),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  backgroundColor: colorController.getBackGroundColorTheme(),
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
              style: GoogleFonts.montserrat(
                color: colorController.getTextColorTheme(),
              )),
          backgroundColor: colorController.getBackGroundColorTheme(),
          title: "Delete this bag?",
          textConfirm: "Yes",
          confirmTextColor: colorController.getBackGroundColorTheme(),
          textCancel: "No",
          titleStyle: GoogleFonts.montserrat(
            color: colorController.getTextColorTheme(),
          ),
          onConfirm: () {
            deleteBag(int.parse(widget.bagID));
            Get.back();
          },
        );
      },
      child: CupertinoCard(
        color: colorController.getBackGroundColorTheme(),
        radius: BorderRadius.all(
          new Radius.circular(65.0),
        ),
        //height: 250,
        //width: 100,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkColor,
        ),*/
        child: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.image.toString(),
                fit: BoxFit.contain,
              ),
              Text(
                widget.title.toString(),
                style: GoogleFonts.montserrat(
                    color: colorController.getTextColorTheme(),
                    fontWeight: FontWeight.w500,
                    fontSize: Get.width * 0.04),
              ),
              Text(
                widget.desc.toString().length > 25
                    ? widget.desc.toString().substring(0, 23) + "..."
                    : widget.desc.toString(),
                style: GoogleFonts.montserrat(
                    color: colorController.getTextColorTheme(),
                    fontWeight: FontWeight.w300,
                    fontSize: Get.width * 0.04),
              )
            ],
          ),
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
        const _url = 'https://senesimotorsport.com/';

        await canLaunch(_url)
            ? await launch(_url)
            : throw 'Could not launch $_url';
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: Get.width,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorController.getTextColorTheme(),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: Get.width / 4,
                child: Image.asset(image)),
            Container(
              width: Get.width / 4,
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.montserrat(
                    color: colorController.getTextColorTheme(),
                  ),
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
                            color: colorController.getTextColorTheme(),
                            size: Get.width * 0.03,
                          ),
                          onPressed: () {
                            controller.decrementQuantity();
                            if (quantity > 0) quantity--;

                            if (controller.getQuantity() == 0) {
                              Get.defaultDialog(
                                  backgroundColor:
                                      colorController.getBackGroundColorTheme(),
                                  titleStyle: GoogleFonts.montserrat(
                                    color: colorController.getTextColorTheme(),
                                  ),
                                  title: "Do you want to buy new products?",
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
                                            'https://senesimotorsport.com/';

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
                          style: GoogleFonts.montserrat(
                            color: colorController.getTextColorTheme(),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: colorController.getTextColorTheme(),
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
                            child: Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
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
