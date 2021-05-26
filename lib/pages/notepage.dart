import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class NotePage extends StatefulWidget {
  String title;
  String itemId;
  String noteContent;
  bool isNew;

  NotePage(title, itemId, noteContent) {
    this.title = title;
    this.itemId = itemId;
    this.noteContent = noteContent;
  }

  NotePage.newNote(this.title, this.noteContent, this.isNew);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController titleController;
  TextEditingController contentController;

  Uuid uuid = new Uuid();

  Controller noteController;
  String description = 'My great package';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                //TODO: CREATE NOTE
                                //RICORDARSI DI CREARE ID USANDO UUID.v1
                              } else {
                                //TODO: UPDATE NOTE
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
