import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/MoreButton.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorListInlineItem.dart';
import 'package:march_tales_app/features/Track/widgets/AuthorListItem.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class AuthorsList extends StatefulWidget {
  const AuthorsList({
    super.key,
    required this.authors,
    required this.count,
    this.isLoading = false,
    this.useScrollController = false,
    this.onRefresh,
    this.onLoadNext,
  });

  final List<Author> authors;
  final int count;
  final bool isLoading;
  final bool useScrollController;
  final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;

  @override
  State<AuthorsList> createState() => AuthorsListState();
}

class AuthorsListState extends State<AuthorsList> {
  late AppState _appState;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    if (this.widget.useScrollController) {
      Future.delayed(Duration.zero, () {
        this._appState.addScrollController(this.scrollController);
      });
    }
  }

  @override
  void dispose() {
    if (this.widget.useScrollController) {
      Future.delayed(Duration.zero, () {
        this._appState.removeScrollController(this.scrollController);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final keyId = 'AuthorsList';

    return RefreshIndicator(
      color: appColors.brandColor,
      strokeWidth: 2,
      onRefresh: () async {
        if (this.widget.onRefresh != null) {
          await this.widget.onRefresh!();
        }
      },
      child: AuthorsListView(
        keyId: keyId,
        authors: this.widget.authors,
        count: this.widget.count,
        isLoading: this.widget.isLoading,
        useScrollController: this.widget.useScrollController,
        scrollController: this.widget.useScrollController ? this.scrollController : null,
        onRefresh: this.widget.onRefresh,
        onLoadNext: this.widget.onLoadNext,
      ),
    );
  }
}

class AuthorsListView extends StatelessWidget {
  final List<Author> authors;
  final String? keyId;

  /// Total available author count
  final int count;
  final bool isLoading;
  final bool useScrollController;
  final ScrollController? scrollController;
  final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;

  const AuthorsListView({
    super.key,
    this.keyId,
    required this.authors,
    required this.count,
    required this.isLoading,
    this.useScrollController = false,
    this.scrollController,
    this.onRefresh,
    this.onLoadNext,
  });

  @override
  Widget build(BuildContext context) {
    final authorsCount = this.authors.length;
    final hasMoreAuthors = this.count > authorsCount;
    final showItems = hasMoreAuthors ? authorsCount + 1 : authorsCount;

    final resolvedKeyId = this.keyId ?? 'AuthorsList';
    final listKey = PageStorageKey<String>(resolvedKeyId);

    return ListView.separated(
      key: listKey,
      // scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      controller: this.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      separatorBuilder: (context, index) => SizedBox(height: 15),
      itemCount: showItems,
      itemBuilder: (context, i) {
        if (i == authorsCount) {
          return MoreButton(onLoadNext: this.onLoadNext, isLoading: this.isLoading);
        } else {
          return AuthorListItem(author: this.authors[i], active: true);
        }
      },
    );
  }
}
