import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/core/model/base_model.dart';
import 'package:flutter_shopping_cart/route_setup.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view_model/login_and_register_view_model.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';
import 'package:flutter_shopping_cart/ui/themes/theme.dart';
import 'package:flutter_shopping_cart/ui/widgets/base_widget.dart';
import 'package:flutter_shopping_cart/ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginViewState1();
  }
}

class LoginViewState1 extends State<LoginView> {
  var _userNameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _key = GlobalKey<FormState>();

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        elevation: 2,
      ),
      body: Builder(builder: (BuildContext context1) {
        return BaseWidget<LoginAndRegisterViewModel>(
          model: LoginAndRegisterViewModel(context: context),
          onModelReady: (model) async => true,
          builder: (context, model, child) => Container(
            height: double.infinity,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: 20.0),
                  _loginForm(model, context1),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _loginForm(LoginAndRegisterViewModel model, BuildContext context1) {
    return Form(
      key: _key,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _userNameTextController,
                decoration: AppTheme.boxTextFieldDecoration('Enter Name'),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordTextController,
                obscureText: !passwordVisible,
                decoration:
                    AppTheme.boxTextFieldDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.0),
              Container(
                height: 48,
                child: CustomButtonWithProgress(
                  text: 'Login',
                  isShowProgress: model.state == ViewState.BUSY,
                  onPressed: () async {
                    try {
                      if (model.state == ViewState.IDLE) {
                        if (_key.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          var result = await model.login(
                              _userNameTextController.text.trim(),
                              _passwordTextController.text.trim());
                          if (result) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, RoutePaths.CartView);
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                height: 48,
                width: double.infinity,
                child: OutlinedButton(
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(fontSize: 17.2, color: accentColor),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutePaths.RegisterView);
                  },
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
