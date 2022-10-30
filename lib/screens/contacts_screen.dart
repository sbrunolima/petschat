import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

//Here all screens
import '../screens/chat_screen.dart';

//Here all files
import '../providers/users_providers.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact-screen';

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  var userName = '';
  var userImage = '';
  var userID = '';

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
      userID = currentUser!.uid.toString();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()!['username'].toString();
        userImage = value.data()!['user_image'].toString();

        setState(() {
          _isLoading = false;
        });
      });
    });

    Provider.of<UsersProvider>(context, listen: false).getDataFromID();
  }

  @override
  Widget build(BuildContext context) {
    //final users = getUsers();
    final users = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const Border(bottom: BorderSide(color: Colors.grey)),
            backgroundColor: Colors.indigo,
            collapsedHeight: 60,
            floating: true,
            pinned: true,
            title: _isLoading
                ? const CircularProgressIndicator(color: Colors.orangeAccent)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.orange.shade100, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.network(
                          userImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Au-suário:',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.orangeAccent),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
            actions: [
              DropdownButton(
                iconDisabledColor: Colors.white,
                iconEnabledColor: Colors.white,
                underline: Container(),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('Sair'),
                        ],
                      ),
                    ),
                    value: 'logout',
                  ),
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
                icon: const Icon(Icons.more_vert),
              ),
              const SizedBox(width: 17),
            ],
          ),
          SliverToBoxAdapter(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.user.length,
                      itemBuilder: (ctx, i) => currentUser!.uid !=
                              users.user[i].id
                          ? GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pushNamed(
                                    ChatScreen.routeName,
                                    arguments: users.user[i].id.toString());
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    ListTile(
                                      leading: CircleAvatar(
                                        maxRadius: 26,
                                        backgroundImage: NetworkImage(
                                            users.user[i].userImage.toString()),
                                      ),
                                      title: Text(
                                        users.user[i].name.toString(),
                                      ),
                                      subtitle: Text(
                                        'User ID: ${users.user[i].id.toString()}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Center(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<UsersProvider>(context, listen: false)
                            .getDataFromID();
                      },
                      child: const Text('Load User Data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
