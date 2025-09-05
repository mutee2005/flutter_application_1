import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(ReadingCompanionApp());
}

class ReadingCompanionApp extends StatefulWidget {
  @override
  _ReadingCompanionAppState createState() => _ReadingCompanionAppState();
}

class _ReadingCompanionAppState extends State<ReadingCompanionApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Companion',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.greenAccent),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onToggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  HomePage({required this.isDarkMode, required this.onToggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> books = [];
  final List<String> futureReads = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _futureListKey =
      GlobalKey<AnimatedListState>();

  List<String> quotes = [
    "The mind is everything. What you think you become.",
    "Reading is to the mind what exercise is to the body.",
    "Happiness depends upon ourselves. – Aristotle",
    "The unexamined life is not worth living. – Socrates",
    "Like a wildflower, you must allow yourself to grow in unexpected places.",
    "Do small things with great love.",
    "Believe you can and you’re halfway there.",
    "So many books, so little time. – Frank Zappa",
    "Like a favorite story, you’re unforgettable.",
  ];

  TextEditingController bookController = TextEditingController();
  TextEditingController futureBookController = TextEditingController();
  DateTime? selectedDate;

  String getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  bool isBirthday() {
    final now = DateTime.now();
    return (now.month == 9 && now.day == 12);
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _addBook(String book) {
    final dateText =
        selectedDate != null ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}" : "No date";
    final bookEntry = {"title": book, "date": dateText};

    books.insert(0, bookEntry);
    _listKey.currentState?.insertItem(0);

    bookController.clear();
    selectedDate = null;
  }

  void _removeBook(int index) {
    final removedBook = books.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildBookCard(removedBook, animation),
    );
  }

  void _addFutureBook(String book) {
    futureReads.insert(0, book);
    _futureListKey.currentState?.insertItem(0);
    futureBookController.clear();
  }

  void _removeFutureBook(int index) {
    final removedBook = futureReads.removeAt(index);
    _futureListKey.currentState?.removeItem(
      index,
      (context, animation) => _buildFutureBookCard(removedBook, animation),
    );
  }

  Widget _buildBookCard(Map<String, String> book, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            book["title"] ?? "",
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text("Date: ${book["date"]}"),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              int index = books.indexOf(book);
              if (index >= 0) _removeBook(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFutureBookCard(String book, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            book,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              int index = futureReads.indexOf(book);
              if (index >= 0) _removeFutureBook(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📚 Reading Companion"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  color: Colors.green,
                ),
              ),

            Text(
              "✨ Daily Quote: \n${getRandomQuote()}",
              style: GoogleFonts.poppins(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            Divider(),

            // Add Book Section
            TextField(
              controller: bookController,
              decoration: InputDecoration(
                labelText: "Add a book you’re reading or have read",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text("Pick Date"),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (bookController.text.trim().isNotEmpty) {
                      _addBook(bookController.text.trim());
                    }
                  },
                  child: Text("Add Book"),
                ),
              ],
            ),

            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: books.length,
                itemBuilder: (context, index, animation) {
                  return _buildBookCard(books[index], animation);
                },
              ),
            ),

            Divider(),

            // Future Reads Section
            TextField(
              controller: futureBookController,
              decoration: InputDecoration(
                labelText: "Add to Future Reads",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (futureBookController.text.trim().isNotEmpty) {
                  _addFutureBook(futureBookController.text.trim());
                }
              },
              child: Text("Add to Future Reads"),
            ),
            Expanded(
              child: AnimatedList(
                key: _futureListKey,
                initialItemCount: futureReads.length,
                itemBuilder: (context, index, animation) {
                  return _buildFutureBookCard(futureReads[index], animation);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BootsParadeAnimation(),
    );
  }
}

// 👢 Multiple boots walking + bouncing animation
class BootsParadeAnimation extends StatefulWidget {
  @override
  _BootsParadeAnimationState createState() => _BootsParadeAnimationState();
}

class _BootsParadeAnimationState extends State<BootsParadeAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _walkAnimations;
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

    _walkAnimations = _controllers
        .map((c) => Tween<double>(begin: -60, end: 60).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    _bounceAnimations = _controllers
        .map((c) => Tween<double>(begin: 0, end: -10).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOutSine),
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
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_walkAnimations.length, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              return Transform.translate(
                offset:
                    Offset(_walkAnimations[i].value, _bounceAnimations[i].value),
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
