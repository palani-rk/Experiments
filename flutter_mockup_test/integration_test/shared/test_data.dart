/// Test data for integration tests
class TestData {
  
  /// Happy path answers for complete questionnaire flow
  static const Map<String, dynamic> happyPathAnswers = {
    // Basic Information Section
    'name': 'John Doe',
    'age': '28',
    'gender': 'Male',
    
    // Health Goals Section
    'primary_goal': 'Weight Loss',
    'activity_level': 'Moderately Active',
    
    // Dietary Preferences Section
    'diet_type': 'No Restrictions',
    'allergies': [],
    'food_dislikes': ['Mushrooms'],
    
    // Lifestyle Section
    'cooking_frequency': 'Daily',
    'meal_prep_time': '30-60 minutes',
    'weekly_budget': '50-100',
  };

  /// Test data for persistence testing
  static const Map<String, dynamic> persistenceTestAnswers = {
    'test_text_field': 'Persistence Test Value',
    'test_radio_selection': 'Option 2',
    'test_multiselect': ['Choice A', 'Choice C'],
    'test_slider_value': 75.0,
    'test_date': '2024-01-15',
  };

  /// Test data for different question types
  static const Map<String, dynamic> questionTypeTestData = {
    'text_questions': {
      'name': 'Integration Test User',
      'occupation': 'Software Developer',
      'additional_notes': 'This is a test note for integration testing purposes.',
    },
    
    'number_questions': {
      'age': '25',
      'height_cm': '175',
      'weight_kg': '70',
      'daily_water_glasses': '8',
    },
    
    'radio_questions': {
      'gender': 'Female',
      'activity_level': 'Very Active',
      'diet_preference': 'Vegetarian',
      'meal_timing': 'Regular Schedule',
    },
    
    'multiselect_questions': {
      'health_goals': ['Weight Loss', 'Muscle Building'],
      'dietary_restrictions': ['Lactose Intolerant', 'Gluten Free'],
      'preferred_cuisines': ['Italian', 'Asian', 'Mediterranean'],
      'exercise_types': ['Cardio', 'Strength Training'],
    },
    
    'slider_questions': {
      'daily_activity_hours': 6.5,
      'stress_level': 4.0,
      'sleep_hours': 7.5,
      'cooking_skill': 3.0,
    },
    
    'date_questions': {
      'birth_date': '1998-05-15',
      'start_date': '2024-01-01',
      'target_date': '2024-06-01',
    },
  };

  /// Invalid test data for validation testing
  static const Map<String, dynamic> invalidTestData = {
    'empty_required_field': '',
    'invalid_age': '-5',
    'invalid_email': 'not-an-email',
    'future_birth_date': '2030-01-01',
    'negative_weight': '-50',
  };

  /// Test data for boundary conditions
  static const Map<String, dynamic> boundaryTestData = {
    'min_age': '13',
    'max_age': '120',
    'min_weight': '30',
    'max_weight': '300',
    'min_height': '120',
    'max_height': '250',
    'very_long_text': 'This is a very long text input that tests the maximum character limit and how the application handles extensive user input that might exceed normal expectations and could potentially cause UI layout issues or performance problems in the questionnaire system.',
  };

  /// Sample questionnaire schema for testing
  static const Map<String, dynamic> testQuestionnaireSchema = {
    "welcome": {
      "title": "Welcome to NutriApp",
      "message": "Let's create your personalized nutrition plan! This questionnaire will help us understand your goals, preferences, and lifestyle to provide you with tailored recommendations.",
      "buttonText": "Get Started"
    },
    "sections": [
      {
        "id": "basic_info",
        "title": "Basic Information",
        "questions": [
          {
            "id": "name",
            "text": "What's your name?",
            "inputType": "text",
            "required": true,
            "hint": "Enter your full name"
          },
          {
            "id": "age",
            "text": "What's your age?",
            "inputType": "number",
            "required": true,
            "validation": {
              "min": 13,
              "max": 120
            }
          },
          {
            "id": "gender",
            "text": "What's your gender?",
            "inputType": "radio",
            "required": true,
            "options": ["Male", "Female", "Non-binary", "Prefer not to say"]
          }
        ]
      },
      {
        "id": "health_goals",
        "title": "Health Goals",
        "questions": [
          {
            "id": "primary_goal",
            "text": "What's your primary health goal?",
            "inputType": "radio",
            "required": true,
            "options": [
              "Weight Loss",
              "Weight Gain",
              "Muscle Building",
              "General Health",
              "Athletic Performance"
            ]
          },
          {
            "id": "activity_level",
            "text": "How would you describe your activity level?",
            "inputType": "radio",
            "required": true,
            "options": [
              "Sedentary",
              "Lightly Active",
              "Moderately Active",
              "Very Active",
              "Extremely Active"
            ]
          }
        ]
      }
    ]
  };

  /// Expected completion statistics
  static const Map<String, dynamic> expectedCompletionStats = {
    'total_questions': 5,
    'required_questions': 5,
    'optional_questions': 0,
    'estimated_completion_time': '2-3 minutes',
  };

  /// Test scenarios for different user flows
  static const Map<String, Map<String, dynamic>> userScenarios = {
    'fitness_enthusiast': {
      'name': 'Alex Johnson',
      'age': '24',
      'gender': 'Female',
      'primary_goal': 'Athletic Performance',
      'activity_level': 'Very Active',
    },
    
    'weight_loss_beginner': {
      'name': 'Sarah Smith',
      'age': '35',
      'gender': 'Female',
      'primary_goal': 'Weight Loss',
      'activity_level': 'Lightly Active',
    },
    
    'muscle_builder': {
      'name': 'Mike Wilson',
      'age': '22',
      'gender': 'Male',
      'primary_goal': 'Muscle Building',
      'activity_level': 'Very Active',
    },
    
    'senior_health_focused': {
      'name': 'Robert Davis',
      'age': '65',
      'gender': 'Male',
      'primary_goal': 'General Health',
      'activity_level': 'Lightly Active',
    },
  };

  /// Error scenarios for testing error handling
  static const Map<String, String> errorScenarios = {
    'network_error': 'Failed to load questionnaire data',
    'validation_error': 'Please fill in all required fields',
    'save_error': 'Failed to save your responses',
    'timeout_error': 'Request timed out',
  };

  /// Helper method to get test data by category
  static Map<String, dynamic> getTestDataByCategory(String category) {
    switch (category) {
      case 'happy_path':
        return happyPathAnswers;
      case 'persistence':
        return persistenceTestAnswers;
      case 'question_types':
        return questionTypeTestData;
      case 'invalid':
        return invalidTestData;
      case 'boundary':
        return boundaryTestData;
      default:
        return {};
    }
  }

  /// Helper method to get user scenario data
  static Map<String, dynamic> getUserScenario(String scenarioName) {
    return userScenarios[scenarioName] ?? {};
  }

  /// Helper method to get expected completion time based on question count
  static String getEstimatedCompletionTime(int questionCount) {
    if (questionCount <= 5) return '1-2 minutes';
    if (questionCount <= 10) return '2-4 minutes';
    if (questionCount <= 15) return '4-6 minutes';
    return '6+ minutes';
  }

  /// Helper method to generate random test data
  static Map<String, dynamic> generateRandomTestData() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return {
      'name': 'Test User $random',
      'age': '${20 + (random % 40)}',
      'gender': ['Male', 'Female', 'Non-binary'][random % 3],
      'primary_goal': ['Weight Loss', 'Weight Gain', 'General Health'][random % 3],
      'activity_level': ['Lightly Active', 'Moderately Active', 'Very Active'][random % 3],
    };
  }
}