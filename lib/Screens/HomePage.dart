import 'package:flour_mill/Screens/OrderScreen.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Widgets/AppbarWidget.dart';
import 'package:flour_mill/Widgets/FlourMillCard.dart';
import 'package:flour_mill/model/flour_mill_data.dart'; // Import the data source
import 'package:flour_mill/Screens/OrderScreen.dart';
import 'package:flour_mill/Widgets/SideBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0; // Set the initial index to the first tab

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      HomeScreen(),
      const OrderScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title:const Text('Mill To Door'),),
      drawer: const SideBar(), // The sidebar is properly called here
      body: widgetList[myIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index; // Update the index when a tab is tapped
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}


// HomeScreen is the screen you created previously as HomePage
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flourMills = FlourMillData.getFlourMills(); // Fetch the list of flour mills

    return ListView(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(100, 184, 176, 176),
                  offset: Offset(0, 3),
                  spreadRadius: 2,
                  blurRadius: 10,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CupertinoIcons.search),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: "What would you like to have?",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text(
            "Mills",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ...flourMills
            .map((flourMill) => FlourMillCard(flourMill: flourMill))
            .toList(),
      ],
    );
  }
}
