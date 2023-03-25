import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_budget_app/screens/setup_screen.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/authentication_service.dart';
import '../utils/user_service.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              const Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _signInWithEmailAndPassword();
                                  }
                                },
                                child: Text('Sign In'),
                              ),
                            ),
                      SizedBox(height: 20),
                      _isLoading
                          ? SizedBox()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _signInWithGoogle,
                                icon: Icon(Icons.mail),
                                label: Text('Sign in with Google'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((user) {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }).onError((error, stackTrace) {
        if (error is FirebaseAuthException) {
          setState(() {
            _isLoading = false;
          });
          if (error.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No user found for that email.'),
              ),
            );
          } else if (error.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong password provided for that user.'),
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        }
      });
    }
  }

  void _signInWithGoogle() {
    setState(() {
      _isLoading = true;
    });

    signInWithGoogle().then((user) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user);
      checkIfUserSetupIsCompleted(user!).then((value) {
        value == true
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              )
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()));
      });
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    });
  }
}
