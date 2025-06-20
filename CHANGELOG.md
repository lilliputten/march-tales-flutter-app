<!--
 @since 2025.03.19, 22:43
 @changed 2025.06.21, 02:17
-->

# CHANGELOG

## [v.0.1.12](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.12) - 2025.06.21

- Added automatic scrolling of the tracks list (issue #56).
- Added a statistics section on the main screen.
- Added ability to hide floating player.
- Updated "recent" widgets: statistics moved to the bottom of the main page, styled as normal buttons.

See:

- [Issue #56: Implement automatic loading of tracks when scrolling](https://github.com/lilliputten/march-tales-flutter-app/issues/61)
- [Issue #61: Add the 'Home' screen with data from recents api results](https://github.com/lilliputten/march-tales-flutter-app/issues/61)
- [Compare with previous tag](https://github.com/lilliputten/march-tales-flutter-app/compare/march-tales-app-v.0.1.11...v.0.1.12)
- [Release](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.12)

## [v.0.1.11](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.11) - 2025.04.17

- Added new navigation tab and page (home, 'recents').
- Added recent data state, screen & details components with data reload feature (via `RefreshIndicator`).
- Used standard `LoadingSplash` instead of `CircularProgressIndicator` widget wherever possible.

See:

- [Issue #61: Add the 'Home' screen with data from recents api results](https://github.com/lilliputten/march-tales-flutter-app/issues/61)
- [Compare with previous tag](https://github.com/lilliputten/march-tales-flutter-app/compare/march-tales-app-v.0.1.10...v.0.1.11)
- [Release](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.11)

## [v.0.1.10](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.10) - 2025.04.15

- Added support for a UserTrack data inside the Track server objects.
- Added `lastFavoritedMs` field to a local database.
- Added invocations of `updateLocalTracks` or `updateLocalTrack` when tracks' data received.
- Added synchronization of local track' states (positions, favorite) on login and reset on logout. Added updating of local track on track data receive.
- Updated login/logout blocks (added extra information, profile link).
- Added total and local played count fields in TrackInfo and in local db.
- Added sending timestamps to the server for `postIcrementPlayedCount`, `postToggleFavorite` calls.
- Ensured update of the current language in the settings login browser.
- Added permanent favorite controls on track items (when not in a compact mode).
- Published production release on Google Play.

Version v.1.1.9 has been skipped (it was used for open testing release).

See:

- [Issue #58: Add synchronization of playback positions](https://github.com/lilliputten/march-tales-flutter-app/issues/58)
- [Compare with previous tag](https://github.com/lilliputten/march-tales-flutter-app/compare/march-tales-app-v.0.1.8...v.0.1.10)
- [Release](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/v.0.1.10)

## [v.0.1.8](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/march-tales-app-v.0.1.8) - 2025.03.19

- Refactored the root app to allow to retry the initalization procedure in case of failure.
- Updated data loading and errors processing logic for basic data display screens.

See:

- [Compare with previous tag](https://github.com/lilliputten/march-tales-flutter-app/compare/march-tales-app-v.0.1.4...march-tales-app-v.0.1.8)
- [Release](https://github.com/lilliputten/march-tales-flutter-app/releases/tag/march-tales-app-v.0.1.8)

## v.0.1.6 - 2025.03.18

The initial version is version 0.1.6 with the minimum implemented set of functions:

- Server API for tracks, authors, rubrics, tag list, and detailed methods.
- Favorites list: stored locally and on the server (for authenticated users).
- Settings for switching the language and theme.
- Floating record player.
- Notification player management.
- Memorizing the playback position of each track.
