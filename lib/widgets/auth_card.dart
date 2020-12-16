import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthData { login, signup }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthData _authData = AuthData.login;
  final _passwordFocusNode = FocusNode();
  // final _confirmFocusNode = FocusNode();
  final _confirmController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _userData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    // _confirmFocusNode.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _saveForm() {
    var _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    if (_authData == AuthData.login) {
      Provider.of<Auth>(context, listen: false).login(
        _userData['email'],
        _userData['password'],
      );
    } else if (_authData == AuthData.signup) {
      Provider.of<Auth>(context, listen: false).signup(
        _userData['email'],
        _userData['password'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceOffset = MediaQuery.of(context);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: deviceOffset.size.width * 0.75,
        height: _authData == AuthData.login ? 260 : 320.0,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: _userData['email'],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userData = {
                      'email': value,
                      'password': _userData['password'],
                    };
                  },
                ),
                TextFormField(
                  // initialValue: _userData['password'],
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: _authData == AuthData.signup
                      ? TextInputAction.next
                      : TextInputAction.done,
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context).requestFocus(_confirmFocusNode);
                  // },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length <= 6) {
                      return 'Too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userData = {
                      'email': _userData['email'],
                      'password': value,
                    };
                  },
                ),
                if (_authData == AuthData.signup)
                  TextFormField(
                    // focusNode: _confirmFocusNode,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please re-enter password';
                      }
                      if (value != _confirmController.text) {
                        return 'Password do not matching';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20.0),
                RaisedButton(
                  onPressed: _saveForm,
                  child: _authData == AuthData.login
                      ? Text('LOGIN')
                      : Text('SIGN UP'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  elevation: 8.0,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 40.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if (_authData == AuthData.signup) {
                      setState(() {
                        _authData = AuthData.login;
                      });
                    } else {
                      setState(() {
                        _authData = AuthData.signup;
                      });
                    }
                  },
                  child: _authData == AuthData.signup
                      ? Text('LOGIN INSTEAD')
                      : Text('SIGNUP INSTEAD'),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
