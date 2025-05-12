class PublishState {
  final String? message;
  final bool? isSuccess;
  const PublishState({
    this.message, 
    this.isSuccess,
  });
}

class StatePublishInitial extends PublishState {
  const StatePublishInitial({
    super.message, 
    super.isSuccess,
  });
}

class StatePublishTelegram extends PublishState {
  const StatePublishTelegram({
    super.message, 
    super.isSuccess,
  });
}