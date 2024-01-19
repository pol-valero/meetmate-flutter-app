
import 'package:flutter/material.dart';
import 'package:meet_mate/views/open_chat.dart';

import '../entities/user_data.dart';

class ChatListContainer extends StatelessWidget {

  final UserData userData;
  const ChatListContainer({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xffe87e70),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xffe87e70),
                borderRadius: BorderRadius.circular(10),
              ),
              child: userData.profileImage,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OpenChatView(userData: userData),
                    ),
                  );
      },
    );
  }
}
