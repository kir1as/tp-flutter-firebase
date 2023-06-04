import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/posts_data_source.dart';
import 'package:tp_flutter_firebase/home_screen/models/post.dart';

class FirestorePostsDataSource extends PostsDataSource {
  final postsCollection = FirebaseFirestore.instance.collection('posts');

  final StreamController<List<Post>> postStreamController =
      StreamController<List<Post>>.broadcast();

  Stream<List<Post>> getPostsByStream() {
    postsCollection.orderBy('title').snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final posts = snapshot.docs.map((doc) => Post.fromJson(doc.data(), doc.id)).toList();
        postStreamController.add(posts);
      }
    });

    return postStreamController.stream;
  }

  @override
  Future<void> addPost(Post post) async {
    try {
      await postsCollection
          .add({'title': post.title, 'description': post.description});
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final posts = await postsCollection.get();
      debugPrint("HERE");
      return posts.docs.map((doc) => Post.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updatePost(Post oldPost, Post newPost) async{
    try {
      await postsCollection.doc(oldPost.id).update({
        'title': newPost.title,
        'description': newPost.description,
      });

    } catch (e) {
      debugPrint('Error: $e');
      throw Exception(e.toString());
    }
  }
}
