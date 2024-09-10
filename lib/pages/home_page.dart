import 'package:calculator/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:calculator/services/calculator.dart';
// import 'package:calculator/themes/theme_switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  final calculatorOperation = CalculatorOperation();
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            // appBar: AppBar(
            //   backgroundColor: Theme.of(context).colorScheme.surface,
            //   shadowColor: Colors.transparent,
            //   surfaceTintColor: Theme.of(context).colorScheme.surface,
            //   actions: const [
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 10.0),
            //       child: ThemeSwitcher(),
            //     ),
            //   ],
            // ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child: SingleChildScrollView(
                            reverse: true,
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Text(
                              calculatorOperation.userQuestionToShow,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            calculatorOperation.userAnswer,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    child: Column(
                      children: [
                        buildButtonRow(context, [
                          'C',
                          'DEL',
                          '/',
                        ], [
                          2,
                          1,
                          1
                        ]),
                        buildButtonRow(context, ['7', '8', '9', 'x']),
                        buildButtonRow(context, ['4', '5', '6', '-']),
                        buildButtonRow(context, ['1', '2', '3', '+']),
                        buildButtonRow(context, ['.', '0', '='], [1, 1, 2]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, List<String> buttonLabels,
      [List<int>? flexValues]) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttonLabels.asMap().entries.map((entry) {
          int index = entry.key;
          String label = entry.value;
          return Expanded(
            flex: flexValues != null ? flexValues[index] : 1,
            child: MyButton(
              buttonTapped: () {
                setState(() {
                  calculatorOperation.buttonOperation(buttons.indexOf(label));
                });
              },
              color: getButtonColor(context, label),
              textColor: getTextColor(context, label),
              buttonText: label,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getButtonColor(BuildContext context, String label) {
    if (label == 'C') {
      return Colors.orange.shade300;
    } else if (label == 'DEL') {
      return Colors.red.shade300;
    } else if (label == '=') {
      return Colors.orange.shade300;
    } else if (isOperator(label)) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.surfaceBright;
    }
  }

  Color getTextColor(BuildContext context, String label) {
    if (label == 'C' || label == 'DEL' || label == '=') {
      return Theme.of(context).colorScheme.surfaceBright;
    } else {
      return Theme.of(context).colorScheme.inversePrimary;
    }
  }

  bool isOperator(String x) {
    return x == '/' || x == 'x' || x == '-' || x == '+' || x == '=';
  }
}
