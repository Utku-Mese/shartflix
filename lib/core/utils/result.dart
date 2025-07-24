sealed class Result<T, E> {
  const Result();

  const factory Result.ok(T value) = Ok<T, E>;

  const factory Result.err(E error) = Err<T, E>;

  bool get isOk => this is Ok<T, E>;

  bool get isErr => this is Err<T, E>;

  T? get okOrNull => switch (this) {
        Ok(value: final value) => value,
        Err() => null,
      };

  E? get errOrNull => switch (this) {
        Ok() => null,
        Err(error: final error) => error,
      };

  Result<U, E> map<U>(U Function(T) mapper) => switch (this) {
        Ok(value: final value) => Result.ok(mapper(value)),
        Err(error: final error) => Result.err(error),
      };

  Result<T, F> mapErr<F>(F Function(E) mapper) => switch (this) {
        Ok(value: final value) => Result.ok(value),
        Err(error: final error) => Result.err(mapper(error)),
      };

  Result<T, E> also(void Function(T) action) => switch (this) {
        Ok(value: final value) => Result.ok(value)..also(action),
        Err(error: final error) => Result.err(error),
      };

  U when<U>({
    required U Function(T) ok,
    required U Function(E) err,
  }) =>
      switch (this) {
        Ok(value: final value) => ok(value),
        Err(error: final error) => err(error),
      };

  U fold<U>(
    U Function(T) onOk,
    U Function(E) onErr,
  ) =>
      when(ok: onOk, err: onErr);
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ok<T, E> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);

  final E error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Err<T, E> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Err($error)';
}

extension ResultExtensions<T, E> on Result<T, E> {
  T unwrap() => switch (this) {
        Ok(value: final value) => value,
        Err(error: final error) =>
          throw Exception('Called unwrap on Err: $error'),
      };

  T unwrapOr(T defaultValue) => switch (this) {
        Ok(value: final value) => value,
        Err() => defaultValue,
      };

  T unwrapOrElse(T Function(E) defaultValueFn) => switch (this) {
        Ok(value: final value) => value,
        Err(error: final error) => defaultValueFn(error),
      };
}
