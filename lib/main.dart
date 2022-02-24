import 'package:flutter/material.dart';
import 'package:page_view/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String pageIndexKey = 'pageIndex';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final SharedPreferences prefs = await _prefs;
  final int pageIndex = prefs.getInt(pageIndexKey) ?? 0;

  print('Retreived pageIndex from SharedPrefs: $pageIndex');

  runApp(MyApp(pageIndex: pageIndex));
}

class MyApp extends StatelessWidget {
  final int pageIndex;
  const MyApp({Key? key, required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(pageIndex: pageIndex),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int pageIndex;
  const MyHomePage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  late PageController _controller;

  @override
  void initState() {
    _currentPageIndex = widget.pageIndex;
    _controller = PageController(
      initialPage: widget.pageIndex,
    );
    super.initState();
  }

  String title = 'TODO: Update me';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: const [
          Page1(),
          Page2(),
          Page3(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (newIndex) async {
          final SharedPreferences _prefs =
              await SharedPreferences.getInstance();
          _prefs.setInt(pageIndexKey, newIndex);
          _controller.jumpToPage(newIndex);
          setState(() {
            _currentPageIndex = newIndex;
          });
          // TODO: Persist in shared_prefs
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.no_food_outlined),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
