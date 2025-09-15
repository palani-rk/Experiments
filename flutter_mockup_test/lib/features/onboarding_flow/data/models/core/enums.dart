library;

/// Core enums for the chat-based onboarding flow feature
///
/// This file contains all the enums used throughout the chat questionnaire system
/// including section types, message types, section statuses, and question types.

enum SectionType {
  intro,
  questionnaire,
  media,
  review,
  completion,
}

enum SectionStatus {
  pending,
  inProgress,
  completed,
  skipped,
}

enum MessageType {
  /// Section introduction messages
  botIntro,

  /// Question prompts (shown in input area)
  botQuestion,

  /// User's responses
  userAnswer,

  /// Section completion messages
  botWrapup,

  /// Images, videos, documents
  mediaContent,

  /// Progress updates, errors
  systemNotification,
}

enum QuestionType {
  text,
  number,
  email,
  phone,
  date,
  radio,
  multiselect,
  slider,
  scale,
  boolean,
}

enum ChatStatus {
  notStarted,
  inProgress,
  completed,
  abandoned,
}

extension SectionTypeExtension on SectionType {
  String get displayName {
    switch (this) {
      case SectionType.intro:
        return 'Welcome';
      case SectionType.questionnaire:
        return 'Questionnaire';
      case SectionType.media:
        return 'Media';
      case SectionType.review:
        return 'Review';
      case SectionType.completion:
        return 'Completion';
    }
  }
}

extension SectionStatusExtension on SectionStatus {
  bool get isComplete => this == SectionStatus.completed;
  bool get isInProgress => this == SectionStatus.inProgress;
  bool get isPending => this == SectionStatus.pending;
  bool get isSkipped => this == SectionStatus.skipped;
}

extension QuestionTypeExtension on QuestionType {
  bool get requiresOptions {
    return this == QuestionType.radio || this == QuestionType.multiselect;
  }

  bool get isNumericInput {
    return this == QuestionType.number ||
           this == QuestionType.slider ||
           this == QuestionType.scale;
  }

  String get inputHint {
    switch (this) {
      case QuestionType.text:
        return 'Enter your answer...';
      case QuestionType.number:
        return 'Enter a number...';
      case QuestionType.email:
        return 'Enter your email address...';
      case QuestionType.phone:
        return 'Enter your phone number...';
      case QuestionType.date:
        return 'Select a date...';
      case QuestionType.radio:
        return 'Select one option...';
      case QuestionType.multiselect:
        return 'Select all that apply...';
      case QuestionType.slider:
        return 'Adjust the slider...';
      case QuestionType.scale:
        return 'Rate on the scale...';
      case QuestionType.boolean:
        return 'Yes or No...';
    }
  }
}