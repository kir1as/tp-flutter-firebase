import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter_firebase/home_screen/add_post_screen/add_post_screen.dart';
import 'package:tp_flutter_firebase/home_screen/post_info_screen/post_info_screen.dart';
import 'package:tp_flutter_firebase/home_screen/posts_bloc/posts_bloc.dart';

import 'models/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostsBloc>(context).add(GetAllPosts());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostsStatus.initial:
              BlocProvider.of<PostsBloc>(context).add(GetAllPosts());
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostsStatus.success:
              final posts = state.posts;

              if (posts.isEmpty) {
                return const Center(
                  child: Text('No posts'),
                );
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(posts[index].title),
                      subtitle: Text(
                        posts[index].description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _onPostTap(context, posts[index]),
                    ),
                  );
                },
              );

            case PostsStatus.error:
              return Center(
                child: Text('Error: ${state.error}'),
              );
            default:
              return const Center(
                child: Text('Something went wrong'),
              );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddPostTap(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddPostTap(BuildContext context) {
    AddPostScreen.navigateTo(context);
  }

  void _onPostTap(BuildContext context, Post post) {
    PostInfoScreen.navigateTo(context, post);
  }
}
