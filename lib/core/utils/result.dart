/// A Result type that represents either success (Ok) or failure (Err)
sealed class Result<T, E> {
  const Result();

  /// Create a successful result
  const factory Result.ok(T value) = Ok<T, E>;

  /// Create a failure result
  const factory Result.err(E error) = Err<T, E>;

  /// Returns true if this is a successful result
  bool get isOk => this is Ok<T, E>;

  /// Returns true if this is a failure result
  bool get isErr => this is Err<T, E>;

  /// Returns the success value or null if this is an error
  T? get okOrNull => switch (this) {
        Ok(value: final value) => value,
        Err() => null,
      };

  /// Returns the error value or null if this is a success
  E? get errOrNull => switch (this) {
        Ok() => null,
        Err(error: final error) => error,
      };

  /// Maps the success value using the provided function
  Result<U, E> map<U>(U Function(T) mapper) => switch (this) {
        Ok(value: final value) => Result.ok(mapper(value)),
        Err(error: final error) => Result.err(error),
      };

  /// Maps the error value using the provided function
  Result<T, F> mapErr<F>(F Function(E) mapper) => switch (this) {
        Ok(value: final value) => Result.ok(value),
        Err(error: final error) => Result.err(mapper(error)),
      };

  /// Executes a function for side effects and returns the original result
  Result<T, E> also(void Function(T) action) => switch (this) {
        Ok(value: final value) => Result.ok(value)..also(action),
        Err(error: final error) => Result.err(error),
      };

  /// Pattern matching on the result
  U when<U>({
    required U Function(T) ok,
    required U Function(E) err,
  }) =>
      switch (this) {
        Ok(value: final value) => ok(value),
        Err(error: final error) => err(error),
      };

  /// Alias for `when` method - commonly used in functional programming
  U fold<U>(
    U Function(T) onOk,
    U Function(E) onErr,
  ) =>
      when(ok: onOk, err: onErr);
}

/// Successful result containing a value
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

/// Failure result containing an error
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

/// Extension methods for Result
extension ResultExtensions<T, E> on Result<T, E> {
  /// Returns the success value or throws if this is an error
  T unwrap() => switch (this) {
        Ok(value: final value) => value,
        Err(error: final error) =>
          throw Exception('Called unwrap on Err: $error'),
      };

  /// Returns the success value or the provided default
  T unwrapOr(T defaultValue) => switch (this) {
        Ok(value: final value) => value,
        Err() => defaultValue,
      };

  /// Returns the success value or computes it from the error
  T unwrapOrElse(T Function(E) defaultValueFn) => switch (this) {
        Ok(value: final value) => value,
        Err(error: final error) => defaultValueFn(error),
      };
}
