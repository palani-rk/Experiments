# Food Story Builder Widget Specification

## Overview
Interactive food preferences widget designed to capture high-level dietary preferences in an engaging, game-like experience. Part of the client onboarding questionnaire that builds a comprehensive food personality profile for nutritionists.

## Design Philosophy
- **Interactive & Fun**: Game-like experience that feels engaging rather than clinical
- **Strategic Grouping**: Broad patterns over specific details to keep it manageable
- **Culturally Adaptive**: Cooking methods and options adapt based on previous selections
- **Actionable Data**: Focus on preferences that directly inform meal planning and recipe recommendations

## Widget Flow Structure

### **Group 1: Food Relationship (Opening Question)**
```
Question: "Let's start your food story! How would you describe your relationship with food?"

Widget Type: Visual card selection (single select)
Options:
🍕 "Food is comfort and joy" 
🥗 "Food is fuel for my body"
⚖️ "Food is complicated for me"
🌟 "Food is adventure and exploration"

Data Purpose: Understanding client's emotional relationship with food for counseling approach
```

### **Group 2: Cuisine Comfort Zone**
```
Question: "Which cuisines feel like home to you?"

Widget Type: Interactive cuisine carousel with toggle selections
Options:
🇮🇹 Italian • 🇲🇽 Mexican • 🇨🇳 Chinese • 🇮🇳 Indian • 🇺🇸 American • 🇹🇭 Thai • 
🇯🇵 Japanese • 🥙 Mediterranean • 🇰🇷 Korean • 🇫🇷 French • 🇻🇳 Vietnamese • More...

Selection Types:
💚 "Love it" (familiar and preferred)
🤔 "Curious about it" (willing to try)

Data Purpose: Recipe database filtering and cultural meal planning
```

### **Group 3: Protein Preferences**
```
Question: "What proteins power your meals?"

Widget Type: Visual protein spectrum with slider controls
Protein Categories:
🥩 Red meat → 🐔 Poultry → 🐟 Seafood → 🥚 Eggs → 🫘 Legumes → 🌱 Plant-based

Frequency Scale: "Never" ← → "Sometimes" ← → "Often" ← → "Daily"

Data Purpose: Macro planning and protein source recommendations
```

### **Group 4: Vegetable Adventure Level**
```
Question: "How do you feel about vegetables in your meals?"

Widget Type: Category-based preference matrix
Vegetable Categories:
🥬 Leafy Greens (spinach, kale, lettuce)
🥕 Root Veggies (carrots, potatoes, beets) 
🥒 Crispy Fresh (cucumbers, bell peppers, celery)
🍅 Juicy & Flavorful (tomatoes, zucchini, eggplant)
🥦 Tree-like Veggies (broccoli, cauliflower, asparagus)
🌶️ Bold & Spicy (peppers, onions, garlic)

Options per Category:
💚 "Love them!" • 😊 "I'll eat them" • 🤔 "Depends how they're made" • ❌ "Not for me"

Data Purpose: Vegetable-focused meal planning and gradual dietary expansion strategies
```

### **Group 5: Cooking Method & Style Preferences (Adaptive)**
```
Question: "How do you like your food prepared?"

Widget Type: Visual cooking method selection with cultural adaptation
```

## Adaptive Cooking Methods

### **Base Cooking Methods (Universal)**
```
🔥 Grilled/Roasted
🥘 Stewed/Braised  
🥗 Fresh/Raw
🍳 Sautéed/Stir-fried
🍰 Baked
🌶️ Spicy & Bold
🧂 Simple & Light
```

### **Indian Cuisine Adaptation**
*Triggered when user selects Indian in Group 2*
```
🔥 Grilled/Roasted (tandoor-style, kebabs)
🥘 Curries & Gravies (dal, sabzi with masala)
🍳 Sautéed/Stir-fried (dry sabzi, bhurji)
🥗 Fresh/Raw (salads, raita, chutneys)
🫖 Steamed (idli, dhokla, momos)
🍰 Baked/Oven (naan, biscuits, cakes)
🌶️ Spicy & Bold (hot curries, pickles)
🧂 Simple & Light (boiled, minimal oil)
🥣 Comfort Foods (khichdi, porridge, soups)
```

### **Mediterranean Cuisine Adaptation**
*Triggered when user selects Mediterranean in Group 2*
```
🫒 Olive Oil Based (sautéed, drizzled)
🔥 Grilled (seafood, vegetables)
🥗 Fresh & Raw (salads, mezze)
🌿 Herb-Forward (basil, oregano, rosemary)
🍞 Baked Goods (bread, focaccia)
🧂 Simple Seasoning (salt, lemon, herbs)
```

### **East Asian Cuisine Adaptation**
*Triggered when user selects Chinese/Thai/Japanese/Korean in Group 2*
```
🥢 Stir-fried (wok cooking)
🍜 Steamed (dumplings, rice, fish)
🥗 Fresh/Raw (sushi, salads)
🌶️ Spicy (Sichuan, Thai chilies)
🍲 Braised/Simmered (soups, stews)
🧂 Light Seasoning (soy, ginger, garlic)
```

## Gamification Elements

### **Progress Indicators**
- Progress bar: "Building your flavor profile... 40% complete"
- Section completion badges
- Food personality development messages

### **Personality Building**
```
After Group 2: "You're looking globally curious! 🌍"
After Group 3: "A balanced protein explorer! 💪"  
After Group 4: "Veggie-friendly and open-minded! 🥬"
Final: "You're shaping up to be a 'Veggie-Curious Global Explorer' with a love for bold flavors! 
Your nutritionist will love working with your adventurous spirit! 🌟"
```

### **Preview Recommendations**
```
"Based on your choices, I'm thinking Mediterranean-inspired meals with grilled proteins and plenty of fresh vegetables... Should we explore some recipe ideas in your consultation?"
```

## Technical Implementation

### **Adaptive Logic Rules**
```javascript
// Cooking method adaptation
if (cuisinePreferences.includes('Indian')) {
  showCookingMethods = 'indian_adapted';
} else if (cuisinePreferences.includes('Mediterranean')) {
  showCookingMethods = 'mediterranean_adapted';
} else if (cuisinePreferences.some(cuisine => ['Chinese', 'Thai', 'Japanese', 'Korean'].includes(cuisine))) {
  showCookingMethods = 'east_asian_adapted';
} else {
  showCookingMethods = 'universal';
}
```

### **Data Structure**
```json
{
  "food_relationship": "adventure",
  "cuisine_preferences": {
    "loved": ["Indian", "Mediterranean"],
    "curious": ["Thai", "Korean"]
  },
  "protein_frequencies": {
    "red_meat": "sometimes",
    "poultry": "often", 
    "seafood": "sometimes",
    "eggs": "daily",
    "legumes": "often",
    "plant_based": "sometimes"
  },
  "vegetable_preferences": {
    "leafy_greens": "love_them",
    "root_vegetables": "ill_eat_them",
    "crispy_fresh": "love_them",
    "juicy_flavorful": "depends",
    "tree_like": "ill_eat_them", 
    "bold_spicy": "love_them"
  },
  "cooking_methods": ["curries_gravies", "steamed", "fresh_raw", "simple_light"],
  "food_personality": "Veggie-Curious Global Explorer"
}
```

### **Widget Specifications**
- **Responsive Design**: Mobile-first approach with touch-friendly interactions
- **Visual Elements**: High-quality food imagery and emoji combinations
- **Animation**: Smooth transitions between questions and selections
- **Accessibility**: Screen reader compatibility and keyboard navigation
- **Performance**: Lazy loading of images and smooth interactions

## Integration Points

### **With Main Questionnaire**
- Embedded as a special widget section within the conversational flow
- Maintains chat history but with rich interactive components
- Results displayed as formatted summary in chat

### **For Nutritionists**
- **Recipe Filtering**: Match recommendations to preferences
- **Cultural Sensitivity**: Understand client's food background
- **Meal Planning**: Protein distribution and vegetable incorporation strategies
- **Progress Tracking**: Monitor preference expansion over time

## Success Metrics
- **Engagement Rate**: Completion rate of food preferences section
- **Data Quality**: Completeness of preference profiles
- **Nutritionist Feedback**: Usefulness of preference data for meal planning
- **Client Satisfaction**: Fun factor and user experience ratings
- **Preference Accuracy**: How well initial preferences match long-term client behavior

## Future Enhancements
- **AI-Powered Suggestions**: Smart follow-up questions based on patterns
- **Visual Food Recognition**: Upload photos of preferred meals
- **Seasonal Adaptations**: Adjust options based on local/seasonal availability  
- **Dietary Restriction Integration**: Smart filtering based on medical conditions
- **Social Features**: Compare food personalities with family members
- **Recipe Preview**: Show sample recipes during preference selection