import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/presentation/theme/color_schemes_g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';

import 'presentation/screens/topic/screen_topic.dart';

void main() {
  initializeInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme,fontFamily: GoogleFonts.poppins().fontFamily),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme,fontFamily: GoogleFonts.poppins().fontFamily),
      home: kIsWeb ?const Center(
          child: SizedBox(
            width: 800,
            child: ScreenTopic(id: "anin-fotografi--6459985",))) : const ScreenTopic(id: "anin-fotografi--6459985",),
    );
  }
}
