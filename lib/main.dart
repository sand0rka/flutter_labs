import 'package:flutter/material.dart';

void main() {
  runApp(const SavingsApp());
}

class SavingsApp extends StatefulWidget {
  const SavingsApp({super.key});

  @override
  State<SavingsApp> createState() => SavingsAppState();
}

class SavingsAppState extends State<SavingsApp> {
  final TextEditingController controller = TextEditingController();
  static const double goal = 10000;
  double remaining = goal;
  final List<String> transactions = [];

  void _addMoney() {
    final String input = controller.text.trim();
    final double? amount = double.tryParse(input);

    setState(() {
      if (amount != null && amount > 0) {
        remaining = (remaining - amount).clamp(0, goal);
        transactions.insert(0, 'Додано: $amount грн');
        if (remaining == 0) {
          transactions.insert(0, '🎉 Збір успішно завершено! 🎉');
        }
      } else {
        transactions.insert(0, '⚠ Некоректне значення: "$input"');
      }
    });

    controller.clear();
  }

  void _reset() {
    setState(() {
      remaining = goal;
      transactions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('Savings app')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Введіть суму',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addMoney(),
              ),
              const SizedBox(height: 20),
              Text(
                'Залишилось зібрати: $remaining грн',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addMoney,
                    child: const Text('Додати'),
                  ),
                  ElevatedButton(
                    onPressed: _reset,
                    child: const Text('Скинути'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        transactions[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: transactions[index].contains('⚠')
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
