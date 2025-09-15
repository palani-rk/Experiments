import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import '../support/validation_status.dart';

part 'section_message.freezed.dart';
part 'section_message.g.dart';

/// Sealed class for all message types within sections
///
/// This sealed class represents all possible message types in the
/// chat-based questionnaire system using union types.
@freezed
sealed class SectionMessage with _$SectionMessage {
  /// Bot message (intro, question, wrapup, system notification)
  const factory SectionMessage.bot({
    required String id,
    required String sectionId,
    required String content,
    required MessageType messageType,
    required DateTime timestamp,
    @Default(false) bool isEditable,
    String? context,
    Map<String, dynamic>? metadata,
  }) = BotMessage;

  /// Question and answer message
  const factory SectionMessage.questionAnswer({
    required String id,
    required String sectionId,
    required String questionId,
    required String questionText,
    required QuestionType inputType,
    required dynamic answer,
    required DateTime timestamp,
    @Default(MessageType.userAnswer) MessageType messageType,
    @Default(true) bool isEditable,
    String? formattedAnswer,
    ValidationStatus? validation,
    Map<String, dynamic>? questionMetadata,
  }) = QuestionAnswer;

  factory SectionMessage.fromJson(Map<String, dynamic> json) =>
      _$SectionMessageFromJson(json);
}

/// Extension for SectionMessage business logic
extension SectionMessageExtension on SectionMessage {
  /// Check if this is a bot message
  bool get isBotMessage => switch (this) {
    BotMessage() => true,
    QuestionAnswer() => false,
  };

  /// Check if this is a user message
  bool get isUserMessage => switch (this) {
    BotMessage() => false,
    QuestionAnswer() => true,
  };

  /// Get display content for this message
  String get displayContent => switch (this) {
    BotMessage(:final content, :final messageType) => _formatBotContent(content, messageType),
    QuestionAnswer(:final formattedAnswer, :final answer) =>
      formattedAnswer ?? answer?.toString() ?? '',
  };

  /// Format bot message content based on type
  String _formatBotContent(String content, MessageType messageType) {
    switch (messageType) {
      case MessageType.botIntro:
        return content;
      case MessageType.botQuestion:
        return content;
      case MessageType.botWrapup:
        return '✅ $content';
      case MessageType.systemNotification:
        return '🔔 $content';
      default:
        return content;
    }
  }
}

/// Utility functions for message handling
class MessageUtils {
  /// Generate a unique ID for messages
  static String generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond % 1000}';
  }

  /// Check if a message type is from the bot
  static bool isBotMessage(MessageType type) {
    return type == MessageType.botIntro ||
           type == MessageType.botQuestion ||
           type == MessageType.botWrapup;
  }

  /// Check if a message type is from the user
  static bool isUserMessage(MessageType type) {
    return type == MessageType.userAnswer;
  }

  /// Check if a message type is a system message
  static bool isSystemMessage(MessageType type) {
    return type == MessageType.systemNotification ||
           type == MessageType.mediaContent;
  }

  /// Get display name for message type
  static String getMessageTypeDisplayName(MessageType type) {
    switch (type) {
      case MessageType.botIntro:
        return 'Bot Introduction';
      case MessageType.botQuestion:
        return 'Bot Question';
      case MessageType.userAnswer:
        return 'User Answer';
      case MessageType.botWrapup:
        return 'Bot Summary';
      case MessageType.mediaContent:
        return 'Media Content';
      case MessageType.systemNotification:
        return 'System Notification';
    }
  }
}