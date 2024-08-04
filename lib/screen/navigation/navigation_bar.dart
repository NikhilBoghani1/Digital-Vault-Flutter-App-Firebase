import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/add_bank_details/bank_account_screen.dart';
import 'package:digital_vault/screen/credit_card/credit_card_screen.dart';
import 'package:digital_vault/screen/debit_card/debit_card_screen.dart';
import 'package:digital_vault/screen/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationBarView extends StatefulWidget {
  const NavigationBarView({super.key});

  @override
  State<NavigationBarView> createState() => _NavigationBarViewState();
}

class _NavigationBarViewState extends State<NavigationBarView> {
  int _selectedIndex = 0;

  // Screens for the navigation
  List<Widget> _screens = [
    HomeScreen(),
    Center(
      child: Text('Current Screen (Add options shown in bottom sheet here)'),
    ),
    Center(child: Text('Profile Screen')),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      _showAddOptions();
    } else {
      // Change the selected index for other tabs
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 190,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: CupertinoColors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Bank Details",
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Get.off(BankAccountScreen(),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.downToUp);
                              print('Add Bank Details');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemYellow
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Image(
                                width: 33,
                                height: 33,
                                image: AssetImage(
                                  "assets/images/bank.png",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Bank",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Get.off(CreditCardScreen(),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.downToUp);
                              print('Add Bank Details');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    CupertinoColors.activeBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Image(
                                width: 35,
                                height: 35,
                                image: AssetImage(
                                  "assets/images/creadit.png",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Creadit Card",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Get.off(DebitCardScreen(),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.downToUp);
                              print('Add Bank Details');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeGreen
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Image(
                                width: 35,
                                height: 35,
                                image: AssetImage(
                                  "assets/images/debit.png",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Debit Card",
                            style: TextStyle(
                              fontFamily: myConstants.RobotoR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        // return Container(
        //   height: 230,
        //   child: Column(
        //     children: [
        //       SizedBox(height: 20),
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.white70,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         margin: EdgeInsets.symmetric(horizontal: 10),
        //         child: ListTile(
        //           leading: Icon(Icons.code),
        //           title: Text('Add Bank Details'),
        //           onTap: () {
        //             // Handle Add Code action
        //             Get.off(BankAccountScreen(),
        //                 transition: Transition.downToUp);
        //             print('Add Code tapped');
        //           },
        //         ),
        //       ),
        //       SizedBox(height: 13),
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.white70,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         margin: EdgeInsets.symmetric(horizontal: 10),
        //         child: ListTile(
        //           leading: Icon(Icons.code),
        //           title: Text('Add Code'),
        //           onTap: () {
        //             // Handle Add Code action
        //             Navigator.pop(context); // Close the bottom sheet
        //             print('Add Code tapped');
        //           },
        //         ),
        //       ),
        //       SizedBox(height: 13),
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.white70,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         margin: EdgeInsets.symmetric(horizontal: 10),
        //         child: ListTile(
        //           leading: Icon(Icons.code),
        //           title: Text('Add Code'),
        //           onTap: () {
        //             // Handle Add Code action
        //             Navigator.pop(context); // Close the bottom sheet
        //             print('Add Code tapped');
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  Constants myConstants = Constants();

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              activeIcon: Image.asset(
                color: CupertinoColors.systemIndigo,
                "assets/images/home.png",
                width: 25,
                height: 23,
              ),
              icon: Image.asset(
                "assets/images/home.png",
                width: 25,
                height: 23,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Add',
              activeIcon: Image.asset(
                color: CupertinoColors.systemIndigo,
                "assets/images/add.png",
              ),
              icon: Image.asset(
                "assets/images/add.png",
                width: 25,
                height: 23,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              activeIcon: Image.asset(
                width: 25,
                height: 23,
                color: CupertinoColors.systemIndigo,
                "assets/images/account.png",
              ),
              icon: Image.asset(
                "assets/images/account.png",
                width: 25,
                height: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
