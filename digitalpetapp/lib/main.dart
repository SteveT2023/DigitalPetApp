// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SetPetNameScreen(),
  ));
}

class SetPetNameScreen extends StatefulWidget {
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

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
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
      return 'assets/Happy.png'; // Happy
    } else if (happinessLevel >= 30) {
      return 'assets/Neutral.png'; // Neutral
    } else {
      return 'assets/Mad.png'; // Unhappy
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
        child: Column(
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
