import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screen_form.dart';
import 'providers/score_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
      ],
      child: MaterialApp(
        title: 'Clean Train Station Inspection',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        home: ScoreFormScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
