import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
void main() {
setupWindow();
runApp(
// Provide the model to all widgets within the app. We're using
// ChangeNotifierProvider because that's a simple way to rebuild
// widgets when a model changes. We could also just use
// Provider, but then we would have to listen to Counter ourselves.
//
// Read Provider's docs to learn about all the available providers.
ChangeNotifierProvider(
// Initialize the model in the builder. That way, Provider
// can own Counter's lifecycle, making sure to call `dispose`
// when not needed anymore.
create: (context) => Counter(),
child: const MyApp(),
),
);
}
const double windowWidth = 360;
const double windowHeight = 640;
void setupWindow() {
if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
WidgetsFlutterBinding.ensureInitialized();
setWindowTitle('Provider Counter');
setWindowMinSize(const Size(windowWidth, windowHeight));
setWindowMaxSize(const Size(windowWidth, windowHeight));
getCurrentScreen().then((screen) {
setWindowFrame(Rect.fromCenter(
center: screen!.frame.center,
width: windowWidth,
height: windowHeight,
));
});
}
}
/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
int value = 0;
void increment() {
value += 1;
notifyListeners();
}
void decrement() {
  value -= 1;
  notifyListeners();
}

// Milestone logic based on current counter value
String get milestoneMessage {
  if (value <= 12) {
      return "You're a child!";
    } else if (value <= 19) {
      return "Teenager time!";
    } else if (value <= 30) {
      return "You're a young adult!";
    } else if (value <= 60) {
      return "You're an adult now!";
    } else if (value <= 65){
      return "Time to retire";
    } else {
      return "Golden years!";
    }
}

// Background color change based on the mileston
Color get milestoneColor {
  if (value <= 12) {
      return Colors.blue.shade200; // Childhood
    } else if (value <= 19) { //
      return Colors.green.shade200; // Teenage
    } else if (value <= 30) {
      return Colors.yellow.shade300; // Young Adult
    } else if (value <= 60) {
      return Colors.orange.shade300; // Adult
    } else if (value <= 65) {    // Senior
      return Colors.grey.shade300;
    } else {
      return Colors.limeAccent; // Retiree
    }
}

// Set the value using the slider
void setValue(double newValue) {
  value = newValue.toInt();
  notifyListeners();
}

// Logic for color change based on slider value
Color get sliderColor {
  // Logic for slider color change
  if (value <= 33) {
    return Colors.green; // Green for 0-33
      } else if (value <= 67){
    return Colors.yellow; // Yellow for 34-67
      } else {
    return Colors.red; // Red for 68-99
    }
  }
}
class MyApp extends StatelessWidget {
const MyApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Flutter Demo',
theme: ThemeData(
primarySwatch: Colors.blue,
useMaterial3: true,
),
home: const MyHomePage(),
);
}
}
// Home page with buttons to increment and decrement
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          return Container(
            color: counter.milestoneColor, // Background color based on counter
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    counter.milestoneMessage, // Milestone message
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.increment();
                    },
                    child: const Text('Increment'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.decrement();
                    },
                    child: const Text('Decrement'),
                  ),
                  const SizedBox(height: 20),
                  //Slider to change the value
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${counter.value}',
                    onChanged: (newValue) {
                      counter.setValue(newValue); // Set the counter value based on slider
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
