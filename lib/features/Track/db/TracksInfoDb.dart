import 'dart:async';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:sqlite_schema_upgrader/sqlite_schema_upgrader.dart';

import 'TracksInfoDbStructure.dart';
import 'TrackInfo.dart';

/// It manages sqlite database connection.
class TracksInfoDb {
  late Database db;

  // final sqliteSchema = SQLiteSchema();

  /// Initializes and returns sqlite database connection.
  Future<Database> initializeDB() async {
    final dbPath = await getDatabasesPath();
    final dbFile = join(dbPath, 'tracks-info.db');
    final createCommand = getTracksInfoDbCreateCommand();

    this.db = await openDatabase(
      version: tracksInfoDbVersion,
      dbFile,
      // singleInstance: true,
      onCreate: (database, version) async {
        logger.t('[TracksInfoDb] onCreate: Start: database=${database}');
        try {
          final batch = database.batch();
          batch.execute('DROP TABLE IF EXISTS ${tracksInfoDbName}');
          batch.execute(createCommand);
          await batch.commit();
        } catch (err) {
          logger.e('[TracksInfoDb] onCreate: Error: ${err}');
          debugger();
        }
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        logger.t('[TracksInfoDb] onUpgrade: Start: database=${database}');
        try {
          final batch = database.batch();
          if (oldVersion < 3) {
            // Add forgotten `lastUpdatedMs`
            batch.execute(
                'ALTER TABLE ${tracksInfoDbName} ADD lastUpdatedMs INTEGER');
          }
          await batch.commit();
        } catch (err) {
          logger.e('[TracksInfoDb] onUpgrade: Error: ${err}');
          debugger();
        }
      },
      // onConfigure: (database) async {
      //   logger.t('[TracksInfoDb] onConfigure: Start: database=${database}');
      // },
      // onOpen: (database) async {
      //   logger.t('[TracksInfoDb] onOpen: Start: database=${database}');
      // },
    );
    return this.db;
  }

  Future<int> insertTrackInfo(TrackInfo trackInfo) async {
    return await this.db.insert(
          tracksInfoDbName,
          trackInfo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
  }

  Future<List<TrackInfo>> getTrackInfoList() async {
    // Query the table for all the trackInfos.
    final List<Map<String, Object?>> trackInfoMaps =
        await this.db.query(tracksInfoDbName);

    // Convert the list of each trackInfo's fields into a list of `TrackInfo` objects.
    return [
      for (final item in trackInfoMaps) TrackInfo.fromMap(item),
    ];
  }
}

final tracksInfoDb = TracksInfoDb();
