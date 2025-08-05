import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayZen Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PayZen API Test on Mac'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();

  void _registerNewUser() {
    final email = 'user_mac_${DateTime.now().millisecondsSinceEpoch}@example.com';
    print('Attempting to register new user from Mac...');
    apiService.registerUser('Mac Test User', email, 'password123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Press the button to register a new user via the API.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _registerNewUser,
        tooltip: 'Register User',
        child: const Icon(Icons.add),
      ),
    );
  }
}