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
    text: '¿Te has sentido con poco interés cuando realizas tus tareas diarias?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has sentido decaído, confundido o sin esperanza?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has tenido problemas para lograr dormir o has dormido demasiado?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has sentido muy cansado o sin energía al realizar tus quehaceres diarios?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has notado que no tienes apetito o has comido mucho más de lo normal?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Te has sentido mal contigo mismo, o has sentido que te has defraudado o defraudado a tu familia?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has tenido problemas para concentrarte cuando realizas alguna actividad?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has sentido que te mueves más despacio, tanto que otras personas han podido notarlo o te has dado cuenta de que te mueves mucho más de lo normal?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
  Question(
    text: '¿Has sentido que quieres hacerte daño o incluso que estarías mejor si ya no existieses?',
    options: [
      const Option(text: 'Ningún día', points: 0),
      const Option(text: 'Varios días', points: 1),
      const Option(text: 'Más de la mitad de los días', points: 2),
      const Option(text: 'Casi todos los días', points: 3),
    ],
  ),
];