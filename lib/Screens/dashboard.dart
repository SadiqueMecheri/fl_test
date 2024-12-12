import 'package:fl_test/Screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Const/utils.dart';
import 'account_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                backgroundColor2,
                backgroundColor2,
                backgroundColor4,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          currentIndex == 0
                              ? const HomeScreen()
                              : const AccountScreen(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: Container(
                    height: 70,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: buttonColor),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: currentIndex == 0
                                      ? Colors.white
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, bottom: 12, left: 15, right: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/home.svg",
                                      color: currentIndex == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: currentIndex == 0
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: currentIndex == 1
                                      ? Colors.white
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, bottom: 12, left: 15, right: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/profle.svg",
                                      color: currentIndex == 1
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Account",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: currentIndex == 1
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Exit app dialog
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text(
              'Exit App',
              style: TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            content: const Text(
              'Do you want to exit an App?',
              style: TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
