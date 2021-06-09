import 'dart:convert';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/pages/notepage.dart';
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
        Get.snackbar("Error", "No Internet");
      });
    } catch (e) {
      controller.setNotLoadingLoading();
      Get.snackbar("Error", "No Internet");
    }
  }

  final folderKeyForm = GlobalKey<FormState>();
  TextEditingController folderNameController;

  createFolderDialog() {
    Get.defaultDialog(
      title: "Create a folder",
      titleStyle: GoogleFonts.montserrat(color: AppColors.mainColor),
      backgroundColor: AppColors.darkColor,
      barrierDismissible: true,
      middleText: "",
      textConfirm: "Create",
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
          style: GoogleFonts.montserrat(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
        Get.snackbar("Done!", "Folder created!");
        getContentPage(widget.insideOf);
      });
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Create Folder",
            iconColor: Colors.white,
            bubbleColor: AppColors.darkColor,
            icon: Icons.folder,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              createFolderDialog();
              //_animationController.reverse();
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Create Note",
            iconColor: Colors.white,
            bubbleColor: AppColors.darkColor,
            icon: Icons.note_add,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              Get.to(() =>
                  NotePage.newNote("", "", true, widget.insideOf, controller));
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
        iconColor: AppColors.darkColor,

        // Flaoting Action button Icon
        icon: AnimatedIcons.menu_arrow,
      ),
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
                : Column(
                    children: [
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
                                    color: AppColors.darkColor,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  }),
                            ),
                            Text(
                              widget.title,
                              style: GoogleFonts.montserrat(
                                  color: AppColors.darkColor,
                                  fontSize: Get.width * 0.07,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      controller.itemList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text("No items available.",
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.darkColor,
                                        fontSize: Get.width * 0.05)),
                              ),
                            )
                          : StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: controller.itemList.length,
                              itemBuilder: (context, index) {
                                return ItemTile(
                                    controller.itemList[index]["itemId"],
                                    controller.itemList[index]["title"],
                                    int.parse(
                                        controller.itemList[index]["isFolder"]),
                                    controller.itemList[index]["content"],
                                    widget.insideOf,
                                    controller);
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1)),
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
      Get.snackbar("Error", "No Internet connection.");
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
      Get.snackbar("Error", "No Internet connection.");
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
            } else {
              Get.to(() => NotePage(title, itemId, noteContent, insideOf));
            }
          },
          onLongPress: () {
            Get.defaultDialog(
              content: Text("Are you sure you want to delete this item?",
                  style: GoogleFonts.montserrat(color: Colors.white)),
              backgroundColor: AppColors.darkColor,
              title: "Delete this item?",
              textConfirm: "Yes",
              confirmTextColor: Colors.white,
              textCancel: "No",
              titleStyle: GoogleFonts.montserrat(color: Colors.white),
              onConfirm: () {
                deleteItem(itemId);
                Get.back();
              },
            );
          },
          child: Container(
            height: 180,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Image(
              image: isFolder == 1
                  ? AssetImage("assets/folder.png")
                  : AssetImage("assets/note.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.darkColor,
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
                    "Name too long.\nIt must not be over 20 characters!");
              }
            },
            style: GoogleFonts.montserrat(color: Colors.white),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
