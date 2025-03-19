String convertErrorLikeToString(dynamic error) {
  String text = error.toString();
  try {
    if (error.cause != null) {
      text = error.cause.toString();
    }
  } catch (err) {
    // NOOP
  }
  const String removePrefix = 'Exception: ';
  if (text.startsWith(removePrefix)) {
    text = text.substring(removePrefix.length);
  }
  return text.trim();
}
