import 'package:digital_vault/screen/add_bank_details/bank_account_screen.dart';
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
          height: 230,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Add Bank Details'),
                  onTap: () {
                    // Handle Add Code action
                    Get.off(BankAccountScreen(),
                        transition: Transition.downToUp);
                    print('Add Code tapped');
                  },
                ),
              ),
              SizedBox(height: 13),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Add Code'),
                  onTap: () {
                    // Handle Add Code action
                    Navigator.pop(context); // Close the bottom sheet
                    print('Add Code tapped');
                  },
                ),
              ),
              SizedBox(height: 13),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Add Code'),
                  onTap: () {
                    // Handle Add Code action
                    Navigator.pop(context); // Close the bottom sheet
                    print('Add Code tapped');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "assets/images/people.png",
              ),
              icon: Image.asset(
                "assets/images/people.png",
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
