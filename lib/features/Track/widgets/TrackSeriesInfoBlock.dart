import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Series.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackSeriesItemWidget.dart';
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
    if (widget.track.series_id != null) {
      _loadSeriesData();
    }
  }

  void _loadSeriesData() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _seriesFuture = _fetchSeriesData(widget.track.series_id!);
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
    if (widget.track.series_id == null) {
      return Container(); // Return nothing if no series_id
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.bodyMedium!;
    // final styleSmall = theme.textTheme.bodySmall!;
    final double basicAlpha = 1;
    final double labelAlpha = basicAlpha / 2;
    final textColor = colorScheme.onSurface;
    final basicColorBase = textColor;
    final basicColor = basicColorBase;
    final labelColor = basicColor.withValues(alpha: labelAlpha);
    // final textStyle = style.copyWith(color: basicColor);

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

        if (series.track_ids.isEmpty) {
          return Container();
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Series:'.i18n, style: style.copyWith(color: labelColor)),
                    Text(series.title),
                  ],
                ),
              ),
              TrackItemsList(
                series: series,
                currentTrackId: widget.track.id,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrackItemsList extends StatefulWidget {
  final Series series;
  final int currentTrackId;

  const TrackItemsList({
    super.key,
    required this.series,
    required this.currentTrackId,
  });

  @override
  State<TrackItemsList> createState() => _TrackItemsListState();
}

class _TrackItemsListState extends State<TrackItemsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.series.track_ids.length,
      itemBuilder: (context, index) {
        final trackId = widget.series.track_ids[index];
        final position = index + 1;
        return TrackSeriesItemWidget(
          trackId: trackId,
          position: position,
          totalTracks: widget.series.track_ids.length,
          isCurrentTrack: trackId == widget.currentTrackId,
        );
      },
    );
  }
}
