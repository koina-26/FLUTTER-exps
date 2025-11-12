import 'package:flutter/material.dart';

void main() => runApp(const BitBrain());

class BitBrain extends StatelessWidget {
  const BitBrain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitBrain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontSize: 22,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

/*-------------------- HOME --------------------*/
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      ['📝 Spelling Quiz', const SpellingQuiz()],
      ['🤔 Emoji Riddle', const EmojiRiddle()],
      ['✍️ Fill Missing Word', const FillBlank()],
      ['🔤 Word Scramble', const WordScramble()],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 BitBrain'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: games.length,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.deepPurple.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
              child: Text(
                games[i][0] as String,
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScoreWrapper(child: games[i][1] as Widget),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*-------------------- SCORE WRAPPER --------------------*/
class ScoreWrapper extends StatefulWidget {
  final Widget child;
  const ScoreWrapper({super.key, required this.child});

  @override
  State<ScoreWrapper> createState() => _ScoreWrapperState();
}

class _ScoreWrapperState extends State<ScoreWrapper> {
  int score = 0;

  void increment() => setState(() => score++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 BitBrain'),
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: (widget.child is ScoreAware)
          ? (widget.child as ScoreAware).withScoreCallback(increment)
          : widget.child,
    );
  }
}

abstract class ScoreAware extends Widget {
  Widget withScoreCallback(VoidCallback onScore);
}

/*-------------------- 1. Spelling Quiz --------------------*/
class SpellingQuiz extends StatefulWidget implements ScoreAware {
  const SpellingQuiz({super.key});
  @override
  State<SpellingQuiz> createState() =>
      _SpellingQuizPlaceholderState(); // FIX: Changed to return its own placeholder state

  @override
  Widget withScoreCallback(VoidCallback onScore) =>
      _SpellingQuizStateful(onScore: onScore);
}

// FIX: New placeholder State class for SpellingQuiz
class _SpellingQuizPlaceholderState extends State<SpellingQuiz> {
  @override
  Widget build(BuildContext context) {
    // This build method is intentionally empty because
    // the SpellingQuiz widget is a ScoreAware wrapper that
    // gets replaced by _SpellingQuizStateful in the ScoreWrapper
    // before its build method would typically be called.
    // It exists purely to satisfy the StatefulWidget contract.
    return const SizedBox.shrink();
  }
}

class _SpellingQuizStateful extends StatefulWidget {
  final VoidCallback onScore;
  const _SpellingQuizStateful({required this.onScore});
  @override
  State<_SpellingQuizStateful> createState() => _SpellingQuizState();
}

class _SpellingQuizState extends State<_SpellingQuizStateful> {
  final data = [
    {
      'correct': 'Paradigm',
      'options': ['Paradime', 'Paradigm', 'Paradygm'],
    },
    {
      'correct': 'Hegemony',
      'options': ['Hegemony', 'Hegamony', 'Hegamoni'],
    },
    {
      'correct': 'Pragmatic',
      'options': ['Pragmatic', 'Pregmatic', 'Pragmettic'],
    },
    {
      'correct': 'Meticulous',
      'options': ['Meticulus', 'Meticulous', 'Meticulious'],
    },
    {
      'correct': 'Ephemeral',
      'options': ['Ephemral', 'Ephemeral', 'Ephemeerel'],
    },
  ];
  int i = 0;
  String? selected;
  String result = '';

  @override
  Widget build(BuildContext context) {
    final q = data[i];
    return _GradientBody(
      title: '📝 Spelling Quiz',
      child: Column(
        children: [
          const Text(
            'Which spelling is correct?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...(q['options']! as List<String>).map(
            (opt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade200,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  setState(() {
                    selected = opt;
                    if (opt == q['correct']) {
                      result = '✅ Correct!';
                      widget.onScore();
                    } else {
                      result = '❌ Correct: ${q['correct']}';
                    }
                  });
                },
                child: Text(opt, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(result, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade300,
              foregroundColor: Colors.white,
            ),
            onPressed: () => setState(() {
              i = (i + 1) % data.length;
              selected = null;
              result = '';
            }),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

/*-------------------- 2. Emoji Riddle --------------------*/
class EmojiRiddle extends StatefulWidget implements ScoreAware {
  const EmojiRiddle({super.key});
  @override
  State<EmojiRiddle> createState() =>
      _EmojiRiddlePlaceholderState(); // Fix: Point to its own placeholder state

  @override
  Widget withScoreCallback(VoidCallback onScore) =>
      _EmojiRiddleStateful(onScore: onScore);
}

// Fix: New placeholder State class for EmojiRiddle
class _EmojiRiddlePlaceholderState extends State<EmojiRiddle> {
  @override
  Widget build(BuildContext context) {
    // This build method is intentionally empty because
    // the EmojiRiddle widget is a ScoreAware wrapper that
    // gets replaced by _EmojiRiddleStateful in the ScoreWrapper
    // before its build method would typically be called.
    // It exists purely to satisfy the StatefulWidget contract.
    return const SizedBox.shrink();
  }
}

class _EmojiRiddleStateful extends StatefulWidget {
  final VoidCallback onScore;
  const _EmojiRiddleStateful({required this.onScore});
  @override
  State<_EmojiRiddleStateful> createState() => _EmojiRiddleState();
}

class _EmojiRiddleState extends State<_EmojiRiddleStateful> {
  final riddles = [
    {'emoji': '🤖🧠', 'answer': 'artificial intelligence'},
    {'emoji': '🚀🌕', 'answer': 'moon landing'},
    {'emoji': '💻🔒', 'answer': 'cyber security'},
    {'emoji': '📱🍏', 'answer': 'iphone'},
    {'emoji': '🛰️🌍', 'answer': 'satellite'},
  ];
  int i = 0;
  final controller = TextEditingController();
  String msg = '';

  @override
  Widget build(BuildContext context) => _GradientBody(
        title: '🤔 Emoji Riddle',
        child: Column(
          children: [
            Text(
              riddles[i]['emoji']!,
              style: const TextStyle(fontSize: 60, letterSpacing: 4),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your guess',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade300,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (controller.text.trim().toLowerCase() ==
                      riddles[i]['answer']) {
                    msg = '✅ Correct!';
                    widget.onScore();
                  } else {
                    msg = '❌ Try again';
                  }
                });
              },
              child: const Text('Check'),
            ),
            Text(msg, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade300,
                foregroundColor: Colors.white,
              ),
              onPressed: () => setState(() {
                i = (i + 1) % riddles.length;
                controller.clear();
                msg = '';
              }),
              child: const Text('Next'),
            ),
          ],
        ),
      );
}

/*-------------------- 3. Fill Blank --------------------*/
class FillBlank extends StatefulWidget implements ScoreAware {
  const FillBlank({super.key});
  @override
  State<FillBlank> createState() =>
      _FillBlankPlaceholderState(); // FIX: Changed to return its own placeholder state

  @override
  Widget withScoreCallback(VoidCallback onScore) =>
      _FillBlankStateful(onScore: onScore);
}

// FIX: New placeholder State class for FillBlank
class _FillBlankPlaceholderState extends State<FillBlank> {
  @override
  Widget build(BuildContext context) {
    // This build method is intentionally empty because
    // the FillBlank widget is a ScoreAware wrapper that
    // gets replaced by _FillBlankStateful in the ScoreWrapper
    // before its build method would typically be called.
    // It exists purely to satisfy the StatefulWidget contract.
    return const SizedBox.shrink();
  }
}

class _FillBlankStateful extends StatefulWidget {
  final VoidCallback onScore;
  const _FillBlankStateful({required this.onScore});
  @override
  State<_FillBlankStateful> createState() => _FillBlankState();
}

class _FillBlankState extends State<_FillBlankStateful> {
  final qs = [
    {
      'q': 'Flutter is developed by ___',
      'a': 'Google',
      'opts': ['Apple', 'Google'],
    },
    {
      'q': 'AI stands for ___',
      'a': 'Artificial Intelligence',
      'opts': ['Automated Input', 'Artificial Intelligence'],
    },
    {
      'q': 'Capital of Japan is ___',
      'a': 'Tokyo',
      'opts': ['Beijing', 'Tokyo'],
    },
    {
      'q': 'National animal of India is ___',
      'a': 'Tiger',
      'opts': ['Elephant', 'Tiger'],
    },
    {
      'q': 'Founder of Microsoft is ___',
      'a': 'Bill Gates',
      'opts': ['Steve Jobs', 'Bill Gates'],
    },
  ];
  int i = 0;
  String result = '';

  @override
  Widget build(BuildContext context) {
    final q = qs[i];
    return _GradientBody(
      title: '✍️ Fill the Blank',
      child: Column(
        children: [
          Text(
            q['q']! as String,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...(q['opts']! as List<String>).map(
            (o) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (o == q['a']) {
                      result = '✅ Correct!';
                      widget.onScore();
                    } else {
                      result = '❌ Correct: ${q['a']}';
                    }
                  });
                },
                child: Text(o),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(result, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          ElevatedButton(
            onPressed: () => setState(() {
              i = (i + 1) % qs.length;
              result = '';
            }),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

/*-------------------- 4. Word Scramble --------------------*/
class WordScramble extends StatefulWidget implements ScoreAware {
  const WordScramble({super.key});
  @override
  // FIX: Changed to return its own placeholder state
  State<WordScramble> createState() => _WordScramblePlaceholderState();

  @override
  Widget withScoreCallback(VoidCallback onScore) =>
      _WordScrambleStateful(onScore: onScore);
}

// FIX: New placeholder State class for WordScramble
class _WordScramblePlaceholderState extends State<WordScramble> {
  @override
  Widget build(BuildContext context) {
    // This build method is intentionally empty because
    // the WordScramble widget is a ScoreAware wrapper that
    // gets replaced by _WordScrambleStateful in the ScoreWrapper
    // before its build method would typically be called.
    // It exists purely to satisfy the StatefulWidget contract.
    return const SizedBox.shrink();
  }
}

class _WordScrambleStateful extends StatefulWidget {
  final VoidCallback onScore;
  const _WordScrambleStateful({required this.onScore});
  @override
  State<_WordScrambleStateful> createState() => _WordScrambleState();
}

class _WordScrambleState extends State<_WordScrambleStateful> {
  final words = ['python', 'flutter', 'google', 'cyber', 'planet'];
  late String word;
  late List<String> letters;
  String built = '';
  String msg = '';

  @override
  void initState() {
    super.initState();
    newWord();
  }

  void newWord() {
    word = (words..shuffle()).first;
    letters = word.split('')..shuffle();
    built = '';
    msg = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => _GradientBody(
        title: '🔤 Word Scramble',
        child: Column(
          children: [
            const Text(
              'Unscramble the word:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(built, style: const TextStyle(fontSize: 24)),
            Wrap(
              children: letters
                  .map(
                    (l) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            built += l;
                            letters.remove(l);
                            if (built == word) {
                              msg = '✅ Solved!';
                              widget.onScore();
                            }
                          });
                        },
                        child: Text(
                          l.toUpperCase(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Text(msg, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(onPressed: newWord, child: const Text('New Word')),
          ],
        ),
      );
}

/*-------------------- Helper --------------------*/
class _GradientBody extends StatelessWidget {
  final String title;
  final Widget child;
  const _GradientBody({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      );
}
