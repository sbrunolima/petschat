import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

//Here all screens
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import './screens/contacts_screen.dart';

//Here all files
import './providers/users_providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UsersProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pets Chat',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent))
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return ContactScreen();
                  }
                  return AuthScreen();
                },
              ),
        routes: {
          ContactScreen.routeName: (ctx) => ContactScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
        },
      ),
    );
  }
}
