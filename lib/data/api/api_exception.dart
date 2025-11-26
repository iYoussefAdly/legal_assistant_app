class QanounyApiException implements Exception {
  const QanounyApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

