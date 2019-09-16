
import 'dart:convert';

import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/main.dart';
import 'package:ccckmall/ui/sign_in.dart';
import 'package:ccckmall/values/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String apiURL() {
  String url = Config.signUp;
  return url;
}


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formSignUpStateKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  String errorMessage = '';
  String successMessage = '';
  SharedPreferences prefs;
  String _emailId,
      _password,
      _name,
      _confirmPass;
  bool isLoading = false;
  var resBody;
  String msg;
  int code = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<Null> signUp(email, password, name) async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      var res = await http.post(Uri.encodeFull(apiURL()),
          body: {'name': name, 'username': email,'password': password,'type': 'email'});
      String responseBody = res.body;
      var responseJSON = json.decode(responseBody);
      if (res.statusCode == 200) {
        code = responseJSON['code'];
        msg = responseJSON['message'];
        resBody = responseJSON['values'];
        setState(() {
          if(Helpers.enableDebug) print('UI Updated:' + responseBody);
          isLoading = false;
          if(code != 200){
            Fluttertoast.showToast(msg: msg);
          }else{
            int id_user = 0;
            String name_user="x";
            String username_user="x";
            String salt_user="0";
            String token_user="0";
            String type_user="x";
            for (var data in resBody){
              if (data['name'] == "salt"){
                salt_user = data['value'];
              }
              if (data['name'] == "token"){
                token_user=data['value'];
              }
              if (data['name'] == "id"){
                id_user=data['value'];
              }
              if (data['name']=="name"){
                name_user=data['value'];
              }
              if (data['name']=="type"){
                type_user=data['value'];
              }
              if (data['name']=="username"){
                username_user=data['value'];
              }
            }
            prefs.setInt("ID_USER",id_user);
            prefs.setString("SALT_USER",salt_user);
            prefs.setString("TOKEN_USER",token_user);
            prefs.setString("NAME_USER",name_user);
            prefs.setString("TYPE_USER",type_user);
            prefs.setString("USERNAME_USER",username_user);
            prefs.setBool('isLogin', true);

            Fluttertoast.showToast(msg: msg);
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                  )),
            );
          }
        });
      } else {
        if(Helpers.enableDebug) print('Something went wrong. \nResponse Code : ${res.statusCode}');
      }
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Address!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }
  String validateName(String value) {
    if (value.trim().isEmpty || value.length < 4) {
      return 'Minimum 4 Characters!!!';
    }
    return null;
  }
  String validateConfirmPassword(String value) {
    if (value.trim() != passwordController.text.trim()) {
      return 'Password Mismatch!!!';
    }
    return null;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        setState(() {
          errorMessage = 'Email Address already Exist!!!';
          isLoading = false;
        });
        break;
      default:
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            new Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    image: AssetImage(''
                        'images/donate.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: new Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: 40, right: 40, top: 50, bottom: 20),
                          child: Center(
                            child: Text(
                              "Sign up by email address",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Form(
                          key: _formSignUpStateKey,
                          autovalidate: true,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 1),
                                child: TextFormField(
                                  validator: validateName,
                                  onSaved: (value) {
                                    _name = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  focusNode: _focusNode,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          width: 2,
                                          style: BorderStyle.solid),
                                    ),
                                    labelText: "Name",
                                    icon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 1),
                                child: TextFormField(
                                  validator: validateEmail,
                                  onSaved: (value) {
                                    _emailId = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  focusNode: _focusNode2,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                          style: BorderStyle.solid),
                                    ),
                                    labelText: "Email Address",
                                    icon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 1),
                                child: TextFormField(
                                  validator: validatePassword,
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  controller: passwordController,
                                  focusNode: _focusNode3,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                    labelText: "Password",
                                    icon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 1),
                                child: TextFormField(
                                  validator: validateConfirmPassword,
                                  onSaved: (value) {
                                    _confirmPass = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: confirmPasswordController,
                                  focusNode: _focusNode4,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                          style: BorderStyle.solid),
                                    ),
                                    labelText: "Confirm Password",
                                    icon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        (errorMessage != ''
                            ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                            : Container()),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: new FlatButton(
                                child: new Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                onPressed: () {
                                  var route = new MaterialPageRoute(
                                    builder: (BuildContext context) => new SignIn(),
                                  );
                                  Navigator.of(context).push(route);
                                },
                              ),
                            ),
                          ],
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 5.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(30.0),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    if (_formSignUpStateKey.currentState
                                        .validate()) {
                                      _formSignUpStateKey.currentState.save();
                                      signUp(_emailId, _password, _name);
                                    }
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 20.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "SIGN UP",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
            // Loading
            Positioned(
              child: isLoading ? Center(child: CircularProgressIndicator(),) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
