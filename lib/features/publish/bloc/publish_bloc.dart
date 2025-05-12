import 'dart:async';
import 'dart:math';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';
import 'package:chatbot_ai/features/publish/bloc/publish_event.dart';
import 'package:chatbot_ai/features/publish/bloc/publish_state.dart';
import 'package:chatbot_ai/features/publish/domain/publish_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublishBloc extends Bloc<EventPublish, PublishState> {
  PublishBloc() : super(const StatePublishInitial()) {
    on<EventPublishTelegram>(_onEventPublishTelegram);
  }

  FutureOr<void> _onEventPublishTelegram(
      EventPublishTelegram event, Emitter<PublishState> emit) async {
    try {
      final response = await PublishRepo.instant.publishTelegram(
        botToken: event.botToken,
        assistantId: event.assistantId,
      );

      if (response.statusCode == 200) {
        emit(const PublishState(isSuccess: true, message: 'Publish success'));
      } else {
        emit(PublishState(
            isSuccess: false,
            message: response.data['message'] ?? 'Publish failed'));
      }
    } catch (e) {
      emit(PublishState(isSuccess: false, message: e.toString()));
    }
  }
}