import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';
import 'package:image_editing_app/screens/home_screen.dart';
import 'package:image_editing_app/screens/editor_screen.dart';
import 'package:image_editing_app/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ImageBloc()),
      ],
      child: MaterialApp(
        title: 'Image Editor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/editor': (context) => const EditorScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}