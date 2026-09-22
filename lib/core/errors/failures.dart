import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class UnsupportedPlatformFailure extends Failure {
  const UnsupportedPlatformFailure(super.message);
}

class InvalidUrlFailure extends Failure {
  const InvalidUrlFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

