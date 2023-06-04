import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter_firebase/home_screen/home_screen.dart';
import 'package:tp_flutter_firebase/home_screen/posts_bloc/posts_bloc.dart';

import 'firebase_options.dart';
import 'home_screen/add_post_screen/add_post_screen.dart';
import 'home_screen/models/post.dart';
import 'home_screen/post_info_screen/post_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          AddPostScreen.routeName: (context) => AddPostScreen(),
        },
        onGenerateRoute: (settings) {
          Widget content = const SizedBox.shrink();

          switch (settings.name) {
            case PostInfoScreen.routeName:
              final arguments = settings.arguments;
              if (arguments is Post) {
                content = PostInfoScreen(post: arguments);
              }
              break;
          }

          return MaterialPageRoute(
            builder: (context) {
              return content;
            },
          );
        },
      ),
    );
  }
}
