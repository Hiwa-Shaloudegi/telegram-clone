import 'package:flutter/material.dart';

// TODO: Organize this file
Future<void> showDateSearch(BuildContext context) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );
  // if (picked == null || !mounted) return;

  // await Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (_) => DateSearchPage(
  //       chatId: chatInfo.chatId,
  //       chatTitle: chatInfo.displayTitle,
  //       date: picked,
  //     ),
  //   ),
  // );
}
