import 'package:flutter/material.dart';
import 'tab_chat.dart';
import 'tab_profile.dart';

class TabManager extends StatefulWidget {
  final String uid;
  const TabManager({Key? key, required this.uid}) : super(key: key);

  @override
  State<TabManager> createState() => _TabManagerState(uid: uid);

}

class _TabManagerState extends State<TabManager> {
  int tabIndex = ;
  final String uid;
  late List<Widget> viewToLoad;

  _TabManagerState({required this.uid});

  @override
  void initState() {
    super.initState();
    viewToLoad = [
      TabProfileView(uid: uid, editProfileMode: true),
      const TabChatView(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: viewToLoad.elementAt(tabIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        currentIndex: tabIndex,
        onTap: tabClicked,
      ),
    );
  }

  void tabClicked(int index) {
    setState(() {
      tabIndex = index;
    });
  }
}