import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/SectionTitle.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorsList.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'AuthorDetails.i18n.dart';

final logger = Logger();

class AuthorsListScreenView extends StatefulWidget {
  const AuthorsListScreenView({
    super.key,
    required this.authors,
    required this.count,
  });

  final List<Author> authors;
  final int count;

  @override
  State<AuthorsListScreenView> createState() => AuthorsListScreenViewState();
}

class AuthorsListScreenViewState extends State<AuthorsListScreenView> {
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 0,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SectionTitle(text: '${"All authors list".i18n} (${this.widget.authors.length})'),
          ),
          Expanded(
            child: AuthorsList(
              authors: this.widget.authors,
              count: this.widget.authors.length,
              active: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomBackButton(),
          ),
        ],
      ),
    );
  }
}
