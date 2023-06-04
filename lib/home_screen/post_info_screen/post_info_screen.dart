import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/post.dart';
import '../posts_bloc/posts_bloc.dart';

class PostInfoScreen extends StatelessWidget {
  static const routeName = '/post-info';
  final Post post;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  static void navigateTo(BuildContext context, Post post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  PostInfoScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    titleController.text = post.title;
    descriptionController.text = post.description;
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    hintText: 'Enter title',
                  ),
                  controller: titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'Enter description',
                  ),
                  controller: descriptionController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostsStatus.initial:
              return FloatingActionButton.extended(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  if (title != '' && description != '') {
                    debugPrint("hi");
                    final postBloc = BlocProvider.of<PostsBloc>(context);
                    postBloc.add(UpdatePost(
                        post, Post(id: post.id ,title: title, description: description)));
                  }
                },
                label: const Text('Update'),
                icon: const Icon(Icons.update),
              );
            case PostsStatus.loading:
              return const CircularProgressIndicator();
            case PostsStatus.updatedSuccess:
              return FloatingActionButton.extended(
                onPressed: () {},
                label: const Text('Updated'),
                icon: const Icon(Icons.check),
                backgroundColor: Colors.green,
              );
            case PostsStatus.error:
              return FloatingActionButton.extended(
                onPressed: () {},
                label: Text('Error: ${state.error}'),
                icon: const Icon(Icons.error),
                backgroundColor: Colors.red,
              );
            default:
              return FloatingActionButton.extended(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  if (title != '' && description != '') {
                    debugPrint("hi");
                    final postBloc = BlocProvider.of<PostsBloc>(context);
                    postBloc.add(UpdatePost(
                        post, Post(id: post.id ,title: title, description: description)));
                  }
                },
                label: const Text('Update'),
                icon: const Icon(Icons.update),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
