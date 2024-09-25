// question_data.dart

List<Map<String, dynamic>> questionData = [
  {
    'title': 'Question Title 1',
    'description': 'Description of question 1',
    'Question': 'What is the capital of France?',
    'answers': ['Berlin', 'Madrid', 'Paris', 'Rome']..shuffle(),
    'isAnswered': true, // New boolean value
  },
  {
    'title': 'Question Title 2',
    'description': 'Description of question 2',
    'Question': 'Which planet is known as the Red Planet?',
    'answers': ['Earth', 'Mars', 'Jupiter', 'Venus']..shuffle(),
    'isAnswered': false, // New boolean value
  },
  {
    'title': 'Question Title 3',
    'description': 'Description of question 3',
    'Question': 'What is the largest ocean on Earth?',
    'answers': [
      'Atlantic Ocean',
      'Indian Ocean',
      'Arctic Ocean',
      'Pacific Ocean'
    ]..shuffle(),
    'isAnswered': true, // New boolean value
  },
  {
    'title': 'Question Title 4',
    'description': 'Description of question 4',
    'Question': 'Who wrote "Romeo and Juliet"?',
    'answers': [
      'Charles Dickens',
      'William Shakespeare',
      'Mark Twain',
      'Jane Austen'
    ]..shuffle(),
    'isAnswered': false, // New boolean value
  },
  {
    'title': 'Question Title 5',
    'description': 'Description of question 5',
    'Question': 'What is the chemical symbol for gold?',
    'answers': ['Au', 'Ag', 'Pb', 'Fe']..shuffle(),
    'isAnswered': false, // New boolean value
  },
  {
    'title': 'Question Title 6',
    'description': 'Description of question 6',
    'Question': 'What is the hardest natural substance on Earth?',
    'answers': ['Diamond', 'Quartz', 'Topaz', 'Sapphire']..shuffle(),
    'isAnswered': false, // New boolean value
  },
  {
    'title': 'Question Title 7',
    'description': 'Description of question 7',
    'Question': 'In which year did the Titanic sink?',
    'answers': ['1912', '1905', '1915', '1920']..shuffle(),
    'isAnswered': false, // New boolean value
  },
];
