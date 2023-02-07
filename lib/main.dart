import 'package:database_intro/model/user.dart';
import 'package:database_intro/util/database_helper.dart';
import "package:flutter/material.dart";

List _users = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseHelper();

  //Add User:
  // int saveUser = await db.saveUser(User(3, "Vipul", "123"));
  // print("User saved : $saveUser");

  //Delete User:
  // int userDelete = await db.deleteUser(2);
  // print("Deleted user : $userDelete");

  //Update User:
  User vipulUpdated =
      User.fromMap({"id": 3, "username": "Vipul", "password": "u123"});
  await db.updateUser(vipulUpdated);

  // Get all Users:
  _users = await db.getAllUsers();
  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);
    print("Username : ${user.userName}");
  }

  //Get Count:
  int? count = await db.getCount();
  print("Number of User : $count");

  //Get single user:
  User? pradip = await db.getUser(3);
  print("Got User : ${pradip!.id} ${pradip.userName} ${pradip.password}");

  runApp(
    const MaterialApp(
      title: "Database",
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                    User.fromMap(_users[position]).userName.substring(0, 1)),
              ),
              title: Text(User.fromMap(_users[position]).userName),
              subtitle: Text("Id : ${User.fromMap(_users[position]).id}"),
              onTap: () {
                var alert = AlertDialog(
                  title: const Text("Details"),
                  content: Text(
                      "Password : ${User.fromMap(_users[position]).password}"),
                  actions: [
                    ElevatedButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
                showDialog(context: context, builder: (context) => alert);
              },
            ),
          );
        },
      ),
    );
  }
}
