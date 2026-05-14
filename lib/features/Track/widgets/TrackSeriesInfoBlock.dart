import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Series.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'TrackSeriesInfoBlock.i18n.dart';

final logger = Logger();

class TrackSeriesInfoBlock extends StatefulWidget {
  final Track track;

  const TrackSeriesInfoBlock({
    super.key,
    required this.track,
  });

  @override
  State<TrackSeriesInfoBlock> createState() => _TrackSeriesInfoBlockState();
}

class _TrackSeriesInfoBlockState extends State<TrackSeriesInfoBlock> {
  late Future<Series> _seriesFuture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.track.series_id > 0) {
      _loadSeriesData();
    }
  }

  void _loadSeriesData() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _seriesFuture = _fetchSeriesData(widget.track.series_id);
    _seriesFuture.then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = error.toString();
        });
      }
    });
  }

  Future<Series> _fetchSeriesData(int seriesId) async {
    final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/series/$seriesId/';

    try {
      final uri = Uri.parse(url);
      final jsonData = await serverSession.get(uri);
      return Series.fromJson(jsonData);
    } catch (err, stacktrace) {
      final String msg = 'Error fetching series with id $seriesId: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      final translatedMsg = 'Error loading series data'.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.track.series_id <= 0) {
      return Container(); // Return nothing if no series_id
    }

    return FutureBuilder<Series>(
      future: _seriesFuture,
      builder: (context, snapshot) {
        if (_error != null) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Error loading series info: $_error',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Loading series...'.i18n),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Error loading series: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Text('No series data found'.i18n),
          );
        }

        final series = snapshot.data!;
        // final currentTrackIndex = series.track_ids.indexOf(widget.track.id);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Series: ${series.title}'.i18n,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: series.tracks.length,
                itemBuilder: (context, index) {
                  final track = series.tracks[index];
                  final position = index + 1;

                  return GestureDetector(
                    onTap: () {
                      if (track.id != widget.track.id) {
                        // Navigate to the corresponding track
                        Navigator.pushNamed(
                          context,
                          '/track/${track.id}', // Adjust this route according to your app's routing
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: track.id == widget.track.id
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              '$position/${series.tracks.length}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              track.title,
                              style: TextStyle(
                                fontWeight: track.id == widget.track.id ? FontWeight.bold : FontWeight.normal,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
