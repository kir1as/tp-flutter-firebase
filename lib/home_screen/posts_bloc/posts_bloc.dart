import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../data_sources/firestore_posts_data_source.dart';
import '../data_sources/local_posts_data_source.dart';
import '../data_sources/posts_data_source.dart';
import '../models/post.dart';
import '../repository/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository = PostsRepository(localDataSource: LocalPostsDataSource(), firestoreDataSource: FirestorePostsDataSource());

  PostsBloc() : super(PostsState()) {

    on<GetAllPosts>((event, emit) async{
      emit(state.copyWith(status: PostsStatus.loading));

      await Future.delayed(const Duration(seconds: 2));

      try {

        final posts = postsRepository.getPostsByStream();
        await emit.forEach(posts, onData: (posts) {
          return state.copyWith(posts: posts, status: PostsStatus.success);
        });

        // emit(state.copyWith(
        //   status: PostsStatus.success,
        //   posts: posts,
        // ));
      } catch (error) {
        emit(state.copyWith(
          status: PostsStatus.error,
          error: error.toString(),
        ));
      }

    });

    on<AddPost>((event, emit) async{
      emit(state.copyWith(status: PostsStatus.loading));

      await Future.delayed(const Duration(seconds: 2));

      try {
        // final posts = state.posts;
        // posts.add(event.post);
        await postsRepository.addPost(event.post);

        emit(state.copyWith(
          status: PostsStatus.addedSuccess,
        ));

        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(status: PostsStatus.initial));

      } catch (error) {
        emit(state.copyWith(
          status: PostsStatus.error,
          error: error.toString(),
        ));

        await Future.delayed(const Duration(seconds: 3));
        emit(state.copyWith(status: PostsStatus.initial));
      }

    });

    on<UpdatePost>((event, emit) async{
      emit(state.copyWith(status: PostsStatus.loading));

      await Future.delayed(const Duration(seconds: 2));

      try {
        final posts = state.posts;
        debugPrint(event.oldPost.title);
        debugPrint(event.oldPost.id);
        //final index = posts.indexWhere((element) => element.id == event.oldPost.id);
        // if(posts.indexWhere((element) => element.title == event.newPost.title) != -1 && event.oldPost.title != event.newPost.title){
        //   emit(state.copyWith(
        //     status: PostsStatus.error,
        //     error: 'Post with title ${event.newPost.title} already exists',
        //   ));
        //   await Future.delayed(const Duration(seconds: 2));
        //   emit(state.copyWith(status: PostsStatus.initial));
        //   return;
        // }
        //posts[index] = event.newPost;
        await postsRepository.updatePost(event.oldPost, event.newPost);
        emit(state.copyWith(
          status: PostsStatus.updatedSuccess,
          posts: posts,
        ));

        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(status: PostsStatus.initial));

      } catch (error) {
        emit(state.copyWith(
          status: PostsStatus.error,
          error: error.toString(),
        ));

        await Future.delayed(const Duration(seconds: 3));
        emit(state.copyWith(status: PostsStatus.initial));
      }

    });

  }
}
