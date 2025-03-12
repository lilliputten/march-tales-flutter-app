import 'package:flutter/material.dart';

import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/SectionTitle.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'package:march_tales_app/features/Track/widgets/TracksListByIds.dart';
import 'TrackDetailsScreenView.i18n.dart';

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
                  track.author.track_ids.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.all(_sidePadding),
                          child: SectionTitle(
                            text: "Other author's tracks".i18n,
                            extraText: '(${track.author.track_ids.length})',
                          ),
                        ),
                  track.author.track_ids.isEmpty
                      ? null
                      : TracksListByIds(
                          ids: track.author.track_ids,
                          useScrollController: false,
                          compact: true,
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
