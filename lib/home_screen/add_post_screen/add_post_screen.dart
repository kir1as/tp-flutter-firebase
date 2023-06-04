import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/post.dart';
import '../posts_bloc/posts_bloc.dart';

class AddPostScreen extends StatelessWidget {
  static const routeName = '/add-post';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
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
                    final postBloc = BlocProvider.of<PostsBloc>(context);
                    postBloc.add(AddPost(
                        Post(title: title, description: description, id: '')));
                  }
                },
                label: const Text('Add Post'),
                icon: const Icon(Icons.add),
              );
            case PostsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostsStatus.addedSuccess:
              return FloatingActionButton.extended(
                onPressed: () {},
                label: const Text('Post Added'),
                icon: const Icon(Icons.check),
                backgroundColor: Colors.green,
              );
            case PostsStatus.error:
              return FloatingActionButton.extended(
                onPressed: () {},
                label: Text('Error ${state.error}'),
                icon: const Icon(Icons.error),
                backgroundColor: Colors.red,
              );
            default:
              return FloatingActionButton.extended(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  if (title != '' && description != '') {
                    final postBloc = BlocProvider.of<PostsBloc>(context);
                    postBloc.add(AddPost(
                        Post(title: title, description: description, id: '')));
                  }
                },
                label: const Text('Add Post'),
                icon: const Icon(Icons.add),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
