import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/exceptions/VersionException.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/convertErrorLikeToString.dart';
import 'AppErrorScreen.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.error,
  });
  final dynamic error;

  getIcon() {
    if (error is ConnectionException) {
      return Icons.offline_bolt;
    }
    if (error is VersionException) {
      return Icons.update; // tips_and_updates;
    }
    return Icons.error;
  }

  Widget getConnectionExceptionContent() {
    // XXX FUTURE: Dispaly a 'Retry' button to re-launch the app?
    return SelectableText(
      'Check the network connection and try again later.'.i18n,
      textAlign: TextAlign.center,
    );
  }

  Widget getVersionExceptionContent() {
    // XXX FUTURE: Dispaly a site and google play link buttons?
    return SelectableText(
      'Please update the app from the website or from Google Play.'.i18n,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = convertErrorLikeToString(error);

    final items = [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          this.getIcon(),
          color: Colors.red, // .withValues(alpha: 0.5),
          size: 100,
        ),
      ),
      SelectableText(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      error is ConnectionException ? this.getConnectionExceptionContent() : null,
      error is VersionException ? this.getVersionExceptionContent() : null,
    ].nonNulls.toList();

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15,
                children: items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
