import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Here all files
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  FirebaseFirestore? _instance;

  List<Users> _user = [];

  List<Users> get user {
    return [..._user];
  }

  Future<void> getDataFromID() async {
    _instance = FirebaseFirestore.instance;

    _instance!.collection('users').get().then((value) {
      value.docs.forEach((result) {
        _instance!.collection('users').doc(result.id).get().then(
              (data) => {
                _user.add(
                  Users(
                    id: result.id.toString(),
                    name: data.data()!['username'],
                    userImage: data.data()!['user_image'],
                  ),
                )
              },
            );
      });
    });

    notifyListeners();
  }

  Future<void> clear() async {
    user.clear();
    notifyListeners();
  }
}
