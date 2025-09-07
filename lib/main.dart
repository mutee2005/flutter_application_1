import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // for json encoding/decoding

void main() {
  runApp(ReadingCompanionApp());
}

class ReadingCompanionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Companion',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: Colors.green[800],
        scaffoldBackgroundColor: Colors.green[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          secondary: Colors.greenAccent,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> books = [];
  List<String> notes = [];
  TextEditingController controller = TextEditingController();
  TextEditingController noteController = TextEditingController();

  List<String> quotes = [
    "The mind is everything. What you think you become.",
    "Reading is to the mind what exercise is to the body.",
    "Happiness depends upon ourselves. – Aristotle",
    "The unexamined life is not worth living. – Socrates",
    "Like a wildflower, you must allow yourself to grow in all the places people never thought you would.",
    "Do small things with great love.",
    "Believe you can and you’re halfway there.",
    "So many books, so little time. – Frank Zappa",
    "Like a favorite story, you’re unforgettable.",
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      books = prefs.getStringList('books') ?? [];
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('books', books);
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', notes);
  }

  String getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  bool isBirthday() {
    final now = DateTime.now();
    return (now.month == 9 && now.day == 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📚 Reading Companion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "For Isra ",
                style: GoogleFonts.dancingScript(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 12),
              if (isBirthday())
                Text(
                  "🎉 Happy Birthday Isra! 💚\nWishing you joy, love, and endless good books 📖",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              Text(
                "✨ Daily Quote: \n${getRandomQuote()}",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Divider(),

              // Add Book Section
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Add a book you're reading or have read"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    setState(() {
                      books.add(controller.text.trim());
                    });
                    saveBooks();
                    controller.clear();
                  }
                },
                child: Text("Add Book"),
              ),
              SizedBox(height: 16),

              // Book List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(books[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            books.removeAt(index);
                          });
                          saveBooks();
                        },
                      ),
                    ),
                  );
                },
              ),

              Divider(),

              // Notes Section
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: "Add a note (future books etc.)"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (noteController.text.trim().isNotEmpty) {
                    setState(() {
                      notes.add(noteController.text.trim());
                    });
                    saveNotes();
                    noteController.clear();
                  }
                },
                child: Text("Add Note"),
              ),
              SizedBox(height: 16),

              // Notes List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(notes[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            notes.removeAt(index);
                          });
                          saveNotes();
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BootsParadeAnimation(),
    );
  }
}

class BootsParadeAnimation extends StatefulWidget {
  @override
  _BootsParadeAnimationState createState() => _BootsParadeAnimationState();
}

class _BootsParadeAnimationState extends State<BootsParadeAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _bounceAnimations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 3 + i),
      )..repeat(reverse: true),
    );

    _animations = _controllers
        .map((c) => Tween<double>(begin: -60, end: 60).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    _bounceAnimations = _controllers
        .map((c) => Tween<double>(begin: 0, end: 8).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_animations.length, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_animations[i].value, _bounceAnimations[i].value),
                child: Text(
                  "👢",
                  style: TextStyle(fontSize: 36),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
