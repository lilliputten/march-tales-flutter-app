String addQueryParam(String query, String id, dynamic value, {bool ifAbsent = false}) {
  final prefix = '${id}=';
  if (value != null && (!ifAbsent || !query.contains(prefix))) {
    final delim = query.isEmpty ? '?' : '&';
    query += [delim, prefix, value.toString()].join('');
  }
  return query;
}
