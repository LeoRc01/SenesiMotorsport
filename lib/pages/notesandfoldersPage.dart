import 'dart:convert';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/main.dart';

import 'package:SenesiMotorsport/pages/enginePage.dart';
import 'package:SenesiMotorsport/pages/notepage.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:uuid/uuid.dart';
import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NoteAndFolders extends StatefulWidget {
  String insideOf;
  String title;

  NoteAndFolders(insideOf, title) {
    this.insideOf = insideOf;
    this.title = title;
  }

  @override
  _NoteAndFoldersState createState() => _NoteAndFoldersState();
}

class _NoteAndFoldersState extends State<NoteAndFolders>
    with SingleTickerProviderStateMixin {
  //List<dynamic> contentPage = [];

  Controller controller;

  Animation<double> _animation;
  AnimationController _animationController;

  bool isOpen = false;

  var uuid = Uuid();

  @override
  void initState() {
    controller = new Controller();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    folderNameController = new TextEditingController();
    engineNameController = new TextEditingController();
    getContentPage(widget.insideOf);
    super.initState();
  }

  getContentPage(insideOf) async {
    controller.setIsLoading();
    try {
      var url = UrlApp.url +
          "/getItemsFromFolder.php?insideOf=" +
          insideOf.toString() +
          "&email=" +
          UserEmail.userEmail;
      Response response = await http.get(url).then((value) {
        controller.itemList = jsonDecode(value.body);
        print(controller.itemList);
        controller.setNotLoadingLoading();
        //print(contentPage);
      }).catchError((onError) {
        print(onError);
        controller.setNotLoadingLoading();
        Get.snackbar("Error", "No Internet",
            colorText: colorController.getBackGroundColorTheme());
      });
    } catch (e) {
      controller.setNotLoadingLoading();
      Get.snackbar("Error", "No Internet",
          colorText: colorController.getBackGroundColorTheme());
    }
  }

  final folderKeyForm = GlobalKey<FormState>();
  TextEditingController folderNameController;
  TextEditingController engineNameController;

  createFolderDialog() {
    Get.defaultDialog(
      title: "Create a folder",
      titleStyle: GoogleFonts.montserrat(color: AppColors.mainColor),
      backgroundColor: colorController.getBackGroundColorTheme(),
      barrierDismissible: true,
      middleText: "",
      textConfirm: "Create",
      buttonColor: AppColors.mainColor,
      cancelTextColor: AppColors.mainColor,
      onConfirm: () {
        print("sus");
        if (folderKeyForm.currentState.validate()) {
          createFolder(folderNameController.text.trim());
        }
      },
      confirmTextColor: Colors.white,
      textCancel: "Back",
      content: Form(
        key: folderKeyForm,
        child: TextFormField(
          controller: folderNameController,
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter a name";
            } else if (value.length > 20) {
              return "Name is too long.";
            }
          },
          maxLength: 20,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.montserrat(
              color: colorController.getTextColorTheme()),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            counterStyle: GoogleFonts.montserrat(color: Colors.white),
            //border: InputBorder.none,
            hintText: "Folder name",
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  createFolder(title) async {
    String createdUUID = uuid.v1();

    var url = UrlApp.url +
        "/createFolder.php?title=" +
        title +
        "&itemId=" +
        createdUUID +
        "&email=" +
        UserEmail.userEmail;
    Response response = await http.get(url).then((value) {
      insertCreatedItemIntoFolder(widget.insideOf, createdUUID).then((value) {
        Get.back();
        Get.snackbar("Done!", "Folder created!",
            colorText: colorController.getBackGroundColorTheme());
        folderNameController.text = "";
        getContentPage(widget.insideOf);
      });
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  Future createEngine(uuid) async {
    controller.setIsLoading();

    var url = UrlApp.url +
        "/createEngine.php?name=" +
        engineNameController.text +
        "&id=" +
        uuid +
        "&email=" +
        UserEmail.userEmail;
    Response res = await http.get(url).then((value) {
      insertCreatedItemIntoFolder(widget.insideOf, uuid).then((value) {
        controller.setNotLoadingLoading();
        getContentPage(widget.insideOf);
      }).catchError((onError) {
        print("Error: " + onError.toString());
      });
    }).catchError((onError) {
      controller.setNotLoadingLoading();
      Get.snackbar("Error.", onError.toString(),
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  Future insertCreatedItemIntoFolder(insideOf, itemId) async {
    var url = UrlApp.url +
        "/insertItemIntoFolder.php?insideOf=" +
        widget.insideOf +
        "&itemId=" +
        itemId +
        "&email=" +
        UserEmail.userEmail;
    Response response = await http.get(url).then((value) {});
  }

  final _key = GlobalKey<FormState>();

  showCreateEngineDialog() {
    Get.defaultDialog(
        middleText: null,
        title: "Create engine",
        content: Form(
          key: _key,
          child: Column(
            children: [
              FormFieldInputTile(
                maxLength: 20,
                hintText: "Engine name",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please insert a name";
                  }
                },
                controller: engineNameController,
              ),
              SizedBox(
                height: 20,
              ),
              AddDataButton(
                onTap: () {
                  if (_key.currentState.validate()) {
                    String engineID = uuid.v1();
                    Get.back();
                    createEngine(engineID).then((value) {
                      String name = engineNameController.text;
                      Get.to(() => EnginePage(
                          engineId: engineID,
                          insideOf: widget.insideOf,
                          name: name));
                      engineNameController.text = "";
                    });
                  }
                },
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
/*
      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Create Folder",
            iconColor: colorController.getBackGroundColorTheme(),
            bubbleColor: AppColors.mainColor,
            icon: Icons.folder,
            titleStyle: TextStyle(
                fontSize: 16, color: colorController.getBackGroundColorTheme()),
            onPress: () {
              createFolderDialog();
              //_animationController.reverse();
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Create Note",
            iconColor: colorController.getBackGroundColorTheme(),
            bubbleColor: AppColors.mainColor,
            icon: Icons.note_add,
            titleStyle: TextStyle(
                fontSize: 16, color: colorController.getBackGroundColorTheme()),
            onPress: () {
              Get.to(() =>
                  NotePage.newNote("", "", true, widget.insideOf, controller));
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Create Engine",
            iconColor: colorController.getBackGroundColorTheme(),
            bubbleColor: AppColors.mainColor,
            icon: Icons.add,
            titleStyle: TextStyle(
                fontSize: 16, color: colorController.getBackGroundColorTheme()),
            onPress: () {
              showCreateEngineDialog();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () {
          if (!isOpen) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          isOpen = !isOpen;
        },
        // Floating Action button Icon color
        iconColor: AppColors.mainColor,

        // Flaoting Action button Icon
        icon: AnimatedIcons.menu_arrow,
      ),
      */
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            return getContentPage(widget.insideOf);
          },
          child: Obx(
            () => controller.getLoading()
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      Column(
                        children: [
                          /**APP BAR */
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.chevronLeft,
                                        color: colorController
                                            .getBackGroundColorTheme(),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      }),
                                ),
                                Text(
                                  widget.title,
                                  style: GoogleFonts.montserrat(
                                      color: colorController
                                          .getBackGroundColorTheme(),
                                      fontSize: Get.width * 0.07,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          /**BODYPAGE */
                          controller.itemList.length == 0
                              ? Expanded(
                                  child: Center(
                                    child: Text("No items available.",
                                        style: GoogleFonts.montserrat(
                                            color: colorController
                                                .getBackGroundColorTheme(),
                                            fontSize: Get.width * 0.05)),
                                  ),
                                )
                              : Expanded(
                                  child: StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      itemCount: controller.itemList.length,
                                      itemBuilder: (context, index) {
                                        return TweenAnimationBuilder(
                                          tween: Tween(end: .0, begin: 1.0),
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: index % 2 == 0
                                                  ? Offset(
                                                      ((-300 + (100 * index)) *
                                                          value),
                                                      .0)
                                                  : Offset(
                                                      ((300 + (100 * index)) *
                                                          value),
                                                      .0),
                                              child: child,
                                            );
                                          },
                                          child: ItemTile(
                                              controller.itemList[index]
                                                  ["itemId"],
                                              controller.itemList[index]
                                                  ["title"],
                                              int.parse(controller
                                                  .itemList[index]["isFolder"]),
                                              controller.itemList[index]
                                                  ["content"],
                                              widget.insideOf,
                                              controller),
                                        );
                                      },
                                      staggeredTileBuilder: (index) =>
                                          StaggeredTile.fit(1)),
                                ),
                        ],
                      ),
                      /**BOTTOM BUTTON BAR */
                      SafeArea(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CupertinoCard(
                          color: colorController.getBackGroundColorTheme(),
                          radius: BorderRadius.circular(50),
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 60,
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    createFolderDialog();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.create_new_folder,
                                        color:
                                            colorController.getTextColorTheme(),
                                      ),
                                      Text("Create Folder",
                                          style: GoogleFonts.montserrat(
                                            color: colorController
                                                .getTextColorTheme(),
                                            fontSize: Get.width * 0.025,
                                          )),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => NotePage.newNote("", "", true,
                                        widget.insideOf, controller));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.note_add,
                                        color:
                                            colorController.getTextColorTheme(),
                                      ),
                                      Text("Create Note",
                                          style: GoogleFonts.montserrat(
                                            color: colorController
                                                .getTextColorTheme(),
                                            fontSize: Get.width * 0.025,
                                          )),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showCreateEngineDialog();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color:
                                            colorController.getTextColorTheme(),
                                      ),
                                      Text("Create Engine",
                                          style: GoogleFonts.montserrat(
                                            color: colorController
                                                .getTextColorTheme(),
                                            fontSize: Get.width * 0.025,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  String itemId;
  String title;
  String insideOf;
  int isFolder;
  String noteContent;
  Controller controller;

  String setTitle = "";

  TextEditingController itemNameController;

  ItemTile(itemId, title, isFolder, noteContent, insideOf, controller) {
    itemNameController = new TextEditingController();
    itemNameController.text = title;
    this.noteContent = noteContent;
    this.itemId = itemId;
    this.title = title;
    this.isFolder = isFolder;
    this.insideOf = insideOf;
    this.controller = controller;
  }
  updateItemTitle(uuid) async {
    var url = UrlApp.url +
        "/updateItemTitle.php?title=" +
        itemNameController.text +
        "&itemId=" +
        uuid +
        "&email=" +
        UserEmail.userEmail;
    //∂print(uuid);
    Response response = await http.get(url).then((value) {
      print(value.body);
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  deleteItem(uuid) async {
    var url = UrlApp.url +
        "/deleteItemFolderNotes.php?itemId=" +
        uuid +
        "&isFolder=" +
        isFolder.toString() +
        "&email=" +
        UserEmail.userEmail;
    Response response = await http.get(url).then((value) {
      print(value.body);
      controller.itemList
          .removeWhere((element) => element["itemId"] == this.itemId);
      Get.forceAppUpdate();
      //Get.back();
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  deleteEngine(uuid) async {
    var url = UrlApp.url + "/deleteEngine.php?itemId=" + uuid;
    Response response = await http.get(url).then((value) {
      print(value.body);
      controller.itemList
          .removeWhere((element) => element["itemId"] == this.itemId);
      Get.forceAppUpdate();
      //Get.back();
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isFolder == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteAndFolders(itemId, title)));
            } else if (isFolder == 2) {
              Get.to(() => EnginePage(
                  engineId: itemId,
                  insideOf: insideOf,
                  name: itemNameController.text));
            } else {
              Get.to(() => NotePage(title, itemId, noteContent, insideOf));
            }
          },
          onLongPress: () {
            Get.defaultDialog(
              content: Text("Are you sure you want to delete this item?",
                  style: GoogleFonts.montserrat(
                      color: colorController.getTextColorTheme())),
              backgroundColor: colorController.getBackGroundColorTheme(),
              title: "Delete this item?",
              textConfirm: "Yes",
              confirmTextColor: Colors.white,
              cancelTextColor: AppColors.mainColor,
              buttonColor: AppColors.mainColor,
              textCancel: "No",
              titleStyle: GoogleFonts.montserrat(
                  color: colorController.getTextColorTheme()),
              onConfirm: () {
                if (isFolder == 2) {
                  print("Engine deleting");
                  deleteEngine(itemId);
                }

                deleteItem(itemId);

                Get.back();
              },
            );
          },
          child: Container(
            height: 180,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Image(
              image: isFolder == 1
                  ? AssetImage("assets/folder.png")
                  : isFolder == 2
                      ? AssetImage("assets/engine.png")
                      : AssetImage("assets/note.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorController.getBackGroundColorTheme(),
          ),
          child: TextField(
            onEditingComplete: () {
              if (itemNameController.text.length <= 20) {
                title = itemNameController.text;
                updateItemTitle(itemId);
                Get.back();
                FocusScope.of(context).unfocus();
                print(itemNameController.text);
              } else {
                Get.snackbar("Error!",
                    "Name too long.\nIt must not be over 20 characters!",
                    colorText: colorController.getBackGroundColorTheme());
              }
            },
            style: GoogleFonts.montserrat(
                color: colorController.getTextColorTheme()),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            controller: itemNameController,
          ),
        ),
      ],
    );
  }
}
