import 'package:template_app/core/errors/failures.dart';

abstract class Either<L, R> {
  const Either();
  
  bool get isLeft;
  bool get isRight;
  
  L get left;
  R get right;
  
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);
}

class Left<L, R> extends Either<L, R> {
  const Left(this._value);
  
  final L _value;
  
  @override
  bool get isLeft => true;
  
  @override
  bool get isRight => false;
  
  @override
  L get left => _value;
  
  @override
  R get right => throw Exception('Tried to get right value from Left');
  
  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnL(_value);
}

class Right<L, R> extends Either<L, R> {
  const Right(this._value);
  
  final R _value;
  
  @override
  bool get isLeft => false;
  
  @override
  bool get isRight => true;
  
  @override
  L get left => throw Exception('Tried to get left value from Right');
  
  @override
  R get right => _value;
  
  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnR(_value);
}

// Type alias for common use case
typedef Result<T> = Either<Failure, T>;
