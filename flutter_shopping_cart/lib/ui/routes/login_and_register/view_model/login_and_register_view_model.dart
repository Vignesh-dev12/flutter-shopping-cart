import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/core/database/db_helper.dart';
import 'package:flutter_shopping_cart/core/database/db_statics.dart';
import 'package:flutter_shopping_cart/core/model/base_model.dart';
import 'package:flutter_shopping_cart/core/shared_preference_helper.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/model/login_model.dart';

class LoginAndRegisterViewModel extends BaseModel {
  BuildContext context;

  LoginAndRegisterViewModel({required this.context});

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future<bool> register(
      String name, String dateOfBirth, String password) async {
    setState(ViewState.BUSY);
    if (!(await dataBaseHelper.checkUserIfAlreadyExists(name, dateOfBirth))) {
      try {
        var user =
            User(name: name, dateOfBirth: dateOfBirth, password: password);
        await dataBaseHelper.insert(DbStatics.tableUsers, user.toJson());
        setState(ViewState.IDLE);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registered successfully')));
        return true;
      } on Exception catch (e) {
        setState(ViewState.IDLE);
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You already registered, Please login')));
    }
    setState(ViewState.IDLE);
    return false;
  }

  Future<bool> login(String name, String password) async {
    setState(ViewState.BUSY);
    var user = await dataBaseHelper.login(name, password);
    setState(ViewState.IDLE);
    if (user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login successfully')));
      await PreferenceHelper.setBool(PreferenceConst.isUserLogin, true);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login credentials are incorrect')));
    }
    return false;
  }
}
