final _parseFinalIdRegExp = RegExp(r'/(\d+)/*$');

parseIdFromRoute(String routeName) {
  final RegExpMatch? match = _parseFinalIdRegExp.firstMatch(routeName);
  if (match == null) {
    throw Exception('Can not parse route id from "${routeName}"');
  }
  final id = int.parse(match.group(1) ?? '');
  return id;
}
