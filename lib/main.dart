import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NoteAp',
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}


