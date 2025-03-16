import 'package:logger/logger.dart';

final logger = Logger();

mixin FilterState {
  void notifyListeners();
  Future reloadTracks({bool notify = true}); // From TrackState

  /// FilterState

  String _filterSearch = '';
  String _filterQuery = '';

  void setFilterSearch(String value, {bool notify = true}) {
    this._filterSearch = value;
    if (notify) {
      notifyListeners();
    }
  }

  String getFilterSearch() {
    return this._filterSearch;
  }

  void setFilterQuery(String value, {bool notify = true}) {
    this._filterQuery = value;
    if (notify) {
      notifyListeners();
    }
  }

  String getFilterQuery() {
    return this._filterQuery;
  }

  void _createSearchQuery({bool notify = true}) {
    final search = Uri.encodeComponent(this.getFilterSearch());
    final query = '?search=${search}';
    this.setFilterQuery(query, notify: notify);
  }

  Future applyFilters({bool notify = true}) {
    this._createSearchQuery(notify: false);
    // Call updaters
    return this.reloadTracks(notify: notify);
  }
}
