import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/pages/enginePage.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class GridItemTile extends StatelessWidget {
  Map<String, dynamic> itemData;
  TextStyle itemTextStyle;
  bool isBreakIn = false;
  bool isRace = false;
  bool isMantainence = false;
  bool isNotes = false;
  Controller pageController;

  GridItemTile.isBreakIn(this.itemData, this.itemTextStyle,
      {this.isBreakIn = true, @required this.pageController});

  GridItemTile(this.itemData, this.itemTextStyle);

  GridItemTile.isNotes(this.itemData, this.itemTextStyle,
      {this.isNotes = true, @required this.pageController});

  GridItemTile.isRace(this.itemData, this.itemTextStyle,
      {this.isRace = true, @required this.pageController});
  GridItemTile.isMantainence(this.itemData, this.itemTextStyle,
      {this.isMantainence = true, @required this.pageController});

  removeItemFromBreakInList(String dataId) async {
    var url = UrlApp.url + "/deleteBreakInData.php?dataId=" + dataId;

    Response res = await http.get(url).then((value) {
      pageController.breakInItemList
          .removeWhere((element) => element["dataId"] == dataId);
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString());
    });
  }

  removeItemFromRaceList(String dataId) async {
    var url = UrlApp.url + "/deleteRaceData.php?dataId=" + dataId;

    Response res = await http.get(url).then((value) {
      pageController.race_practiceItemList
          .removeWhere((element) => element["dataId"] == dataId);
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString());
    });
  }

  removeItemFromMantainenceList(String dataId) async {
    var url = UrlApp.url + "/deleteMantainenceData.php?dataId=" + dataId;

    Response res = await http.get(url).then((value) {
      pageController.mantainenceItemList
          .removeWhere((element) => element["dataId"] == dataId);
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString());
    });
  }

  Widget _buildTile(text) {
    return GestureDetector(
      onLongPress: () {
        modifyItemData(text);
      },
      child: Container(
        width: isBreakIn
            ? (Get.width / 3) - (20 / 1.5)
            : isRace
                ? (Get.width / 4) - (20 / 2)
                : isMantainence
                    ? Get.width
                    : 0,
        padding:
            EdgeInsets.symmetric(vertical: 10, horizontal: isNotes ? 10 : 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            text,
            style: itemTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakIn() {
    return Row(
      children: [
        _buildTile(itemData["dateOf"]),
        _buildTile(itemData["fuel"]),
        _buildTile(itemData["timeOf"]),
      ],
    );
  }

  Widget _buildRaces() {
    return Row(
      children: [
        _buildTile(itemData["dateOf"]),
        _buildTile(itemData["fuel"]),
        _buildTile(itemData["parL"]),
        _buildTile(itemData["totL"]),
      ],
    );
  }

  Widget _buildMantainence() {
    return Column(
      children: [
        _buildTile(itemData["dateOf"]),
        _buildTile(itemData["notes"]),
      ],
    );
  }

  modifyItemData(String dataToModify) {
    TextEditingController textController = new TextEditingController();
    textController.text = dataToModify;
    Get.defaultDialog(
        title: "Modify data",
        titleStyle:
            GoogleFonts.montserrat(color: colorController.getTextColorTheme()),
        middleText: null,
        content: Form(
          //key: _addBreakInDataFormKey,
          child: Column(
            children: [
              FormFieldInputTile(
                controller: textController,
                //initialValue: dataToModify,
                maxLength: 15,
                hintText: "Fuel used",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              AddDataButton(
                text: "Update",
                onTap: () {
                  pageController.breakInItemList
                      .where(
                          (element) => element["dataId"] == itemData["dataId"])
                      .forEach((element) {
                    Map<String, dynamic> temp = {
                      "dateOf": itemData["dateOf"],
                      "fuel": textController.text,
                      "timeOf": itemData["timeOf"],
                      "dataId": itemData["dataId"],
                    };
                    element = temp;
                  });
                },
              )
            ],
          ),
        ),
        backgroundColor: colorController.getBackGroundColorTheme());
  }

  Map<String, dynamic> getItemData() {
    return itemData;
  }

  Widget build(BuildContext context) {
    print(itemData);

    return Slidable(
      actions: [
        GestureDetector(
          onTap: () {
            if (isBreakIn)
              removeItemFromBreakInList(itemData["dataId"].toString());
            if (isRace) removeItemFromRaceList(itemData["dataId"].toString());
            if (isMantainence)
              removeItemFromMantainenceList(itemData["dataId"].toString());
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                "Remove",
                style: itemTextStyle,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
      secondaryActions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              "Update",
              style: itemTextStyle,
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(15)),
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: isBreakIn
          ? _buildBreakIn()
          : isRace
              ? _buildRaces()
              : isMantainence
                  ? _buildMantainence()
                  : Container(),
    );
  }
}
