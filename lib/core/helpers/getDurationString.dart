String getDurationString(Duration? d) {
  if (d == null) {
    return '';
  }
  String s = d.toString();
  s = s.replaceFirst(RegExp(r'\.\d+$'), '');
  return s;
}
