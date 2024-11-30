import 'package:flutter/material.dart';
import 'package:numbers_to_text/numbers_to_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();
  String _convertedText = '';

  // Fonction pour convertir le nombre entier en mots en anglais
  String convertToEnglish(int number) {
    final converter = NumbersToTextConverter("en");
    return converter.fromInt(number);
  }

  //  convertir le nombre entier en mots en arabe
  String convertToArabic(int number) {
    final converter = NumbersToTextConverter("ar");
    return converter.fromInt(number);
  }

  String convertDecimalToWords(double number, String language) {
    // Sépare la partie entière et la partie décimale
    int integerPart = number.toInt();
    int decimalPart = ((number - integerPart) * 1000)
        .round(); // Convertit en millimes pour l'arabe

    String integerText;
    String currencyText;

    //  arabe
    if (language == 'arabic') {
      integerText = convertToArabic(integerPart);
      currencyText = 'دينار'; // Dinar

      //  le nombre de millimes
      if (decimalPart > 0) {
        String decimalText = convertToArabic(decimalPart);
        return '$integerText $currencyText و $decimalText مليم'; // Combine les deux pour l'arabe
      }
      return '$integerText $currencyText'; // Retourne seulement la partie entière
    }
    // Traitement en anglais
    else {
      integerText = convertToEnglish(integerPart);
      currencyText = 'dollar'; // Dollar

      // Convertit le nombre de cents en texte
      int cents = ((number - integerPart) * 100).round();
      if (cents > 0) {
        String decimalText = convertToEnglish(cents);
        return '$integerText $currencyText and $decimalText cent'; // Combine les deux pour l'anglais
      }
      return '$integerText $currencyText'; // Retourne seulement la partie entière
    }
  }

  void _convert(String language) {
    setState(() {
      double? number = double.tryParse(_controller.text);
      if (number != null) {
        _convertedText = convertDecimalToWords(number, language);
      } else {
        _convertedText =
        'Please enter a valid number'; // Message d'erreur pour une entrée invalide
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Number to Words',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Workshop 2',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  backgroundColor: Colors.purple,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a number',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _convert('arabic'),
                child: Text('Convert to Arabic'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
              ),
              ElevatedButton(
                onPressed: () => _convert('english'),
                child: Text('Convert to English'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _convertedText,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
