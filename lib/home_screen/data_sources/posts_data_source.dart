import '../models/post.dart';

abstract class PostsDataSource {
  Future<List<Post>> getPosts();

  Future<void> addPost(Post post);

  Future<void> updatePost(Post oldPost, Post newPost);
}