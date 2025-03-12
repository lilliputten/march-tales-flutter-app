String convertErrorLikeToString(dynamic error) {
  String text = error.toString();
  try {
    if (error.cause != null) {
      text = error.cause.toString();
    }
  } catch (err) {
    // NOOP
  }
  return text;
}
