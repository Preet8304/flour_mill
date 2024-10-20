import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flour_mill/Screens/ProfileScreen.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(100, 184, 176, 176),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: const Icon(CupertinoIcons.bars),
            ),
          ),
          InkWell(borderRadius: BorderRadius.circular(30),
            onTap: () {},

                child: IconButton(
                  icon: const Icon(Icons.account_circle,size: 30,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    )),

        ],
      ),
    );
  }
}
