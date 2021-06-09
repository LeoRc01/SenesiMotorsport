import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'notesandfoldersPage.dart';

class NotePage extends StatefulWidget {
  String title;
  String itemId;
  String noteContent;
  String insideOf;
  bool isNew;
  Controller otherPageController;

  NotePage(title, itemId, noteContent, insideOf) {
    this.title = title;
    this.itemId = itemId;
    this.noteContent = noteContent;
    this.insideOf = insideOf;
    this.isNew = false;
    //this.otherPageController = controller;
  }

  NotePage.newNote(this.title, this.noteContent, this.isNew, this.insideOf,
      this.otherPageController);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController titleController;
  TextEditingController contentController;

  Uuid uuid = new Uuid();

  Controller noteController;

  @override
  void initState() {
    print(widget.noteContent);
    titleController = new TextEditingController();
    titleController.text = widget.title;

    contentController = new TextEditingController();
    contentController.text = widget.noteContent;

    noteController = new Controller();
    super.initState();
  }

  createNote(uuid) async {
    var url = UrlApp.url +
        "/createNote.php?title=" +
        titleController.text +
        "&content=" +
        contentController.text +
        "&itemId=" +
        uuid +
        "&email=" +
        UserEmail.userEmail;
    Response response = await http.get(url).then((value) {
      //Get.snackbar("Done!", "Note created successfully!");
      insertNoteIntoFolder(widget.insideOf, uuid);
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.");
    });
  }

  insertNoteIntoFolder(insideOf, uuid) async {
    var url = UrlApp.url +
        "/insertItemIntoFolder.php?itemId=" +
        uuid +
        "&insideOf=" +
        insideOf +
        "&email=" +
        UserEmail.userEmail;
    Response res = await http.get(url).then((value) {
      Map<String, dynamic> data = {
        "title": titleController.text,
        "content": contentController.text,
        "isFolder": 0.toString(),
        "itemId": uuid,
      };
      widget.otherPageController.itemList.add(data);
      Get.back();
      //Get.forceAppUpdate();
      //Navigator.pop(context);
      //Navigator.pop(context);
    });
  }

  updateNote(uuid) async {
    var url = UrlApp.url +
        "/updateNote.php?title=" +
        titleController.text +
        "&content=" +
        contentController.text +
        "&itemId=" +
        uuid +
        "&email=" +
        UserEmail.userEmail;
    Response response = await http.get(url).then((value) {
      print(widget.title);
      print(widget.itemId);
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((onError) {
      Get.back();
      Get.snackbar("Error", "No Internet connection.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  Spacer(),
                  Obx(
                    () => noteController.getModified()
                        ? IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.check,
                              color: AppColors.darkColor,
                            ),
                            onPressed: () {
                              if (contentController.text == "" &&
                                  titleController.text == "" &&
                                  widget.isNew) {
                                Get.back();
                              } else if (widget.isNew) {
                                //DONE: CREATE NOTE
                                //RICORDARSI DI CREARE ID USANDO UUID.v1
                                String suuid = uuid.v1();
                                createNote(suuid);
                              } else {
                                //DONE: UPDATE NOTE
                                updateNote(widget.itemId);
                              }
                            })
                        : Container(),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) {
                  noteController.setModified(true);
                },
                controller: titleController,
                decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: GoogleFonts.montserrat(
                        fontSize: Get.width * 0.07,
                        fontWeight: FontWeight.w500),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: Get.width * 0.07,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) {
                  noteController.setModified(true);
                },
                keyboardType: TextInputType.multiline,
                maxLines: 27,
                controller: contentController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
