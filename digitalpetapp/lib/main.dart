// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SetPetNameScreen(),
  ));
}

class SetPetNameScreen extends StatefulWidget {
  const SetPetNameScreen({super.key});

  @override
  _SetPetNameScreenState createState() => _SetPetNameScreenState();
}

class _SetPetNameScreenState extends State<SetPetNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _confirmName() {
    if (_nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DigitalPetApp(petName: _nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Pet Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter Pet Name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _confirmName,
              child: Text('Confirm Name'),
            ),
          ],
        ),
      ),
    );
  }
}

class DigitalPetApp extends StatefulWidget {
  final String petName;

  const DigitalPetApp({super.key, required this.petName});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;
  Timer? _checkConditionsTimer;
  bool _lose = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startCheckConditionsTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _checkConditionsTimer?.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
      });
    });
  }

  void _startCheckConditionsTimer() {
    _checkConditionsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (hungerLevel >= 100 || happinessLevel <= 0) {
        setState(() {
          _lose = true;
        });
        _hungerTimer?.cancel();
        _checkConditionsTimer?.cancel();
      }
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Determine the background color based on happiness level
  Color _getBackgroundColor() {
    if (happinessLevel > 70) {
      return const Color.fromARGB(255, 186, 252, 188); // Happy
    } else if (happinessLevel >= 30) {
      return const Color.fromARGB(255, 211, 197, 72); // Neutral
    } else {
      return const Color.fromARGB(255, 255, 147, 140); // Unhappy
    }
  }

  // Determine the pet's icon based on happiness level
  String _getPetIcon() {
    if (happinessLevel > 70) {
      return 'file:///Users/clr.img/Downloads/Happy.png'; // Happy
    } else if (happinessLevel >= 30) {
      return 'file:///Users/clr.img/Downloads/Neutral.png'; // Neutral
    } else {
      return 'file:///Users/clr.img/Downloads/Unhappy.png'; // Unhappy
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      backgroundColor: _getBackgroundColor(),
      body: Center(
        child: _lose
            ? Text(
                'Game Over',
                style: TextStyle(fontSize: 30.0, color: Colors.red),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Name: ${widget.petName}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Happiness Level: $happinessLevel',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Hunger Level: $hungerLevel',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 32.0),
                  Image.network(
                    _getPetIcon(),
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _playWithPet,
                    child: Text('Play with Your Pet'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    child: Text('Feed Your Pet'),
                  ),
                ],
              ),
      ),
    );
  }
}
