class VersionException implements Exception {
  String cause;

  VersionException(this.cause);

  @override
  String toString() {
    return 'VersionException: ${cause}';
  }
}
