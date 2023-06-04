import 'package:flutter/material.dart';
import 'package:tp_flutter_firebase/home_screen/data_sources/posts_data_source.dart';
import '../models/post.dart';

class LocalPostsDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async{
    debugPrint('Getting posts from local data source');
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(
      [
        Post(
          id: '1',
          title: 'Post 1',
          description: 'Post 1 body',
        ),
        Post(
          id: '2',
          title: 'Post 2',
          description: 'Post 2 body',
        ),
        Post(
          id: '3',
          title: 'Post 3',
          description: 'Post 3 body',
        ),
      ],
    );
  }

  @override
  Future<void> addPost(Post post) async{
    debugPrint('Adding post to local data source');
    await Future.delayed(const Duration(seconds: 2));
    return Future.value();
  }

  @override
  Future<void> updatePost(Post oldPost, Post newPost) async{
    debugPrint('Updating post in local data source');
    await Future.delayed(const Duration(seconds: 2));
    return Future.value();
  }

}
