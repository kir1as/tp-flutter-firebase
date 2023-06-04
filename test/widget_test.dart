// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/firestore_posts_data_source.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/posts_data_source.dart';
import 'package:tp_flutter_firebase/home_screen/home_screen.dart';
import 'package:tp_flutter_firebase/home_screen/models/post.dart';
import 'package:tp_flutter_firebase/home_screen/posts_bloc/posts_bloc.dart';
import 'package:tp_flutter_firebase/home_screen/repository/posts_repository.dart';

import 'package:tp_flutter_firebase/main.dart';

class EmptyRemoteDataSource extends FirestorePostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Future<void> addPost(Post post) {
    return Future.value();
  }

  @override
  Future<void> updatePost(Post oldPost, Post newPost) {
    return Future.value();
  }
}

void main() {
  testWidgets('Posts Screen with success', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        RepositoryProvider(
          create: (context) => PostsRepository(
            firestoreDataSource: EmptyRemoteDataSource(), localDataSource: EmptyRemoteDataSource(),
          ),
          child: BlocProvider(
            create: (context) => PostsBloc(),
            child: const MaterialApp(
              home: HomeScreen(),
            )
          ),
        ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.text("No posts"), findsOneWidget);





  });
}
