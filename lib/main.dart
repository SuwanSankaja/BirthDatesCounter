import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(DaysCounterApp());
}

class DaysCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Days Lived Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0D47A1)),
      ),
      home: DaysCounterHome(),
    );
  }
}

class DaysCounterHome extends StatefulWidget {
  @override
  _DaysCounterHomeState createState() => _DaysCounterHomeState();
}

class _DaysCounterHomeState extends State<DaysCounterHome> {
  final List<Map<String, dynamic>> _counters = [];

  void _addNewCounter() {
    String title = '';
    DateTime? birthDate;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New Counter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title (e.g., My Age)'),
              onChanged: (val) => title = val,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) birthDate = picked;
              },
              child: Text('Pick Birth Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty && birthDate != null) {
                final days = DateTime.now().difference(birthDate!).inDays;
                setState(() {
                  _counters.add({
                    'title': title,
                    'birthDate': birthDate,
                    'days': days,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  double getCardHeight(int total) {
    if (total == 1) return 200;
    if (total <= 3) return 150;
    return 120;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Days Lived",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _counters.isEmpty
            ? Center(
                child: Text(
                  'No counters added yet.\nTap + to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _counters.length,
                itemBuilder: (context, index) {
                  final counter = _counters[index];

                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400),
                    tween: Tween(begin: 0.9, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: getCardHeight(_counters.length),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  counter['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.blueGrey[800],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _counters.removeAt(index)),
                                child: Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '🎉 ${counter['days']} days',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '📅 Born: ${DateFormat('yyyy/MM/dd').format(counter['birthDate'])}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCounter,
        backgroundColor: Colors.tealAccent[700],
        elevation: 8,
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}
