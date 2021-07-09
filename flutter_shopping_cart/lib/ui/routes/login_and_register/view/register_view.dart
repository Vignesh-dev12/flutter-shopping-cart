import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shopping_cart/core/model/base_model.dart';
import 'package:flutter_shopping_cart/route_setup.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view_model/login_and_register_view_model.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';
import 'package:flutter_shopping_cart/ui/themes/theme.dart';
import 'package:flutter_shopping_cart/ui/widgets/base_widget.dart';
import 'package:flutter_shopping_cart/ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  var _nameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _key = GlobalKey<FormState>();
  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
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
                  SizedBox(height: 20),
                  _registerForm(model, context1),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _registerForm(LoginAndRegisterViewModel model, BuildContext context1) {
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
                controller: _nameTextController,
                decoration: AppTheme.boxTextFieldDecoration('Name'),
                validator: (String? value) {
                  if (value!.toString().trim().isEmpty) {
                    return "Please enter your name";
                  } else if (value.toString().trim().length < 3) {
                    return "Name must be of atleast 3 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 22.0),
              InkWell(
                onTap: () {
                  _selectDateOfBirth(context);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.8),
                      width: 0.7,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 11.0, 12.0, 12.0),
                    child: dateOfBirth != null
                        //true
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${dateOfBirth!.day} - ${dateOfBirth!.month} - ${dateOfBirth!.year}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 15.5),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Select Date Of Birth',
                              style: TextStyle(
                                  //fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 22.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _passwordTextController,
                decoration: AppTheme.boxTextFieldDecoration('Password'),
                validator: (String? value) {
                  if (value!.toString().trim().isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 22.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmPasswordTextController,
                decoration: AppTheme.boxTextFieldDecoration('Confirm Password'),
                validator: (String? value) {
                  if (value!.toString().trim().isEmpty) {
                    return "Please enter confirm password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.0),
              Container(
                height: 48,
                child: CustomButtonWithProgress(
                  text: 'Continue',
                  isShowProgress: model.state == ViewState.BUSY,
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      if (dateOfBirth != null) {
                        FocusScope.of(context).unfocus();
                        var isSuccess = await model.register(
                            _nameTextController.text,
                            dateOfBirth.toString(),
                            _passwordTextController.text);
                        if (isSuccess) {
                          Navigator.pushNamed(context, RoutePaths.LoginView);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select date of birth')));
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                height: 48,
                child: OutlinedButton(
                  child: Text(
                    "Already have a account? Login",
                    style: TextStyle(fontSize: 17.2, color: accentColor),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutePaths.LoginView);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateOfBirth == null ? DateTime.now() : dateOfBirth!,
        firstDate: DateTime(1980),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != dateOfBirth)
      setState(() {
        dateOfBirth = pickedDate;
      });
  }
}
