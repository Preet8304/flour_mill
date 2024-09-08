import 'package:flour_mill/Widgets/AppbarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Widgets/FlourMillCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Appbarwidget(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
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
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(CupertinoIcons.search),
                    Container(
                      height: 50,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            hintText: "What would you like to have?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20)),
                    Flexible(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.filter_list,
                            ))),
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
              )),
          FlourMillCard(),
        ],

      ),
    );
  }
}
