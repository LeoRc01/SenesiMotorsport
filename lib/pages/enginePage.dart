import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import 'package:SenesiMotorsport/controllers/email.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SenesiMotorsport/models/gridItemTile.dart';
import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/controllers/pdfCreator.dart';
import 'package:SenesiMotorsport/main.dart';
import 'package:SenesiMotorsport/url/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:uuid/uuid.dart';

class EnginePage extends StatelessWidget {
  Controller enginePageController = new Controller();
  TextStyle itemTextStyle = GoogleFonts.montserrat(
      color: colorController.getTextColorTheme(), fontSize: Get.width * 0.03);
  TextStyle titleStyle = GoogleFonts.montserrat(
      color: colorController.getTextColorTheme(), fontSize: Get.width * 0.045);

  TextStyle subTitleStyle = GoogleFonts.montserrat(
      decoration: TextDecoration.underline,
      color: colorController.getTextColorTheme(),
      fontSize: Get.width * 0.04);

  final _addBreakInDataFormKey = GlobalKey<FormState>();

  var insideOf;

  var engineId;

  EnginePage(
      {@required this.insideOf,
      @required String name,
      @required this.engineId}) {
    enginePageController.setIsLoading();
    initControllers();
    fetchGeneralInfo().then((value) {
      fetchBreakInData().then((value) {
        fetchRacesPracticeData().then((value) {
          fetchMantainenceData().then((value) {
            engineName.text = name;
            selectedDateBreakInController.text = "Select a date";
            selectedDateRacePracticeController.text = "Select a date";
            selectedDateMantainenceController.text = "Select a date";

            enginePageController.setNotLoadingLoading();
          });
        });
      });
    });
  }

  TextEditingController engineName;
  TextEditingController generalInfoController;

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

  Uuid _uuid = Uuid();

  updateGeneralInfo() async {
    String createdUuid = _uuid.v1();
    var url = UrlApp.url +
        "/setGeneralInfo.php?dataId=" +
        createdUuid +
        "&engineId=" +
        engineId +
        "&content=" +
        generalInfoController.text;
    Response res = await http.get(url).then((value) {
      print(value.body);
      Get.snackbar("Success!", "Data updated correctly.");
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
  }

  initControllers() {
    engineName = new TextEditingController();
    generalInfoController = new TextEditingController();
    selectedDateBreakInController = new TextEditingController();
    selectedDateRacePracticeController = new TextEditingController();
    selectedDateMantainenceController = new TextEditingController();
    noteController = new TextEditingController();
    fuelUsedBreakInController = new TextEditingController();
    timeController = new TextEditingController();
    fuelUsedRacePracticeController = new TextEditingController();
    parLiters = new TextEditingController();
    totLiters = new TextEditingController();
  }

  Widget showDatePickerWidget(context) {
    return GestureDetector(
      onTap: () async {
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
        ).then((value) {
          enginePageController.setDateBreakInString(value.day.toString() +
              "/" +
              value.month.toString() +
              "/" +
              value.year.toString());
          selectedDateBreakInController.text =
              enginePageController.selectedDateBreakInString.string;
        });
      },
      child: Container(
        width: Get.width * 0.35,
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            "Select Date",
            style: itemTextStyle,
          ),
        ),
      ),
    );
  }

  Widget showDatePickerWidgetRacePracice(context) {
    return GestureDetector(
      onTap: () async {
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
        ).then((value) {
          enginePageController.setDateRacePracticeString(value.day.toString() +
              "/" +
              value.month.toString() +
              "/" +
              value.year.toString());
          selectedDateRacePracticeController.text =
              enginePageController.selectedDateRacePracticeString.string;
        });
      },
      child: Container(
        width: Get.width * 0.35,
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            "Select Date",
            style: itemTextStyle,
          ),
        ),
      ),
    );
  }

  Widget showDatePickerWidgetMantainence(context) {
    return GestureDetector(
      onTap: () async {
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
        ).then((value) {
          enginePageController.setDateMantainenceString(value.day.toString() +
              "/" +
              value.month.toString() +
              "/" +
              value.year.toString());
          selectedDateMantainenceController.text =
              enginePageController.selectedDateMantainenceString.string;
        });
      },
      child: Container(
        width: Get.width * 0.35,
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            "Select Date",
            style: itemTextStyle,
          ),
        ),
      ),
    );
  }

  breakInDataDialog(context) {
    Get.defaultDialog(
        title: "Add Break-in data",
        titleStyle: titleStyle,
        middleText: null,
        content: Form(
          key: _addBreakInDataFormKey,
          child: Column(
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
                  showDatePickerWidget(context),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                maxLength: 15,
                hintText: "Fuel used",
                controller: fuelUsedBreakInController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                maxLength: 15,
                hintText: "Time for break-in",
                controller: timeController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              AddDataButton(
                onTap: addBreakInDataToList,
              )
            ],
          ),
        ),
        backgroundColor: colorController.getBackGroundColorTheme());
  }

  racesPracticeDialog(context) {
    Get.defaultDialog(
        title: "Add data",
        titleStyle: titleStyle,
        middleText: null,
        content: Form(
          key: _addBreakInDataFormKey,
          child: Column(
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
                  showDatePickerWidgetRacePracice(context),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                maxLength: 15,
                hintText: "Fuel used",
                controller: fuelUsedRacePracticeController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                isNumeric: true,
                hintText: "Partial Liters",
                controller: parLiters,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                isNumeric: true,
                hintText: "Total Liters",
                controller: totLiters,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              AddDataButton(
                onTap: addRacePracticeDataToList,
              )
            ],
          ),
        ),
        backgroundColor: colorController.getBackGroundColorTheme());
  }

  mantainenceDialog(context) {
    Get.defaultDialog(
        title: "Add data",
        titleStyle: titleStyle,
        middleText: null,
        content: Form(
          key: _addBreakInDataFormKey,
          child: Column(
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
                  showDatePickerWidgetMantainence(context),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FormFieldInputTile(
                hintText: "Notes",
                controller: noteController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a value";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              AddDataButton(
                onTap: addMantainenceDataToList,
              )
            ],
          ),
        ),
        backgroundColor: colorController.getBackGroundColorTheme());
  }

  Future fetchGeneralInfo() async {
    enginePageController.generalInfo.removeWhere((key, value) => true);

    var url = UrlApp.url + "/getGeneralInfo.php?id=" + engineId;

    Response res = await http.get(url).then((value) {
      List<dynamic> tempData = jsonDecode(value.body);
      for (var item in tempData) {
        Map<String, dynamic> temp = {
          "content": item["content"],
          "dataId": item["dataId"],
        };
        generalInfoController.text = temp["content"].toString();
        enginePageController.generalInfo.addAll(temp);
      }
      print("General Info: " + enginePageController.generalInfo.toString());
    }).catchError((onError) {
      print(onError);
    });
  }

  Future fetchBreakInData() async {
    enginePageController.breakInItemList
        .removeRange(0, enginePageController.breakInItemList.length);
    var url = UrlApp.url + "/getBreakIn.php?id=" + engineId;

    Response res = await http.get(url).then((value) {
      List<dynamic> tempData = jsonDecode(value.body);
      for (var item in tempData) {
        Map<String, dynamic> temp = {
          "dateOf": item["dateOf"],
          "fuel": item["fuel"],
          "timeOf": item["timeOf"],
          "dataId": item["dataId"],
        };
        enginePageController.breakInItemList.add(temp);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Future fetchRacesPracticeData() async {
    enginePageController.race_practiceItemList
        .removeRange(0, enginePageController.race_practiceItemList.length);
    var url = UrlApp.url + "/getRacesPractice.php?id=" + engineId;

    Response res = await http.get(url).then((value) {
      List<dynamic> tempData = jsonDecode(value.body);
      for (var item in tempData) {
        Map<String, dynamic> temp = {
          "dateOf": item["dateOf"],
          "fuel": item["fuel"],
          "parL": item["parL"],
          "totL": item["totL"],
          "dataId": item["dataId"],
        };
        enginePageController.race_practiceItemList.add(temp);
      }
    });
  }

  Future fetchMantainenceData() async {
    enginePageController.mantainenceItemList
        .removeRange(0, enginePageController.mantainenceItemList.length);
    var url = UrlApp.url + "/getMantainence.php?id=" + engineId;

    Response res = await http.get(url).then((value) {
      List<dynamic> tempData = jsonDecode(value.body);
      for (var item in tempData) {
        Map<String, dynamic> temp = {
          "dateOf": item["dateOf"],
          "notes": item["notes"],
          "dataId": item["dataId"],
        };
        enginePageController.mantainenceItemList.add(temp);
      }
    });
  }

  addBreakInDataToList() async {
    if (_addBreakInDataFormKey.currentState.validate() &&
        selectedDateBreakInController.text != "Select a date") {
      enginePageController.setIsLoading();

      String createdUuid = _uuid.v1();

      var url = UrlApp.url +
          "/setBreakIn.php?id=" +
          engineId +
          "&dateOf=" +
          selectedDateBreakInController.text +
          "&fuel=" +
          fuelUsedBreakInController.text +
          "&timeOf=" +
          timeController.text +
          "&dataId=" +
          createdUuid;

      Response res = await http.get(url).then((value) {
        Map<String, dynamic> temp = {
          "dateOf": selectedDateBreakInController.text,
          "fuel": fuelUsedBreakInController.text,
          "timeOf": timeController.text,
          "dataId": createdUuid,
        };
        enginePageController.breakInItemList.add(temp);

        selectedDateBreakInController.text = "Select a date";
        fuelUsedBreakInController.text = "";
        timeController.text = "";
      }).catchError((error) {
        print(error);
      });

      Get.back();
      enginePageController.setNotLoadingLoading();
    }
  }

  addRacePracticeDataToList() async {
    if (_addBreakInDataFormKey.currentState.validate() &&
        selectedDateRacePracticeController.text != "Select a date") {
      String createdUuid = _uuid.v1();
      var url = UrlApp.url +
          "/setRacesPractice.php?id=" +
          engineId +
          "&dateOf=" +
          selectedDateRacePracticeController.text +
          "&fuel=" +
          fuelUsedRacePracticeController.text +
          "&parL=" +
          parLiters.text +
          "&totL=" +
          totLiters.text +
          "&dataId=" +
          createdUuid;

      Response res = await http.get(url).then((value) {
        Map<String, dynamic> temp = {
          "dateOf": selectedDateRacePracticeController.text,
          "fuel": fuelUsedRacePracticeController.text,
          "parL": parLiters.text,
          "totL": totLiters.text,
          "dataId": createdUuid,
        };
        enginePageController.race_practiceItemList.add(temp);

        selectedDateRacePracticeController.text = "Select a date";
        fuelUsedRacePracticeController.text = "";
        parLiters.text = "";
        totLiters.text = "";
      }).catchError((onError) {
        print(onError);
      });

      Get.back();
    }
  }

  addMantainenceDataToList() async {
    if (_addBreakInDataFormKey.currentState.validate() &&
        selectedDateMantainenceController.text != "Select a date") {
      String createdUuid = _uuid.v1();

      var url = UrlApp.url +
          "/setMantainence.php?id=" +
          engineId +
          "&dateOf=" +
          selectedDateMantainenceController.text +
          "&note=" +
          noteController.text +
          "&dataId=" +
          createdUuid;

      Response res = await http.get(url).then((value) {
        Map<String, dynamic> temp = {
          "dateOf": selectedDateMantainenceController.text,
          "notes": noteController.text,
          "dataId": createdUuid
        };
        enginePageController.mantainenceItemList.add(temp);

        selectedDateMantainenceController.text = "Select a date";
        noteController.text = "";
      });

      Get.back();
    }
  }

  createPdf() async {
    print(generalInfoController.text);
    PdfDocument document = PdfDocument();

    //Setto la grandezza della pagina
    document.pageSettings.size = PdfPageSize.a4;

    //Creo la pagina
    PdfPage page = document.pages.add();

    var width = page.getClientSize().width;
    var height = page.getClientSize().height;

    //Inserisco l'immagine

    //page.graphics.setTransparency(1);
    page.graphics.drawImage(PdfBitmap(await _readImageData("logo.jpg")),
        Rect.fromLTWH(width / 2 - (300 / 2), 0, 300, 94));

    page.graphics.drawString(
      "Engine: " + engineName.text,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.italic),
      bounds: Rect.fromLTWH(
          0, 100, page.getClientSize().width, page.getClientSize().height),
    );

    page.graphics.drawString(
      "Driver: " + UserEmail.userEmail,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.italic),
      bounds: Rect.fromLTWH(
          0, 130, page.getClientSize().width, page.getClientSize().height),
    );

    //BREAK-IN DATA
    PdfGrid breakInGrid = PdfGrid();
    breakInGrid.columns.add(count: 3);

    final PdfGridRow breakInHeaderTitle = breakInGrid.headers.add(1)[0];
    breakInHeaderTitle.cells[0].value = '';
    breakInHeaderTitle.cells[1].value = 'Break-in Data';
    breakInHeaderTitle.cells[2].value = '';
    breakInHeaderTitle.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );
    breakInHeaderTitle.cells[1].stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.center);

    breakInHeaderTitle.cells[1].style.textBrush = PdfBrushes.white;

    breakInHeaderTitle.cells[0].style.backgroundBrush = PdfBrushes.black;
    breakInHeaderTitle.cells[1].style.backgroundBrush = PdfBrushes.black;
    breakInHeaderTitle.cells[2].style.backgroundBrush = PdfBrushes.black;

    final PdfGridRow headerRow = breakInGrid.headers.add(1)[1];
    headerRow.cells[0].value = 'Date';
    headerRow.cells[1].value = 'Fuel';
    headerRow.cells[2].value = 'Time';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    PdfGridRow row;

    for (int i = 0; i < enginePageController.breakInItemList.length; i++) {
      row = breakInGrid.rows.add();
      row.cells[0].value = enginePageController.breakInItemList[i]["dateOf"];
      row.cells[1].value = enginePageController.breakInItemList[i]["fuel"];
      row.cells[2].value = enginePageController.breakInItemList[i]["timeOf"];
    }

    breakInGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    PdfLayoutResult result = breakInGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 160, page.getClientSize().width, page.getClientSize().height),
    );

    //RACE Data

    PdfGrid raceGrid = PdfGrid();
    raceGrid.columns.add(count: 4);

    final PdfGridRow raceHeaderTitle = raceGrid.headers.add(1)[0];
    raceHeaderTitle.cells[0].value = '';
    raceHeaderTitle.cells[1].value = 'Race';
    raceHeaderTitle.cells[2].value = 'Practice';
    raceHeaderTitle.cells[3].value = '';
    raceHeaderTitle.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );
    raceHeaderTitle.cells[1].stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.right);
    raceHeaderTitle.cells[1].style.cellPadding = PdfPaddings(right: 4, top: 5);

    raceHeaderTitle.cells[2].stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.left);

    raceHeaderTitle.cells[2].style.cellPadding = PdfPaddings(left: 4, top: 5);

    raceHeaderTitle.cells[1].style.textBrush = PdfBrushes.white;
    raceHeaderTitle.cells[2].style.textBrush = PdfBrushes.white;

    raceHeaderTitle.cells[0].style.backgroundBrush = PdfBrushes.black;
    raceHeaderTitle.cells[1].style.backgroundBrush = PdfBrushes.black;
    raceHeaderTitle.cells[2].style.backgroundBrush = PdfBrushes.black;
    raceHeaderTitle.cells[3].style.backgroundBrush = PdfBrushes.black;

    final PdfGridRow headerRow1 = raceGrid.headers.add(1)[1];
    headerRow1.cells[0].value = 'Date';
    headerRow1.cells[1].value = 'Fuel';
    headerRow1.cells[2].value = 'Partial Liters';
    headerRow1.cells[3].value = 'Total Liters';
    headerRow1.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    PdfGridRow row1;

    for (int i = 0;
        i < enginePageController.race_practiceItemList.length;
        i = i + 4) {
      row1 = raceGrid.rows.add();

      row1.cells[0].value =
          enginePageController.race_practiceItemList[i]["dateOf"];
      row1.cells[1].value =
          enginePageController.race_practiceItemList[i]["fuel"];
      row1.cells[2].value =
          enginePageController.race_practiceItemList[i]["parL"];
      row1.cells[3].value =
          enginePageController.race_practiceItemList[i]["totL"];
    }

    raceGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    result = raceGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom, page.getClientSize().width,
          page.getClientSize().height),
    );

    //Mantainece Data

    PdfGrid mantainenceGrid = PdfGrid();
    mantainenceGrid.columns.add(count: 2);

    final PdfGridRow mantainenceTitle = mantainenceGrid.headers.add(1)[0];
    mantainenceTitle.cells[0].value = 'Manta';
    mantainenceTitle.cells[1].value = 'inence';

    mantainenceTitle.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );
    mantainenceTitle.cells[0].stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.right);
    mantainenceTitle.cells[0].style.cellPadding = PdfPaddings(right: 0, top: 5);

    mantainenceTitle.cells[1].stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.left);

    mantainenceTitle.cells[1].style.cellPadding = PdfPaddings(left: 0, top: 5);

    mantainenceTitle.cells[0].style.textBrush = PdfBrushes.white;
    mantainenceTitle.cells[1].style.textBrush = PdfBrushes.white;

    mantainenceTitle.cells[0].style.backgroundBrush = PdfBrushes.black;
    mantainenceTitle.cells[1].style.backgroundBrush = PdfBrushes.black;

    final PdfGridRow headerRow2 = mantainenceGrid.headers.add(1)[1];
    headerRow2.cells[0].value = 'Date';
    headerRow2.cells[1].value = 'Note';

    headerRow2.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    PdfGridRow row2;

    for (int i = 0;
        i < enginePageController.mantainenceItemList.length;
        i = i + 2) {
      row2 = mantainenceGrid.rows.add();

      row2.cells[0].value =
          enginePageController.mantainenceItemList[i]["dateOf"];
      row2.cells[1].value =
          enginePageController.mantainenceItemList[i]["notes"];
    }

    mantainenceGrid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    result = mantainenceGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom, page.getClientSize().width,
          page.getClientSize().height),
    ) as PdfLayoutResult;

    page.graphics.drawString(
      "General Info: ",
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 30,
          page.getClientSize().width, page.getClientSize().height),
    );

    page.graphics.drawString(
      generalInfoController.text,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 60,
          page.getClientSize().width, page.getClientSize().height),
    );

    List<int> bytes = document.save();
    document.dispose();
    var fileName = engineName.text;
    saveAndLaunch(bytes, "$fileName.pdf");
  }

  FocusNode _focusNode = new FocusNode();

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load("assets/$name");
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorController.getTextColorTheme(),
            ),
          ),
          elevation: 0,
          actions: [
            enginePageController.getLoading()
                ? Container()
                : IconButton(
                    onPressed: () {
                      //convert to PDF
                      createPdf();
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.share,
                      color: colorController.getTextColorTheme(),
                    ),
                  ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: colorController.getBackGroundColorTheme(),
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SafeArea(
                child: enginePageController.getLoading()
                    ? Container(
                        child: Center(
                            child: Text("Loading...",
                                style: GoogleFonts.montserrat(
                                    color:
                                        colorController.getTextColorTheme()))),
                      )
                    : Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //INFO FORM
                            Row(
                              children: [
                                Text(
                                  "Engine: ",
                                  style: titleStyle,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    onEditingComplete: () {
                                      print(engineName.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    style: titleStyle,
                                    controller: engineName,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Text(
                              "General Info: ",
                              style: titleStyle,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              focusNode: _focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              controller: generalInfoController,
                              style: GoogleFonts.montserrat(
                                  color: colorController.getTextColorTheme()),
                              decoration: InputDecoration(
                                hintStyle: GoogleFonts.montserrat(),
                                hintText: "",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            AddDataButton(
                              onTap: () {
                                updateGeneralInfo();
                              },
                              text: "Update",
                            ),

                            Divider(
                              thickness: 1,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //BREAK-IN FORM
                            Center(
                              child: Text(
                                "Break-in",
                                style: titleStyle,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Date",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Fuel",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Time",
                                  style: subTitleStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StaggeredGridView.countBuilder(
                              crossAxisCount: 1,
                              itemCount:
                                  enginePageController.breakInItemList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return GridItemTile.isBreakIn(
                                  enginePageController.breakInItemList[index],
                                  itemTextStyle,
                                  pageController: enginePageController,
                                );
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            AddDataButton(
                              onTap: () {
                                breakInDataDialog(context);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //RACE/PRACTISE FORM
                            Center(
                              child: Text(
                                "Races / Practice",
                                style: titleStyle,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Date",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Fuel",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Par. L",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Tot. L",
                                  style: subTitleStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StaggeredGridView.countBuilder(
                              crossAxisCount: 1,
                              itemCount: enginePageController
                                  .race_practiceItemList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return GridItemTile.isRace(
                                    enginePageController
                                        .race_practiceItemList[index],
                                    itemTextStyle,
                                    pageController: enginePageController);
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            AddDataButton(
                              onTap: () {
                                racesPracticeDialog(context);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //MANTAINENCE FORM
                            Center(
                              child: Text(
                                "Mantainence",
                                style: titleStyle,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Date",
                                  style: subTitleStyle,
                                ),
                                Text(
                                  "Notes",
                                  style: subTitleStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StaggeredGridView.countBuilder(
                              crossAxisCount: 1,
                              itemCount: enginePageController
                                  .mantainenceItemList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return GridItemTile.isMantainence(
                                  enginePageController
                                      .mantainenceItemList[index],
                                  itemTextStyle,
                                  pageController: enginePageController,
                                );
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(1),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            AddDataButton(
                              onTap: () {
                                mantainenceDialog(context);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDataButton extends StatelessWidget {
  Function onTap;
  String text;
  TextStyle itemTextStyle = GoogleFonts.montserrat(
      color: colorController.getTextColorTheme(), fontSize: Get.width * 0.03);
  AddDataButton({this.onTap, this.text = "Add data"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            text.toString(),
            style: itemTextStyle,
          ),
        ),
      ),
    );
  }
}

class FormFieldInputTile extends StatelessWidget {
  Function validator;
  TextEditingController controller;
  String hintText;
  bool enabled;
  int maxLength;
  bool isNumeric = false;
  String initialValue = "";

  FormFieldInputTile({
    this.isNumeric,
    this.validator,
    this.controller,
    this.hintText,
    this.enabled,
    @required this.maxLength,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isNumeric == null
          ? TextInputType.text
          : isNumeric
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
      maxLength: maxLength,
      enabled: enabled,
      controller: controller,
      validator: validator,
      maxLines: hintText == "Notes" ? 10 : 1,
      style: GoogleFonts.montserrat(color: colorController.getTextColorTheme()),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.montserrat(),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
