class Question {
  final String text;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.text,
    required this.options,
    this.isLocked=false,
    this.selectedOption,
  });
}

class Option{
  final String text;
  final int points;

  const Option({
    required this.text,
    required this.points,
  });
}


final questions = [
  Question(
    text: '¿Te has sentido nervioso(a), ansioso(a) o con los nervios de punta?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿No has sido capaz de parar o controlar tu preocupación?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has preocupado demasiado por diferentes motivos?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has tenido dificultad para relajarse?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has sentido tan inquieto(a) que podrías perder el control sobre ti?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has sentido molesto o te has irritado fácilmente?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has sentido miedo de que algo terrible fuera a pasar?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
];