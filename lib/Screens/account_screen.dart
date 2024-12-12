import 'package:fl_test/Screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Const/shared_preferences.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

//load data from shared prefrence
  Future<Map<String, String?>> _getUserData() async {
    final name = await Store.getName();
    final position = await Store.getPosition();
    final image = await Store.getImage();
    final task = await Store.get_no_of_task();
    final percentage = await Store.getpercentage();

    return {
      'name': name,
      'position': position,
      'image': image,
      'task': task,
      'percentage': percentage,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading user data'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No user data available'),
          );
        }

        final userData = snapshot.data!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                content: const Text(
                                  'Do you want to Logout ?',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('No',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Store.clear();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return LoginPage();
                                        },
                                      ));
                                    },
                                    child: Text(
                                      'Yes',
                                      style:
                                          TextStyle(color: Colors.red.shade900),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, bottom: 15, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                CircleAvatar(
                  radius: 90,
                  backgroundColor:
                      Colors.blue, // Replace with your button color
                  child: Center(
                    child: CircleAvatar(
                      radius: 87,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.white,
                          backgroundImage: userData['image'] != null
                              ? NetworkImage(userData['image']!)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userData['name'] ?? 'Unknown Name',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  userData['position'] ?? 'Unknown Position',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade800),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Tasks",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              userData['task'] ?? '0',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.black,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Percentage",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              '${userData['percentage'] ?? '0'}%',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors
                                      .blue), // Replace with your button color
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
