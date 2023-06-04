import 'package:flutter/material.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/firestore_posts_data_source.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/posts_data_source.dart';

import '../models/post.dart';

class PostsRepository {
  final PostsDataSource localDataSource;
  final FirestorePostsDataSource firestoreDataSource;

  PostsRepository({
    required this.localDataSource,
    required this.firestoreDataSource,
  });

  Stream<List<Post>> getPostsByStream() {
    return firestoreDataSource.getPostsByStream();
  }

  Future<List<Post>> getPosts() async {
    try {
      final posts = await firestoreDataSource.getPosts();
      debugPrint("yes");
      return posts;
    } catch (e) {
      final posts = await localDataSource.getPosts();
      return posts;
    }
  }

  Future<void> addPost(Post post) async {
    try {
      await firestoreDataSource.addPost(post);
    } catch (e) {
      await localDataSource.addPost(post);
    }
  }

  Future<void> updatePost(Post oldPost, Post newPost) async {
    try {
      await firestoreDataSource.updatePost(oldPost, newPost);
      debugPrint("yes");
    } catch (e) {
      await localDataSource.updatePost(oldPost, newPost);
      debugPrint("no");
    }
  }
}