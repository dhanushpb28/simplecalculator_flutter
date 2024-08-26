import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = "0";
  String _outputMemory = "0";
  String _operator = "";
  bool isScientific = false;

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _outputMemory = "0";
        _operator = "";
      } else if (buttonText == "⌫") {
        _output = _output.length > 1 ? _output.substring(0, _output.length - 1) : "0";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        _outputMemory = _output;
        _operator = buttonText;
        _output = "0";
      } else if (buttonText == "=") {
        _output = _calculate(_outputMemory, _output, _operator);
      } else if (buttonText == "√") {
        _output = sqrt(double.parse(_output)).toString();
      } else if (buttonText == "sin") {
        _output = sin(_degreesToRadians(double.parse(_output))).toString();
      } else if (buttonText == "cos") {
        _output = cos(_degreesToRadians(double.parse(_output))).toString();
      } else if (buttonText == "tan") {
        _output = tan(_degreesToRadians(double.parse(_output))).toString();
      } else {
        _output += buttonText;
        if (_output.startsWith("0") && !_output.contains(".")) {
          _output = _output.substring(1);
        }
      }
    });
  }

  String _calculate(String num1, String num2, String operator) {
    double number1 = double.parse(num1);
    double number2 = double.parse(num2);
    switch (operator) {
      case "+":
        return (number1 + number2).toString();
      case "-":
        return (number1 - number2).toString();
      case "×":
        return (number1 * number2).toString();
      case "÷":
        return (number1 / number2).toString();
      default:
        return "0";
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _toggleScientific() {
    setState(() {
      isScientific = !isScientific;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _toggleScientific,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(32),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          Column(
            children: [
              _buildButtonRow(["C", "⌫", "%", "÷"]),
              _buildButtonRow(["7", "8", "9", "×"]),
              _buildButtonRow(["4", "5", "6", "-"]),
              _buildButtonRow(["1", "2", "3", "+"]),
              _buildButtonRow(["0", ".", "=",]),
              if (isScientific)
                _buildButtonRow(["sin", "cos", "tan", "√"]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttonTexts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonTexts.map((buttonText) {
        return CalculatorButton(
          text: buttonText,
          onPressed: () => _onPressed(buttonText),
        );
      }).toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CalculatorButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool isOperator = ["+", "-", "×", "÷", "="].contains(text);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: isOperator ? Colors.orange : Colors.grey[800], padding: EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }
}
