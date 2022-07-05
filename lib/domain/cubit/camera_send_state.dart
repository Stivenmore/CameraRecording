part of 'camera_send_cubit.dart';

abstract class CameraSendState extends Equatable {
  const CameraSendState();

  @override
  List<Object> get props => [];
}

class CameraSendInitial extends CameraSendState {}

class CameraSendLoading extends CameraSendState {}

class CameraSendLoaded extends CameraSendState {
  final List<String> files;
  const CameraSendLoaded(this.files);

  @override
  List<Object> get props => [files];
}

class CameraSendError extends CameraSendState {}
