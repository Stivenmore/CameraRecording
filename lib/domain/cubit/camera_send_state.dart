part of 'camera_send_cubit.dart';

abstract class CameraSendState extends Equatable {
  const CameraSendState();

  @override
  List<Object> get props => [];
}

class CameraSendInitial extends CameraSendState {}

class CameraSendLoading extends CameraSendState {
  final String message;
  const CameraSendLoading(this.message);

  @override
  List<Object> get props => [message];
}

class CameraSendLoaded extends CameraSendState {
  final List<String> files;
  final String phone;
  final String token;
  const CameraSendLoaded(this.files, this.phone, this.token);

  @override
  List<Object> get props => [files, phone, token];
}

class CameraSendError extends CameraSendState {
  final String message;
  const CameraSendError(this.message);

  @override
  List<Object> get props => [message];
}

class CameraSendErrorConection extends CameraSendState {}
