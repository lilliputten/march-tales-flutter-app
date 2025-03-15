import 'package:flutter/material.dart';

import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/data-driven/ShowTracksListBlockLoader.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'translations.i18n.dart';

const double _sidePadding = 5;

class TrackDetailsScreenView extends StatelessWidget {
  const TrackDetailsScreenView({
    super.key,
    required this.track,
    required this.scrollController,
  });

  final Track track;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrackItem(track: this.track, fullView: true),
                  ShowTracksListBlockLoader(
                    query: '?filter=track_status:PUBLISHED&filter=author_id:${track.author.id}',
                    title: "Other author's tracks".i18n,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(_sidePadding),
                    child: CustomBackButton(),
                  ),
                ].nonNulls.toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
