class ConnectionException implements Exception {
  String cause;

  ConnectionException(this.cause);

  @override
  String toString() {
    return 'ConnectionException: ${cause}';
  }
}
