// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:developer';
import 'package:event/event.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'TracksInfoDbStructure.dart';
import 'TrackInfo.dart';

class TracksInfoDbUpdate extends EventArgs {
  TrackInfo trackInfo;
  TracksInfoDbUpdate(this.trackInfo);
}

/// It manages sqlite database connection.
class TracksInfoDb {
  late Database db;
  final Event<TracksInfoDbUpdate> updateEvents = Event<TracksInfoDbUpdate>();

  _createDatabase(Database database) async {
    final createCommand = getTracksInfoDbCreateCommand();
    try {
      final batch = database.batch();
      batch.execute('DROP TABLE IF EXISTS ${tracksInfoDbName}');
      batch.execute(createCommand);
      await batch.commit();
    } catch (err, stacktrace) {
      logger.e('[TracksInfoDb] onCreate: Error: ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
      rethrow;
    }
  }

  /// Initializes and returns sqlite database connection.
  Future<Database> initializeDB() async {
    final dbPath = await getDatabasesPath();
    final dbFile = join(dbPath, tracksInfoDbFileName);
    this.db = await openDatabase(
      version: tracksInfoDbVersion,
      dbFile,
      // singleInstance: true,
      onCreate: (Database database, int version) async {
        this._createDatabase(database);
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        // Just recreate the table from scratch
        this._createDatabase(database);
        /* // UNUSED: Manually update to the current version
         * try {
         *   if (oldVersion < 3) {
         *     // Add forgotten `lastUpdatedMs`
         *     batch.execute('ALTER TABLE ${tracksInfoDbName} ADD lastUpdatedMs INTEGER');
         *   }
         *   if (oldVersion < 4) {
         *     batch.execute('ALTER TABLE ${tracksInfoDbName} DROP COLUMN durationMs');
         *   }
         *   // etc...
         *   await batch.commit();
         * } catch (err, stacktrace) {
         *   logger.e('[TracksInfoDb] onUpgrade: Error: ${err}',
         *       error: err, stackTrace: stacktrace);
         *   debugger();
         *   rethrow;
         * }
         */
      },
      /* // UNUSED: Other handlers
       * onConfigure: (database) async {
       *   logger.t('[TracksInfoDb] onConfigure: Start: database=${database}');
       * },
       * onOpen: (database) async {
       *   logger.t('[TracksInfoDb] onOpen: Start: database=${database}');
       * },
       */
    );
    return this.db;
  }

  // End-user api

  Future<TrackInfo> incrementPlayedCount(int id, {DateTime? now}) async {
    try {
      final _now = now ??= DateTime.now();
      return this.db.transaction((txn) async {
        final trackInfo = await this.getOrCreate(id, txn: txn);
        trackInfo.playedCount += 1;
        trackInfo.lastPlayed = _now;
        trackInfo.lastUpdated = _now;
        final _ = await this.insert(trackInfo, txn: txn);
        this.updateEvents.broadcast(TracksInfoDbUpdate(trackInfo));
        return trackInfo;
      });
    } catch (err, stacktrace) {
      logger.e('[TracksInfoDb] incrementPlayedCount: Error: ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
      rethrow;
    }
  }

  Future<TrackInfo> updatePosition(int id,
      {Duration? position, DateTime? now}) async {
    try {
      final _now = now ??= DateTime.now();
      return this.db.transaction((txn) async {
        final trackInfo = await this.getOrCreate(id, txn: txn);
        // final newTrackInfo = TrackInfo.clone
        if (position != null) {
          trackInfo.position = position;
        }
        trackInfo.lastPlayed = _now; // ???
        trackInfo.lastUpdated = _now;
        final _ = await this.insert(trackInfo, txn: txn);
        this.updateEvents.broadcast(TracksInfoDbUpdate(trackInfo));
        return trackInfo;
      });
    } catch (err, stacktrace) {
      logger.e('[TracksInfoDb] updatePosition: Error: ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
      rethrow;
    }
  }

  Future<TrackInfo> save(int id, TrackInfo trackInfo, {DateTime? now}) async {
    try {
      final _now = now ??= DateTime.now();
      return this.db.transaction((txn) async {
        trackInfo.lastPlayed = _now; // ???
        trackInfo.lastUpdated = _now;
        final _ = await this.insert(trackInfo, txn: txn);
        this.updateEvents.broadcast(TracksInfoDbUpdate(trackInfo));
        // final testTrackInfo = await this.getById(id, txn: txn);
        return trackInfo;
      });
    } catch (err, stacktrace) {
      logger.e('[TracksInfoDb] updatePosition: Error: ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
      rethrow;
    }
  }

  // Low-level api

  TrackInfo createNewRecord(int id) {
    final now = DateTime.now();
    final TrackInfo trackInfo = TrackInfo(
      id: id, // track.id
      position: Duration.zero, // position
      playedCount: 0, // track.played_count (but only for current user!).
      lastUpdated: now, // DateTime.now()
      lastPlayed: now, // DateTime.now()
    );
    return trackInfo;
  }

  Future<TrackInfo> getOrCreate(int id, {Transaction? txn}) async {
    final trackInfo = await this.getById(id, txn: txn);
    return trackInfo ?? this.createNewRecord(id);
  }

  Future<List<TrackInfo>> get(int id, {Transaction? txn}) async {
    final _txn = txn ?? this.db;
    // Query the table for all the trackInfos.
    final List<Map<String, Object?>> trackInfoMaps =
        await _txn.query(tracksInfoDbName);
    // Convert the list of each trackInfo's fields into a list of `TrackInfo` objects.
    return [
      for (final item in trackInfoMaps) TrackInfo.fromMap(item),
    ];
  }

  /// Returns inserted/updated record id
  Future<int> insert(TrackInfo trackInfo, {Transaction? txn}) async {
    final _txn = txn ?? this.db;
    try {
      final data = trackInfo.toMap();
      return await _txn.insert(
        tracksInfoDbName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (err, stacktrace) {
      logger.e('[TracksInfoDb] insert: Error: ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
      rethrow;
    }
  }

  /// Returns updated records count
  Future<int> update(TrackInfo trackInfo, {Transaction? txn}) async {
    final _txn = txn ?? this.db;
    // Update the given TracksInfo.
    return await _txn.update(
      tracksInfoDbName,
      trackInfo.toMap(),
      // Ensure that the TracksInfo has a matching id.
      where: 'id = ?',
      // Pass the TracksInfo's id as a whereArg to prevent SQL injection.
      whereArgs: [trackInfo.id],
    );
  }

  Future<TrackInfo?> getById(int id, {Transaction? txn}) async {
    // final items1 = await db.rawQuery('SELECT * FROM ${tracksInfoDbName} WHERE id=? LIMIT 1', [id]);
    final _txn = txn ?? this.db;
    final items = await _txn.query(
      tracksInfoDbName,
      limit: 1,
      where: 'id= ?',
      whereArgs: [id],
    );
    return items.isNotEmpty ? TrackInfo.fromMap(items[0]) : null;
  }

  Future<List<TrackInfo>> getAll({Transaction? txn}) async {
    final _txn = txn ?? this.db;
    // Query the table for all the trackInfos.
    final List<Map<String, Object?>> trackInfoMaps =
        await _txn.query(tracksInfoDbName);
    // Convert the list of each trackInfo's fields into a list of `TrackInfo` objects.
    return [
      for (final item in trackInfoMaps) TrackInfo.fromMap(item),
    ];
  }

  Future<void> delete(int id, {Transaction? txn}) async {
    final _txn = txn ?? this.db;
    // Remove the TrackInfo from the database.
    await _txn.delete(
      tracksInfoDbName,
      // Use a `where` clause to delete a specific trackInfo.
      where: 'id = ?',
      // Pass the TrackInfo's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  clearAll({Transaction? txn}) async {
    final _txn = txn ?? this.db;
    return await _txn.rawDelete("DELETE FROM ${tracksInfoDbName}");
  }
}

// Create a singleton
final tracksInfoDb = new TracksInfoDb();
