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

  GridItemTile.isBreakIn(
    this.itemData,
    this.itemTextStyle, {
    this.isBreakIn = true,
    @required this.pageController,
  }) {
    selectedDateBreakInController = new TextEditingController();
    selectedDateBreakInController.text = itemData["dateOf"];

    fuelUsedBreakInController = new TextEditingController();
    fuelUsedBreakInController.text = itemData["fuel"];

    timeController = new TextEditingController();
    timeController.text = itemData["timeOf"];
  }

  GridItemTile(this.itemData, this.itemTextStyle);

  GridItemTile.isNotes(this.itemData, this.itemTextStyle,
      {this.isNotes = true, @required this.pageController});

  GridItemTile.isRace(this.itemData, this.itemTextStyle,
      {this.isRace = true, @required this.pageController}) {
    selectedDateRacePracticeController = new TextEditingController();
    selectedDateRacePracticeController.text = itemData["dateOf"];

    fuelUsedRacePracticeController = new TextEditingController();
    fuelUsedRacePracticeController.text = itemData["fuel"];

    parLiters = new TextEditingController();
    parLiters.text = itemData["parL"];

    totLiters = new TextEditingController();
    totLiters.text = itemData["totL"];
  }
  GridItemTile.isMantainence(this.itemData, this.itemTextStyle,
      {this.isMantainence = true,
      @required this.pageController,
      this.isNotes = true}) {
    selectedDateMantainenceController = new TextEditingController();
    selectedDateMantainenceController.text = itemData["dateOf"];

    noteController = new TextEditingController();
    noteController.text = itemData["notes"];
  }

  //BREAKIN
  TextEditingController selectedDateBreakInController;
  TextEditingController fuelUsedBreakInController;
  TextEditingController timeController;

  //RACES/PRACTICE
  TextEditingController selectedDateRacePracticeController;
  TextEditingController fuelUsedRacePracticeController;
  TextEditingController parLiters;
  TextEditingController totLiters;

  //MANTAINENCE
  TextEditingController selectedDateMantainenceController;
  TextEditingController noteController;

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

  final _formKey = GlobalKey<FormState>();

  final slidableKey = GlobalKey<SlidableState>();

  showUpdateDialog({List<Widget> children, context}) {
    Get.defaultDialog(
      backgroundColor: colorController.getBackGroundColorTheme(),
      title: "Update Items",
      titleStyle:
          GoogleFonts.montserrat(color: colorController.getTextColorTheme()),
      content: Form(
        key: _formKey,
        child: Column(children: children),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Slidable(
      key: slidableKey,
      actions: [
        GestureDetector(
          onTap: () {
            if (isBreakIn)
              removeItemFromBreakInList(itemData["dataId"].toString());
            if (isRace) removeItemFromRaceList(itemData["dataId"].toString());
            if (isMantainence)
              removeItemFromMantainenceList(itemData["dataId"].toString());
            slidableKey.currentState.dismiss();
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
        GestureDetector(
          onTap: () {
            if (isBreakIn) {
              showUpdateDialog(
                context: context,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Date"),
                          Container(
                            width: Get.width * 0.3,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: selectedDateBreakInController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                      AddDataButton(
                        text: "Select Date",
                        onTap: () async {
                          List<String> initialDate =
                              selectedDateBreakInController.text.split("/");

                          DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              int.parse(initialDate[2]),
                              int.parse(initialDate[1]),
                              int.parse(initialDate[0]),
                            ),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 5),
                          ).then((value) {
                            selectedDateBreakInController.text =
                                value.day.toString() +
                                    "/" +
                                    value.month.toString() +
                                    "/" +
                                    value.year.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  FormFieldInputTile(
                    maxLength: 15,
                    hintText: "Fuel used",
                    controller: fuelUsedBreakInController,
                  ),
                  FormFieldInputTile(
                    maxLength: 15,
                    hintText: "Time for break-in",
                    controller: timeController,
                  ),
                  AddDataButton(
                    text: "Update",
                    onTap: () async {
                      var url = UrlApp.url +
                          "/updateBreakIn.php?engineId=" +
                          itemData["engineId"] +
                          "&fuel=" +
                          fuelUsedBreakInController.text +
                          "&date=" +
                          selectedDateBreakInController.text +
                          "&time=" +
                          timeController.text +
                          "&dataId=" +
                          itemData["dataId"];
                      Response response = await http.get(url).then((value) {
                        Get.back();
                        Get.appUpdate();
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                  ),
                ],
              );
            }
            if (isRace) {
              showUpdateDialog(
                context: context,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Date"),
                          Container(
                            width: Get.width * 0.3,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: selectedDateRacePracticeController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                      AddDataButton(
                        text: "Select Date",
                        onTap: () async {
                          List<String> initialDate =
                              selectedDateRacePracticeController.text
                                  .split("/");

                          DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              int.parse(initialDate[2]),
                              int.parse(initialDate[1]),
                              int.parse(initialDate[0]),
                            ),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 5),
                          ).then((value) {
                            selectedDateRacePracticeController.text =
                                value.day.toString() +
                                    "/" +
                                    value.month.toString() +
                                    "/" +
                                    value.year.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  FormFieldInputTile(
                    maxLength: 15,
                    hintText: "Fuel used",
                    controller: fuelUsedRacePracticeController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormFieldInputTile(
                    isNumeric: true,
                    hintText: "Partial Liters",
                    controller: parLiters,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormFieldInputTile(
                    isNumeric: true,
                    hintText: "Total Liters",
                    controller: totLiters,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AddDataButton(
                    text: "Update",
                    onTap: () async {
                      var url = UrlApp.url +
                          "/updateRace.php?engineId=" +
                          itemData["engineId"] +
                          "&fuel=" +
                          fuelUsedRacePracticeController.text +
                          "&date=" +
                          selectedDateRacePracticeController.text +
                          "&parL=" +
                          parLiters.text +
                          "&totL=" +
                          totLiters.text +
                          "&dataId=" +
                          itemData["dataId"];
                      Response response = await http.get(url).then((value) {
                        Get.back();
                        Get.appUpdate();
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                  ),
                ],
              );
            }
            if (isMantainence) {
              showUpdateDialog(
                context: context,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Date"),
                          Container(
                            width: Get.width * 0.3,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: selectedDateMantainenceController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                      AddDataButton(
                        text: "Select Date",
                        onTap: () async {
                          List<String> initialDate =
                              selectedDateMantainenceController.text.split("/");

                          DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              int.parse(initialDate[2]),
                              int.parse(initialDate[1]),
                              int.parse(initialDate[0]),
                            ),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 5),
                          ).then((value) {
                            selectedDateMantainenceController.text =
                                value.day.toString() +
                                    "/" +
                                    value.month.toString() +
                                    "/" +
                                    value.year.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  FormFieldInputTile(
                    hintText: "Notes",
                    controller: noteController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AddDataButton(
                    text: "Update",
                    onTap: () async {
                      var url = UrlApp.url +
                          "/updateMantainence.php?engineId=" +
                          itemData["engineId"] +
                          "&notes=" +
                          noteController.text +
                          "&date=" +
                          selectedDateMantainenceController.text +
                          "&dataId=" +
                          itemData["dataId"];
                      Response response = await http.get(url).then((value) {
                        Get.back();
                        Get.appUpdate();
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                  ),
                ],
              );
            }
          },
          child: Container(
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
