import 'package:daya_lima_test/providers/add_film_model.dart';
import 'package:daya_lima_test/providers/film_model.dart';
import 'package:daya_lima_test/screens/add_new_movie_screen.dart';
import 'package:daya_lima_test/screens/home_screen.dart';
import 'package:daya_lima_test/screens/movie_detail_screen.dart';
import 'package:daya_lima_test/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FilmProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddFilmProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daya Lima',
        theme: ThemeData(
          primarySwatch: myPrimaryColor,
          accentColor: Colors.blueGrey,
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
                settings: settings,
              );
            case MovieDetailScreen.routeName:
              final Map<String, dynamic> args =
                  settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (BuildContext context) => MovieDetailScreen(
                  title: args['title'],
                  description: args['description'],
                  poster: args['poster'],
                  createdBy: args['created_by'],
                  createdDate: args['created_date'],
                ),
                settings: settings,
              );
            case AddMovieScreen.routeName:
              return MaterialPageRoute(
                builder: (BuildContext context) => AddMovieScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
