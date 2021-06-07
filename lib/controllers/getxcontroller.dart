import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
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
  var isModified = false.obs;

  setModified(state) {
    isModified(state);
  }

  getModified() {
    return isModified.value;
  }
}
