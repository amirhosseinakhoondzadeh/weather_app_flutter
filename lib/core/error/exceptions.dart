class ServerException implements Exception {
  final String? message;
  final int? code;

  const ServerException({this.message, this.code});
}

class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});
}
