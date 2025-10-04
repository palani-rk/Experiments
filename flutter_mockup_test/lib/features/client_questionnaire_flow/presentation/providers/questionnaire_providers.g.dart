// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionnaireConfigServiceHash() =>
    r'80a6c9a92a4e1019678162ae9c0bf8087786b499';

/// Service providers
///
/// Copied from [questionnaireConfigService].
@ProviderFor(questionnaireConfigService)
final questionnaireConfigServiceProvider =
    AutoDisposeProvider<QuestionnaireConfigService>.internal(
  questionnaireConfigService,
  name: r'questionnaireConfigServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questionnaireConfigServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuestionnaireConfigServiceRef
    = AutoDisposeProviderRef<QuestionnaireConfigService>;
String _$responsePersistenceServiceHash() =>
    r'5446f4590660d641aa58ddbdfeaf74d13544f956';

/// See also [responsePersistenceService].
@ProviderFor(responsePersistenceService)
final responsePersistenceServiceProvider =
    AutoDisposeProvider<service.ResponsePersistenceService>.internal(
  responsePersistenceService,
  name: r'responsePersistenceServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$responsePersistenceServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResponsePersistenceServiceRef
    = AutoDisposeProviderRef<service.ResponsePersistenceService>;
String _$currentQuestionHash() => r'2ef0b6c58275f31e266727a0792cf2821b0f3250';

/// Derived providers for UI consumption
///
/// Copied from [currentQuestion].
@ProviderFor(currentQuestion)
final currentQuestionProvider = AutoDisposeProvider<Question?>.internal(
  currentQuestion,
  name: r'currentQuestionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentQuestionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentQuestionRef = AutoDisposeProviderRef<Question?>;
String _$allResponsesHash() => r'7209349de81d0cd520aaeb9f089f00d04c964926';

/// See also [allResponses].
@ProviderFor(allResponses)
final allResponsesProvider =
    AutoDisposeProvider<Map<String, SectionResponse>>.internal(
  allResponses,
  name: r'allResponsesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allResponsesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllResponsesRef = AutoDisposeProviderRef<Map<String, SectionResponse>>;
String _$currentSectionResponseHash() =>
    r'c789f3530f9964d07e457fa926b506475c59e0cc';

/// See also [currentSectionResponse].
@ProviderFor(currentSectionResponse)
final currentSectionResponseProvider =
    AutoDisposeProvider<SectionResponse?>.internal(
  currentSectionResponse,
  name: r'currentSectionResponseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSectionResponseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentSectionResponseRef = AutoDisposeProviderRef<SectionResponse?>;
String _$progressInfoHash() => r'25ec93009c4fd3c08a12d1c8036455efb2327267';

/// See also [progressInfo].
@ProviderFor(progressInfo)
final progressInfoProvider = AutoDisposeProvider<ProgressInfo>.internal(
  progressInfo,
  name: r'progressInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$progressInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProgressInfoRef = AutoDisposeProviderRef<ProgressInfo>;
String _$brandingConfigHash() => r'b21ae883657f2ab06cb98e918303a9138fc1c8cb';

/// See also [brandingConfig].
@ProviderFor(brandingConfig)
final brandingConfigProvider = AutoDisposeProvider<BrandingConfig>.internal(
  brandingConfig,
  name: r'brandingConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$brandingConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BrandingConfigRef = AutoDisposeProviderRef<BrandingConfig>;
String _$questionnaireNotifierHash() =>
    r'4710a4e48e53bea1fab80f957d310f8b5ba99baa';

/// Main questionnaire state notifier
///
/// Copied from [QuestionnaireNotifier].
@ProviderFor(QuestionnaireNotifier)
final questionnaireNotifierProvider = AutoDisposeAsyncNotifierProvider<
    QuestionnaireNotifier, QuestionnaireState>.internal(
  QuestionnaireNotifier.new,
  name: r'questionnaireNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questionnaireNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuestionnaireNotifier = AutoDisposeAsyncNotifier<QuestionnaireState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
