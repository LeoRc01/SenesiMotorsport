import 'dart:convert';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/logs/loginPage.dart';
import 'package:SenesiMotorsport/main.dart';
import 'package:SenesiMotorsport/models/animated_arrow_down.dart';
import 'package:SenesiMotorsport/models/sidepanel.dart';

import 'package:SenesiMotorsport/pages/enginePage.dart';
import 'package:SenesiMotorsport/pages/notepage.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Controller oldPageController;
  String comingFromPage_insideOf;

  NoteAndFolders(insideOf, title, this.comingFromPage_insideOf,
      {this.oldPageController}) {
    if (oldPageController != null) print(oldPageController.itemList);
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

  SharedPreferences sharedPreferences;

  Future initializeSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    controller = new Controller();
    initializeSharedPrefs().then((value) {
      UserEmail.userEmail = sharedPreferences.getString("email");

      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 260),
      );

      final curvedAnimation = CurvedAnimation(
          curve: Curves.easeInOut, parent: _animationController);

      _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
      folderNameController = new TextEditingController();
      engineNameController = new TextEditingController();
      getContentPage(widget.insideOf);
    });
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
    controller.setIsLoading();
    Get.back();
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
    controller.setIsLoading();
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

    Response response = await http.get(url).then((value) {
      print(value.body);
    });
  }

  Future insertItemIntoFolder(insideOf, itemId) async {
    var url = UrlApp.url +
        "/insertItemIntoFolder.php?insideOf=" +
        insideOf +
        "&itemId=" +
        itemId +
        "&email=" +
        UserEmail.userEmail;

    Response response = await http.get(url).then((value) {
      print(value.body);
    });
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

  Future removeItemFromCurrentFolder(String insideOf, String noteId) async {
    controller.itemList.removeWhere((element) => element["itemId"] == noteId);
    Get.forceAppUpdate();
    var url = UrlApp.url +
        "/removeItemFromFolder.php?insideOf=" +
        insideOf +
        "&itemId=" +
        noteId +
        "&email=" +
        UserEmail.userEmail;

    Response response = await http.get(url).then((value) {
      print(value.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    alignment: Alignment.center,
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
                                        widget.insideOf == "mainpage"
                                            ? FontAwesomeIcons.signOutAlt
                                            : FontAwesomeIcons.chevronLeft,
                                        color: colorController
                                            .getBackGroundColorTheme(),
                                      ),
                                      onPressed: () {
                                        if (widget.insideOf == "mainpage") {
                                          woocommerce.logUserOut();
                                          Get.off(() => LoginPage());
                                        } else {
                                          Get.back();
                                        }
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
                                Spacer(),
                                widget.insideOf != "mainpage"
                                    ? DragTarget(
                                        onAccept: (data) {
                                          String insideOf =
                                              widget.comingFromPage_insideOf;
                                          String noteId = data.itemId;

                                          insertItemIntoFolder(insideOf, noteId)
                                              .then((value) {
                                            Map<String, dynamic> droppedItem = {
                                              "title": data.title,
                                              "content": data.noteContent,
                                              "isFolder":
                                                  data.isFolder.toString(),
                                              "itemId": data.itemId,
                                            };
                                            widget.oldPageController.itemList
                                                .add(droppedItem);

                                            removeItemFromCurrentFolder(
                                                widget.insideOf, noteId);
                                            Get.back();
                                            return true;
                                          });

                                          return false;
                                        },
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          return Obx(
                                            () => Opacity(
                                              opacity: controller.isMoving.value
                                                  ? 1
                                                  : 0,
                                              child: FaIcon(
                                                  FontAwesomeIcons.backward,
                                                  color: Colors.red),
                                            ),
                                          );
                                        },
                                      )
                                    : Container()
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
                                      crossAxisCount: 3,
                                      shrinkWrap: true,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 10,
                                      //physics: NeverScrollableScrollPhysics(),
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
                                              offset: Offset(
                                                  .0,
                                                  ((300 + (100 * index)) *
                                                      value)),
                                              child: child,
                                            );
                                          },
                                          child: int.parse(
                                                      controller.itemList[index]
                                                          ["isFolder"]) ==
                                                  1
                                              ? DragTarget(
                                                  onAccept: (data) {
                                                    String insideOf = controller
                                                            .itemList[index]
                                                        ["itemId"];
                                                    String noteId = data.itemId;

                                                    insertItemIntoFolder(
                                                            insideOf, noteId)
                                                        .then((value) {
                                                      removeItemFromCurrentFolder(
                                                          widget.insideOf,
                                                          noteId);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoteAndFolders(
                                                                  insideOf,
                                                                  controller.itemList[
                                                                          index]
                                                                      ["title"],
                                                                  widget
                                                                      .insideOf,
                                                                  oldPageController:
                                                                      controller),
                                                        ),
                                                      );
                                                      return true;
                                                    });

                                                    return false;
                                                  },
                                                  builder: (context,
                                                      candidateData,
                                                      rejectedData) {
                                                    return ItemTile(
                                                        controller
                                                                .itemList[index]
                                                            ["itemId"],
                                                        controller
                                                                .itemList[index]
                                                            ["title"],
                                                        int.parse(controller
                                                                .itemList[index]
                                                            ["isFolder"]),
                                                        controller
                                                                .itemList[index]
                                                            ["content"],
                                                        widget.insideOf,
                                                        controller,
                                                        widget.title,
                                                        opacity: candidateData
                                                            .isNotEmpty);
                                                  },
                                                )
                                              : ItemTile(
                                                  controller.itemList[index]
                                                      ["itemId"],
                                                  controller.itemList[index]
                                                      ["title"],
                                                  int.parse(
                                                      controller.itemList[index]
                                                          ["isFolder"]),
                                                  controller.itemList[index]
                                                      ["content"],
                                                  widget.insideOf,
                                                  controller,
                                                  widget.title,
                                                ),
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
  String pageTitle;
  bool opacity;

  Controller thisItemController;

  String setTitle = "";

  TextEditingController itemNameController;

  ItemTile(
    itemId,
    title,
    isFolder,
    noteContent,
    insideOf,
    controller,
    this.pageTitle, {
    this.opacity = false,
  }) {
    thisItemController = new Controller();
    itemNameController = TextEditingController();
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
    Response response =
        await http.get(url).then((value) {}).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  deleteItem(uuid) async {
    controller.setIsLoading();
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
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
    controller.setNotLoadingLoading();
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

  updateEngineName(uuid, String newName) async {
    var url = UrlApp.url +
        "/updateEngineName.php?engineId=" +
        uuid +
        "&newName=" +
        newName;
    Response response = await http.get(url).then((value) {
      print("BODY: " + value.body);

      //Get.back();
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.",
          colorText: colorController.getBackGroundColorTheme());
    });
  }

  Widget _buildTile(context) {
    return Opacity(
      opacity: thisItemController.isMoving.value ? 0 : 1,
      child: Column(
        children: [
          Container(
            height: 120,
            padding: EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: opacity ? 0.5 : 1,
                  child: Image(
                    image: isFolder == 1
                        ? AssetImage(
                            "assets/folder.png",
                          )
                        : isFolder == 2
                            ? AssetImage("assets/engine.png")
                            : AssetImage("assets/note.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                opacity ? AnimatedArrowDown() : Container(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorController.getBackGroundColorTheme(),
            ),
            child: TextFormField(
              onEditingComplete: () {
                if (itemNameController.text.length <= 20) {
                  updateItemTitle(itemId);

                  if (isFolder == 2) {
                    updateEngineName(itemId, itemNameController.text);
                    print("executed");
                  }

                  this.title = itemNameController.text;
                  controller.itemList
                      .where((element) => element["itemId"] == itemId)
                      .forEach((element) {
                    element["title"] = itemNameController.text;
                  });
                  Get.forceAppUpdate();
                  //Get.back();
                  FocusScope.of(context).unfocus();
                } else {
                  Get.snackbar("Error!",
                      "Name too long.\nIt must not be over 20 characters!",
                      colorText: colorController.getBackGroundColorTheme());
                }
              },
              style: GoogleFonts.montserrat(
                  color: colorController.getTextColorTheme()),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              controller: itemNameController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (isFolder == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteAndFolders(
                        itemId, title, insideOf,
                        oldPageController: controller)));
          } else if (isFolder == 2) {
            Get.to(() => EnginePage(
                engineId: itemId,
                insideOf: insideOf,
                name: itemNameController.text));
          } else {
            Get.to(() =>
                NotePage(title, itemId, noteContent, insideOf, controller));
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
        child: (isFolder == 1)
            ? _buildTile(context)
            : Draggable(
                onDragStarted: () {
                  thisItemController.isMoving(true);
                  controller.isMoving(true);
                },
                onDragEnd: (details) {
                  thisItemController.isMoving(false);
                  controller.isMoving(false);
                },
                data: this,
                feedbackOffset: Offset.zero,
                feedback: Container(
                  height: 120,
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Image(
                    image: isFolder == 1
                        ? AssetImage("assets/folder.png")
                        : isFolder == 2
                            ? AssetImage("assets/engine.png")
                            : AssetImage("assets/note.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: _buildTile(context)),
      ),
    );
  }
}
