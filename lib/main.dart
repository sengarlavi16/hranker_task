import 'package:flutter/material.dart';
import 'package:hranker_task/slot_machine/slot_machine_view.dart';

void main() {
  runApp(const SlotApp());
}

class SlotApp extends StatelessWidget {
  const SlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SlotMachineView(),
    );
  }
}
