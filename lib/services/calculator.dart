import 'package:math_expressions/math_expressions.dart';

class CalculatorOperation {
  String userQuestionToShow = '';
  String userQuestionToCalculate = '';
  String userAnswer = '';
  String userNumber = '';
  String userOperator = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '/',
    'x',
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '.',
    '0',
    '='
  ];

  void buttonOperation(int index) {
    switch (buttons[index]) {
      case 'C':
        _clearAll();
        break;
      case 'DEL':
        _deleteLastEntry();
        break;
      case '=':
        _finalizeCalculation();
        break;
      case '.':
        _handleDecimal();
        break;
      default:
        if (isOperator(buttons[index])) {
          _handleOperator(buttons[index]);
        } else {
          _handleNumber(buttons[index]);
        }
    }
  }

  void _clearAll() {
    userQuestionToShow = '';
    userQuestionToCalculate = '';
    userAnswer = '';
    userNumber = '';
    userOperator = '';
  }

  void _deleteLastEntry() {
    if (userQuestionToShow.length > 1) {
      userQuestionToShow =
          userQuestionToShow.substring(0, userQuestionToShow.length - 1);
      userQuestionToCalculate = userQuestionToShow;

      if (userQuestionToShow.isNotEmpty &&
          !isOperator(userQuestionToShow[userQuestionToShow.length - 1])) {
        calculate();
      } else if (userQuestionToShow.isNotEmpty) {
        userQuestionToCalculate =
            userQuestionToCalculate.substring(0, userQuestionToShow.length - 1);
        calculate();
      }
    } else {
      _clearAll();
    }
  }

  void _finalizeCalculation() {
    if (userQuestionToShow.isNotEmpty &&
        userQuestionToShow != '-' &&
        !userQuestionToShow.endsWith('/0') &&
        !isOperator(userQuestionToShow[userQuestionToShow.length - 1])) {
      userQuestionToCalculate = userQuestionToShow;
      calculate();
      _applyAnswer();
    } else {
      return;
    }
  }

  void _handleDecimal() {
    if (userQuestionToShow.isEmpty ||
        isOperator(userQuestionToShow[userQuestionToShow.length - 1])) {
      userNumber = '0.';
      userQuestionToShow += '0.';
    } else if (!userQuestionToShow.endsWith('.') && !userNumber.contains('.')) {
      userNumber += '.';
      userQuestionToShow += '.';
    }
  }

  void _handleOperator(String operator) {
    if (userQuestionToShow.isNotEmpty) {
      // Check for division by zero
      if (userQuestionToShow.endsWith('/0')) {
        return;
      }

      // Disable operators input if the last element is '.'
      if (userQuestionToShow[userQuestionToShow.length - 1] == '.') {
        return;
      }

      userNumber = '';
      userOperator = operator;
      if (!isOperator(userQuestionToShow[userQuestionToShow.length - 1])) {
        userQuestionToShow += operator;
      } else if (userQuestionToShow.length > 1) {
        userQuestionToShow =
            userQuestionToShow.substring(0, userQuestionToShow.length - 1) +
                operator;
      }
    } else if (userQuestionToShow.isEmpty && operator == '-') {
      userQuestionToShow += operator;
    }
  }

  void _handleNumber(String number) {
    if (userQuestionToShow.isEmpty) {
      userNumber = number;
      userQuestionToShow = number;
    } else {
      List<String> parts = userQuestionToShow.split(RegExp(r'[+\-x/]'));
      String lastPart = parts.isNotEmpty ? parts.last : '';

      if (lastPart == '0' && userNumber == '0') {
        userQuestionToShow =
            userQuestionToShow.substring(0, userQuestionToShow.length - 1) +
                number;
      } else {
        userQuestionToShow += number;
        userNumber += number;
      }
    }

    // if (!userQuestionToShow.endsWith('/0')) {
    userQuestionToCalculate = userQuestionToShow;
    calculate();
    // } else {
    //   calculate();
    // }
  }

  void calculate() {
    try {
      String finalQuestion = userQuestionToCalculate.replaceAll('x', '*');
      Parser parser = Parser();
      Expression exp = parser.parse(finalQuestion);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);
      userAnswer =
          eval == eval.toInt() ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      userAnswer = 'Error';
      // print(e);
    }
  }

  bool isOperator(String x) {
    return x == '/' || x == 'x' || x == '-' || x == '+';
  }

  void _applyAnswer() {
    userQuestionToShow = userAnswer;
    userQuestionToCalculate = userAnswer;
    userAnswer = '';
    userNumber = userQuestionToShow;
    userOperator = '';
  }
}
