import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyCalApp());
}

class MyCalApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(elevation: 5.0),
        ),
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _opAddPressed = false,
      _opDivPressed = false,
      _opMulPressed = false,
      _opSubPressed = false;
  double _size0 = 35.0, _size1 = 40.0, _size2 = 25.0;
  int _counter = 0, _input = 0, _operand = 0, _output = 0;
  Color _blue12 = Color(0xFF043458),
      _green11 = Color(0xFF9ED2BD),
      _green12 = Color(0xFFC7E1D4);
  List<int> _list = [];

  Widget _calculatorElevatedButton(
      double fontSize, String label, void function(),
      [bool isPressed, Color buttonColor, Color textColor]) {
    isPressed ??= false;
    return ElevatedButton(
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
      onPressed: function,
      style: ElevatedButton.styleFrom(
        primary:
            isPressed ? _blue12 : buttonColor ?? Theme.of(context).accentColor,
      ),
    );
  }

  void _addNumber(int number) {
    _input = int.parse('$_input$number');
    if (_counter > 0) {
      _input = number;
      _counter = 0;
    }
    _setState();
  }

  void _addOp() {
    _opAddPressed = true;
    _opDivPressed = false;
    _opMulPressed = false;
    _opSubPressed = false;
    _setState();
    (_output == 0)
        ? _output = _input
        : (_operand == 0)
            ? _operand = _input
            : {};
    (_input < 0) ? _output += -_operand : _output += _operand;
    (_input < 0) ? _input = -_output : _input = _output;
    _counter++;
  }

  void _clearNumber() {
    _opAddPressed = false;
    _opDivPressed = false;
    _opMulPressed = false;
    _opSubPressed = false;
    _input = 0;
    _counter = 0;
    _operand = 0;
    _output = 0;
    _list.clear();
    _setState();
  }

  void _divOp() {
    double _valueNaN = 0.0;
    if (_opAddPressed) _addOp();
    if (_opSubPressed) _subOp();
    _opAddPressed = false;
    _opDivPressed = true;
    _opMulPressed = false;
    _opSubPressed = false;
    _setState();
    switch (_list.length) {
      case 0:
        _list.add(_input);
        break;
      case 1:
        _list.add(_input);
        continue mul;
      mul:
      case 2:
        _valueNaN = _list[0] / _list[1];
        (_valueNaN.isNaN) ? _input = 404 : _input = _output;
        _list.removeAt(0);
        _list.insert(0, _input);
        break;
    }
    _counter++;
  }

  void _equalOp() {
    if (_opAddPressed) _addOp();
    if (_opDivPressed) _divOp();
    if (_opMulPressed) _mulOp();
    if (_opSubPressed) _subOp();
  }

  void _flipNumber() {
    _input = -_input;
    if (_opMulPressed) {
      _list.removeAt(0);
      _list.insert(0, _input);
    }
    _setState();
  }

  void _mulOp() {
    if (_opAddPressed) _addOp();
    if (_opSubPressed) _subOp();
    _opAddPressed = false;
    _opDivPressed = false;
    _opMulPressed = true;
    _opSubPressed = false;
    _setState();
    switch (_list.length) {
      case 0:
        _list.add(_input);
        break;
      case 1:
        _list.add(_input);
        continue mul;
      mul:
      case 2:
        _output = _list[0] * _list[1];
        _input = _output;
        _list.removeAt(0);
        _list.insert(0, _input);
        break;
    }
    _counter++;
  }

  void _removeNumber() {
    ('$_input'.length <= 1)
        ? _input = 0
        : _input = int.parse('$_input'.substring(0, '$_input'.length - 1));
    if (_opMulPressed) {
      _list.removeAt(0);
      _list.insert(0, _input);
    }
    _setState();
  }

  void _setState() => setState(() {});

  void _subOp() {
    _opAddPressed = false;
    _opDivPressed = false;
    _opMulPressed = false;
    _opSubPressed = true;
    _setState();
    (_output == 0)
        ? _output = _input
        : (_operand == 0)
            ? _operand = _input
            : {};
    (_input < 0) ? _output -= -_operand : _output -= _operand;
    (_input < 0) ? _input = -_output : _input = _output;
    _counter++;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Text(
              '$_input',
              // maxLines: 1,
              softWrap: true,
              style: TextStyle(fontSize: 75.0),
            ),
            height: 275.0,
            padding: EdgeInsets.all(_size2),
          ),
          Container(
            child: GridView.count(
              children: <Widget>[
                _calculatorElevatedButton(
                    _size2, 'C', _clearNumber, false, _green12, Colors.black),
                ElevatedButton(
                  child: Icon(
                    Icons.backspace,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: _removeNumber,
                  style: ElevatedButton.styleFrom(primary: _green12),
                ),
                _calculatorElevatedButton(
                    24.0, '+ / -', _flipNumber, false, _green12, Colors.black),
                _calculatorElevatedButton(_size1, '÷', _divOp, _opDivPressed),
                _calculatorElevatedButton(
                    _size0, '7', () => _addNumber(7), false, _green11),
                _calculatorElevatedButton(
                    _size0, '8', () => _addNumber(8), false, _green11),
                _calculatorElevatedButton(
                    _size0, '9', () => _addNumber(9), false, _green11),
                _calculatorElevatedButton(_size1, '×', _mulOp, _opMulPressed),
                _calculatorElevatedButton(
                    _size0, '4', () => _addNumber(4), false, _green11),
                _calculatorElevatedButton(
                    _size0, '5', () => _addNumber(5), false, _green11),
                _calculatorElevatedButton(
                    _size0, '6', () => _addNumber(6), false, _green11),
                _calculatorElevatedButton(_size1, '-', _subOp, _opSubPressed),
                _calculatorElevatedButton(
                    _size0, '1', () => _addNumber(1), false, _green11),
                _calculatorElevatedButton(
                    _size0, '2', () => _addNumber(2), false, _green11),
                _calculatorElevatedButton(
                    _size0, '3', () => _addNumber(3), false, _green11),
                _calculatorElevatedButton(_size1, '+', _addOp, _opAddPressed),
                ElevatedButton(
                  child: null,
                  onPressed: null,
                  style: ElevatedButton.styleFrom(onSurface: Colors.white),
                ),
                _calculatorElevatedButton(
                    _size0, '0', () => _addNumber(0), false, _green11),
                ElevatedButton(
                  child: null,
                  onPressed: null,
                  style: ElevatedButton.styleFrom(onSurface: Colors.white),
                ),
                _calculatorElevatedButton(_size1, '=', _equalOp),
              ],
              crossAxisCount: 4,
              crossAxisSpacing: _size2,
              mainAxisSpacing: _size2,
              padding: const EdgeInsets.all(25.0),
              primary: false,
            ),
            padding: EdgeInsets.only(top: 275.0),
          ),
        ],
      ),
    );
  }
}
