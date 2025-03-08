import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/BottomNavigation.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

final playerBoxKey = GlobalKey<PlayerBoxState>();

final logger = Logger();

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIndex = appState.getNavigationTabIndex();

    appState.playerBoxKey = playerBoxKey;

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;

    final homePages = getHomePages();

    final navigator = Navigator.of(context);
    final routeName = ModalRoute.of(context)?.settings.name;
    final isRoot = routeName == null || routeName.isEmpty || routeName == '/';
    logger.t('[PageWrapper] isRoot=${isRoot} routeName=${routeName} navigator=${navigator} Navigator=${Navigator}');

    return RestorationScope(
      restorationId: 'PageWrapper',
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 15,
          backgroundColor: appColors.brandColor,
          foregroundColor: appColors.onBrandColor,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              spacing: 10,
              children: [
                // TODO: Add back button
                isRoot ? null : Text('X'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage('assets/images/march-cat/march-cat-sq-48.jpg'),
                  ),
                ),
                Text(
                  appTitle.i18n,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: style.copyWith(
                    fontFamily: 'Lobster',
                    fontSize: 28,
                    color: appColors.onBrandColor,
                  ),
                ),
              ].nonNulls.toList(),
            ),
          ),
          // actions?
        ),
        bottomNavigationBar: BottomNavigation(
          homePages: homePages,
          selectedIndex: selectedIndex,
          handleIndex: (int value) {
            appState.updateNavigationTabIndex(value);
            // Navigator.pushNamed(context, '/');
            Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
          },
        ),
        // bottomSheet: Text('bottomSheet'),
        // endDrawer: AppDrawer(), // XXX FUTURE: Side navigation panel, see `AppDrawer`
        body: LayoutBuilder(
          builder: (context, constraints) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            return Column(
              children: [
                // TopMenuBox(),
                Expanded(
                  child: ColoredBox(color: colorScheme.surfaceContainerHighest, child: child),
                ),
                PlayerBox(
                  key: playerBoxKey,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
