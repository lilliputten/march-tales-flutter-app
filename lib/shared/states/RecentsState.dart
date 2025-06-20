import 'dart:async';
import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadRecents.dart';
import 'RecentsState.i18n.dart';

final logger = Logger();

mixin RecentsState {
  void notifyListeners();

  late Future<RecentResults> recentsFuture;
  late RecentResults? recentData;

  Future<RecentResults> _loadRecentsFuture() async {
    try {
      /* // DEBUG
       * if (AppConfig.LOCAL) {
       *   await Future.delayed(Duration(seconds: 2));
       * }
       * throw new Exception('Test error');
       */
      final data = await loadRecents();
      // logger.t('[_loadRecentsFuture] recentTracks=${data.recentTracks} popularTracks=${data.popularTracks} mostRecentTrack=${data.mostRecentTrack} randomTrack=${data.randomTrack}');
      this.recentData = data;
      this.notifyListeners();
      return data;
    } catch (err, stacktrace) {
      final String msg = 'Error loading recent data.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      debugger();
      this.recentData = null;
      final translatedMsg = msg.i18n;
      // showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  Future<RecentResults> loadRecentsData() {
    this.recentsFuture = this._loadRecentsFuture();
    this.notifyListeners();
    return this.recentsFuture;
  }

  Future<RecentResults> reloadRecentsData({bool notify = true}) async {
    // XXX: Reset data?
    final results = await loadRecentsData();
    if (notify) {
      notifyListeners();
    }
    return results;
  }
}
