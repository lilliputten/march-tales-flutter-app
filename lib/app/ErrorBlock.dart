import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/exceptions/VersionException.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/convertErrorLikeToString.dart';
import 'ErrorBlock.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

class ErrorBlock extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;
  final bool large;

  const ErrorBlock({
    super.key,
    required this.error,
    this.onRetry,
    this.large = false,
  });

  getIcon() {
    if (error is ConnectionException) {
      return Icons.offline_bolt;
    }
    if (error is VersionException) {
      return Icons.update; // tips_and_updates;
    }
    return Icons.error;
  }

  _getTitleStyle() {
    return TextStyle(
      color: Colors.red,
      fontSize: this.large ? 20 : 16,
      fontWeight: FontWeight.bold,
    );
  }

  _getTextStyle() {
    return TextStyle(
      fontSize: this.large ? 14 : 12,
    );
  }

  Widget getConnectionExceptionContent() {
    // XXX FUTURE: Display a 'Retry' button to re-launch the app?
    return SelectableText(
      'Check the network connection and try again later.'.i18n,
      textAlign: TextAlign.center,
      style: this._getTextStyle(),
    );
  }

  Widget getVersionExceptionContent() {
    // XXX FUTURE: Display a site and google play link buttons?
    return SelectableText(
      'Please update the app from the website or from Google Play.'.i18n,
      textAlign: TextAlign.center,
      style: this._getTextStyle(),
    );
  }

  Widget retryButton(BuildContext context) {
    return TextButton.icon(
      onPressed: this.onRetry,
      icon: Icon(
        Icons.refresh,
      ),
      label: Text(
        'Retry'.i18n,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = convertErrorLikeToString(error);

    final double iconSize = this.large ? 80 : 40;
    final double spacing = this.large ? 15 : 10;

    final items = [
      Padding(
        padding: EdgeInsets.all(this.large ? 10 : 5),
        child: Icon(
          this.getIcon(),
          color: Colors.red, // .withValues(alpha: 0.5),
          size: iconSize,
        ),
      ),
      SelectableText(
        text,
        textAlign: TextAlign.center,
        style: this._getTitleStyle(),
      ),
      error is ConnectionException ? this.getConnectionExceptionContent() : null,
      error is VersionException ? this.getVersionExceptionContent() : null,
      onRetry != null ? this.retryButton(context) : null,
    ].nonNulls.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing,
      children: items,
    );
  }
}
