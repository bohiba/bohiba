enum StatusCode {
  networkError(0),

  /// 2xx Success
  ok(200),

  /// 201 Created new record
  created(201),
  accepted(202),
  noContent(204),

  /// 3xx Redirection
  movedPermanently(301),

  /// 302: found
  found(302),

  /// 304: not modified
  notModified(304),

  /// 4xx Client Errors
  badRequest(400),

  /// 401: not logged in, token expire, invalid token
  unauthorized(401),

  /// 402: payment required
  paymentRequired(402),

  /// 403: forbidden
  forbidden(403),

  /// 404: not found
  notFound(404),

  /// 405: method not allowed
  methodNotAllowed(405),

  /// 406: not acceptable
  notAcceptable(406),

  /// 408: request timeout
  requestTimeout(408),

  /// 409: conflict
  conflict(409),

  /// 410: gone
  gone(410),

  /// 429: too many requests
  tooManyRequests(429),

  /// 422: unprocessable entity - Validation failed
  unprocessableEntity(422),

  /// 500: internal server error
  internalServerError(500),

  /// 501: not implemented
  notImplemented(501),

  /// 502: bad gateway
  badGateway(502),

  /// 503: service unavailable
  serviceUnavailable(503),

  /// 504: gateway timeout
  gatewayTimeout(504);

  final int code;

  const StatusCode(this.code);

  /// Convert int -> enum
  static StatusCode fromCode(int code) {
    try {
      return StatusCode.values.firstWhere((e) => e.code == code);
    } catch (_) {
      return StatusCode.notImplemented;
    }
  }

  /// Helpers
  bool get isSuccess => code >= 200 && code < 300;

  bool get isClientError => code >= 400 && code < 500;

  bool get isServerError => code >= 500 && code < 600;
}
