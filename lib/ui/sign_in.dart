import 'dart:convert';

import 'package:ccckmall/helpers/helpers.dart';
import 'package:ccckmall/main.dart';
import 'package:ccckmall/ui/sign_up.dart';
import 'package:ccckmall/values/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String apiURL() {
  String url = Config.signIn;
  return url;
}


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formLoginStateKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNode1 = FocusNode();
  String errorMessage = '';
  String successMessage = '';
  SharedPreferences prefs;
  String _loginEmail,_loginPass;
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
    _focusNode.dispose();
    super.dispose();
  }


  Future<Null> signInEmailPass(String email, String password) async {
    this.setState(() {
      errorMessage = '';
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
      var res = await http
        .get(Uri.encodeFull(Config.appURL + "user/login/"+email+"/"+password+"/"+Config.API_KEY)
          , headers: {"Accept": "application/json"});
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                  image: AssetImage('images/donate.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formLoginStateKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: TextFormField(
                              validator: validateEmail,
                              focusNode: _focusNode,
                              onSaved: (value) {
                                _loginEmail = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
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
                            padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: TextFormField(
                              validator: validatePassword,
                              focusNode: _focusNode1,
                              onSaved: (value) {
                                _loginPass = value;
                              },
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Theme.of(context).primaryColor,
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
                        ],
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: new FlatButton(
                            child: new Text(
                              "New User? Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            onPressed: () {
                              var route = new MaterialPageRoute(
                                builder: (BuildContext context) => new SignUp(),
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
                          left: 30.0, right: 30.0, top: 20.0),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_formLoginStateKey.currentState.validate()) {
                                  _formLoginStateKey.currentState.save();
                                  signInEmailPass(_loginEmail, _loginPass);
                                }
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "LOGIN",
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
                    (errorMessage != ''
                        ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                        : Container())
                  ],
                ),
              ),
            ),
            Positioned(
              child: isLoading ? Center(child: CircularProgressIndicator(),) : Container(),
            ),
          ],
        ),
      ),
    );
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

  loginHandleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
          isLoading = false;
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
          isLoading = false;
        });
        break;
    }
  }


}
