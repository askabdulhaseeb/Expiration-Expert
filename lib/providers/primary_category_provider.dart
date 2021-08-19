import 'package:flutter/material.dart';
import '../../model/primary_category.dart';
import '../../model/secondary_category.dart';

class CategoryProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<PrimaryCategory> _priCat = <PrimaryCategory>[
    PrimaryCategory(id: 'food', title: 'Food'),
    PrimaryCategory(id: 'recipe', title: 'Recipes'),
  ];
  String? selectedPri;
  // ignore: prefer_final_fields
  List<SecondaryCategory> _secCat = <SecondaryCategory>[
    SecondaryCategory(id: 'drink', title: 'Drink', priID: 'food'),
    SecondaryCategory(id: 'fruit', title: 'Fruit', priID: 'food'),
    SecondaryCategory(id: 'grocery', title: 'Grocery', priID: 'food'),
    SecondaryCategory(id: '5mints', title: '5 Mints think', priID: 'recipe'),
    SecondaryCategory(id: '30mints', title: '30 Mints think', priID: 'recipe'),
  ];
  String? selectedSec;

  List<PrimaryCategory> get primary => <PrimaryCategory>[..._priCat];
  List<SecondaryCategory>? secondory(String? id) {
    final List<SecondaryCategory> _temp = <SecondaryCategory>[];
    _temp
        .addAll(_secCat.where((SecondaryCategory e) => e.priID == selectedPri));
    return _temp;
  }

  void loadPrimary() {
    _priCat.add(PrimaryCategory(id: 'food', title: 'Food'));
    _priCat.add(PrimaryCategory(id: 'recipe', title: 'Recipes'));
  }

  void loadSecondory() {
    _secCat.add(SecondaryCategory(id: 'drink', title: 'Drink', priID: 'food'));
    _secCat.add(SecondaryCategory(id: 'fruit', title: 'Fruit', priID: 'food'));
    _secCat
        .add(SecondaryCategory(id: 'grocery', title: 'Grocery', priID: 'food'));
    _secCat.add(SecondaryCategory(
        id: '5mints', title: '5 Mints think', priID: 'recipe'));
    _secCat.add(SecondaryCategory(
        id: '30mints', title: '30 Mints think', priID: 'recipe'));
  }

  void onPrimorySelection(String? value) {
    selectedSec = null;
    selectedPri = value;
    notifyListeners();
  }

  void onSecondorySelection(String? value) {
    selectedSec = value;
    notifyListeners();
  }
}
