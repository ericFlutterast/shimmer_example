import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer_exampl/example/screens/shmmer_example_screen.dart';

void main() {
  runZonedGuarded(
    () => runApp(const MainApp()),
    (error, stack) {
      debugPrint('Произошла ошибка $error');
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShimmerExampleScreen(),
    );
  }
}
