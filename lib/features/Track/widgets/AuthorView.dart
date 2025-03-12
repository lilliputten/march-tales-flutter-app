import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorDetails.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

class AuthorView extends StatefulWidget {
  const AuthorView({
    super.key,
    required this.author,
  });

  final Author author;

  @override
  State<AuthorView> createState() => AuthorViewState();
}

class AuthorViewState extends State<AuthorView> {
  late AppState _appState;
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    Future.delayed(Duration.zero, () {
      this._appState.addScrollController(this.scrollController);
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      this._appState.removeScrollController(this.scrollController);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            restorationId: 'AuthorView-${this.widget.author.id}',
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AuthorDetails(author: this.widget.author, fullView: true),
            ),
          ),
        ),
      ],
    );
  }
}
