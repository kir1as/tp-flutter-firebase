part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class GetAllPosts extends PostsEvent {
  GetAllPosts();
}

class AddPost extends PostsEvent {
  final Post post;

  AddPost(this.post);
}

class UpdatePost extends PostsEvent {
  final Post oldPost;
  final Post newPost;

  UpdatePost(this.oldPost, this.newPost);
}

