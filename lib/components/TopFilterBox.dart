import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/HidableWrapper.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'TopFilterBox.i18n.dart';

final logger = Logger();

class TopFilterBox extends StatefulWidget {
  const TopFilterBox({
    super.key,
  });

  @override
  State<TopFilterBox> createState() => TopFilterBoxState();
}

const double inputBorderRadius = 10;
const double inputBorderWidth = 1;

class TopFilterBoxState extends State<TopFilterBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    final searchValue = appState.getFilterSearch();
    this._controller = new TextEditingController(text: searchValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final baseStyle = theme.textTheme.bodyMedium!;
    final textStyle = baseStyle.copyWith(color: appColors.onBrandColor);
    final hintStyle = baseStyle.copyWith(color: appColors.onBrandColor.withValues(alpha: 0.5));

    final pageIndex = appState.getNavigationTabIndex();
    final isTracksPage = pageIndex == HomePages.root.index;
    final isPlayingAndNotPaused = appState.isPlayingAndNotPaused();

    final searchValue = appState.getFilterSearch();
    final hasValue = searchValue.isNotEmpty;

    return HidableWrapper(
      widgetSize: 80,
      // bypass: AppConfig.LOCAL,
      show: isTracksPage,
      wrap: !isPlayingAndNotPaused,
      child: ColoredBox(
        color: appColors.brandColor.withValues(alpha: 0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            children: [
              TextField(
                controller: this._controller,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Search tracks'.i18n,
                  labelStyle: hintStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
                    borderSide: BorderSide(color: appColors.onBrandColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
                    borderSide:
                        BorderSide(width: inputBorderWidth, color: appColors.onBrandColor.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
                    borderSide: BorderSide(width: inputBorderWidth, color: appColors.onBrandColor),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {
                      appState.applyFilters();
                    },
                    icon: Icon(
                      Icons.search,
                      color: appColors.onBrandColor,
                    ),
                  ),
                  suffixIcon: hasValue
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            appState.setFilterSearch('');
                            // appState.applyFilters();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: appColors.onBrandColor,
                          ),
                        )
                      : null,
                ),
                onSubmitted: (String value) {
                  logger.t('[TopFilterBox:onSubmitted] value=${value}');
                  appState.applyFilters();
                },
                onChanged: (String value) {
                  logger.t('[TopFilterBox:onChanged] value=${value}');
                  appState.setFilterSearch(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
