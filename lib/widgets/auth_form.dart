import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;

//Here all important files
import '../widgets/image_picker.dart';
import '../widgets/title_widget.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFunction, this.isLoading);

  final bool isLoading;

  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) submitFunction;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    setState(() {
      _isLogin = true;
    });
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _form.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, Selecione uma imagem.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (isValid) {
      _form.currentState!.save();
      widget.submitFunction(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile == null ? File('assets/profile.png') : _userImageFile!,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizedBox = const SizedBox(height: 20);
    return Center(
      child: Card(
        color: Colors.indigo,
        elevation: 0,
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleWidget(),
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          !value.toString().contains('@')) {
                        return 'Enter com um e-mail válido!';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value.toString();
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Au-mail',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  if (!_isLogin)
                    Column(
                      children: [
                        sizedBox,
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          key: const ValueKey('username'),
                          onSaved: (value) {
                            _userName = value.toString();
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white30,
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Nome do Au-suário',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  sizedBox,
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    key: const ValueKey('senha'),
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          value.toString().length < 8) {
                        return 'Entre com uma senha mais forte!';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value.toString();
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white30,
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Senha',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 17),
                  widget.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        )
                      : SizedBox(
                          height: 50,
                          width: 400,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              _trySubmit();
                            },
                            child: Text(
                              _isLogin ? 'Entrar' : 'Criar conta',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: 400,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orangeAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Criar nova conta' : "Já possuo uma conta",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
