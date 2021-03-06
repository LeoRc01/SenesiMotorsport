import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  /*
  THEME PART
  */

  SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Controller.colorController() {
    initPrefs().then((value) {
      prefs.getString("THEME") == "LIGHT"
          ? changeToLightTheme()
          : changeToDarkTheme();
    });
  }

  Controller();

  var backGroundColorTheme = AppColors.darkColor.obs;
  var textColorTheme = Colors.white.obs;
  var isDarkTheme = true.obs;

  getBackGroundColorTheme() => backGroundColorTheme.value;
  getTextColorTheme() => textColorTheme.value;

  changeToLightTheme() {
    prefs.setString("THEME", "LIGHT");
    Get.changeTheme(ThemeData.light());
    backGroundColorTheme(Colors.white);
    textColorTheme(AppColors.darkColor);
    isDarkTheme(false);
  }

  changeToDarkTheme() {
    prefs.setString("THEME", "DARK");
    Get.changeTheme(ThemeData.dark());
    textColorTheme(Colors.white);
    backGroundColorTheme(AppColors.darkColor);
    isDarkTheme(true);
  }

  /**/

  var quantity = 0.obs;
  var hasChanged = 0.obs;

  var isLoading = false.obs;

  void setIsLoading() => isLoading(true);
  void setNotLoadingLoading() => isLoading(false);

  bool getLoading() {
    if (isLoading.isTrue) {
      return true;
    } else {
      return false;
    }
  }

  void setToChanged() {
    hasChanged++;
  }

  void setToNotChanged() {
    hasChanged--;
  }

  bool getChanged() {
    if (hasChanged == 0) {
      return false;
    } else {
      return true;
    }
  }

  void initializeQuantity(int n) {
    quantity(n);
  }

  void setQuantity(int quantity) {
    this.quantity(quantity);
  }

  void incrementQuantity() => quantity++;
  void decrementQuantity() {
    quantity > 0 ? quantity-- : quantity(0);
  }

  void setQuantityToZero() => quantity(0);

  int getQuantity() => quantity.value;

  var selectedCategoryValue = "".obs;
  void changeCategoryValue(String value) => selectedCategoryValue(value);
  String getCategoryValue() {
    return selectedCategoryValue.toString();
  }

  //SHOW ITEMS PAGE SECTION
  List<dynamic> itemList = [].obs;
  List<dynamic> selectedItems = [].obs;

  insertItemIntoList(item) {
    itemList.add(item);
  }

  removeItemFromItemList(itemInserted) {
    print(itemInserted);
    itemList.remove(itemInserted);
  }

  getItem(index) {
    return itemList[index];
  }

  setList(list) {
    itemList = list;
  }

  List<dynamic> getAllItemsFromList() {
    return itemList;
  }
  /////////////

  //NOTE PAGE SECTION
  var isMoving = false.obs;
  var isModified = false.obs;

  setModified(state) {
    isModified(state);
  }

  getModified() {
    return isModified.value;
  }

  //ORDER PAGE SECTION
  var hasOrderedSomething = false.obs;

  getHasOrderedSomething() => hasOrderedSomething.value;
  setHasOrderedSomething(value) => hasOrderedSomething(value);

  //CREATE ENGINE SECTION

  var selectedDateBreakInString = "Select a date".obs;
  var selectedDateRacePracticeString = "Select a date".obs;
  var selectedDateMantainenceString = "Select a date".obs;

  setDateBreakInString(value) => selectedDateBreakInString(value);
  setDateRacePracticeString(value) => selectedDateRacePracticeString(value);
  setDateMantainenceString(value) => selectedDateMantainenceString(value);

  List<dynamic> breakInItemList = [].obs;
  List<dynamic> race_practiceItemList = [].obs;
  List<dynamic> mantainenceItemList = [].obs;

  Map<String, dynamic> generalInfo = {};
}
