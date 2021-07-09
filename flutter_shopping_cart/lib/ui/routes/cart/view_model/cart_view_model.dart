
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shopping_cart/core/model/base_model.dart';
import 'package:flutter_shopping_cart/ui/routes/cart/model/products_model.dart';

class CartViewModel extends BaseModel{

  ProductsModel? productsModel;

  Future getCategories() async {
    setState(ViewState.BUSY);
    var categoriesJson = await rootBundle.loadString('assets/products.json');
    productsModel = await compute(productsModelFromJson, categoriesJson);
    setState(ViewState.IDLE);
  }

}