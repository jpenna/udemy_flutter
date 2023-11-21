import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  String _inputUsername = '';
  String _inputEmail = '';
  String _inputPassword = '';
  File? _imageFile;
  bool _isAuthenticating = false;

  void _submit() async {
    if (!_form.currentState!.validate() || (!_isLogin && _imageFile == null)) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    try {
      String userId;
      if (_isLogin) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: _inputEmail,
          password: _inputPassword,
        );
        userId = userCredential.user!.uid;
      } else {
        final userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: _inputEmail,
          password: _inputPassword,
        );

        userId = userCredential.user!.uid;

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('$userId.jpg');

        await storageRef.putFile(_imageFile!);
        String imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': _inputUsername,
          'email': userCredential.user!.email,
          'imageUrl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Sign up failed.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (File file) {
                                _imageFile = file;
                              },
                            ),
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _inputEmail = newValue!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              key: const ValueKey('username'),
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              autocorrect: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Your username should have at least 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _inputUsername = newValue!;
                              },
                            ),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Your password should have at least 6 characters.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _inputPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(
                                _isLogin ? 'Login' : 'Signup',
                              ),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create an account'
                                    : 'I already have an account',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
