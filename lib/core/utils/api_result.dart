import 'package:legal_assistant_app/core/errors/failure.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiError<T> extends ApiResult<T> {
  const ApiError(this.failure);
  final Failure failure;
}
