import 'package:dio/dio.dart';

abstract class Failure extends Error{}

class RemoteFailure extends Failure{
  String message;
  Error error;
  RemoteFailure(this.message,this.error);

  @override
  String toString() {
    return 'RemoteFailure{message: $message, error: $error}';
  }
}