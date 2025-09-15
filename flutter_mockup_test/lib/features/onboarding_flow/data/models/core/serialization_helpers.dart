library;

/// Serialization helpers for sealed classes in the chat questionnaire system
///
/// These helpers work with the new sealed class union types for ChatSection and SectionMessage.

import '../core/chat_section.dart';
import '../core/section_message.dart';

class ChatSectionSerializer {
  /// Serialize a list of ChatSections
  static List<Map<String, dynamic>> toJsonList(List<ChatSection> sections) {
    return sections.map((section) => section.toJson()).toList();
  }

  /// Deserialize a list of ChatSections
  static List<ChatSection> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .cast<Map<String, dynamic>>()
        .map((json) => ChatSection.fromJson(json))
        .toList();
  }
}

class SectionMessageSerializer {
  /// Serialize a list of SectionMessages
  static List<Map<String, dynamic>> toJsonList(List<SectionMessage> messages) {
    return messages.map((message) => message.toJson()).toList();
  }

  /// Deserialize a list of SectionMessages
  static List<SectionMessage> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .cast<Map<String, dynamic>>()
        .map((json) => SectionMessage.fromJson(json))
        .toList();
  }
}