import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'create_page.dart'; // Import the CreatePage

import 'database_helper.dart';
import 'two_bars_icon.dart';
import 'utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.themeModeNotifier});

  final String title;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late AnimationController _controller;
  double _drawerOffset = 0.0;
  final double _maxSlide = 300.0; // Max width of the sidebar

  final ScrollController _scrollController = ScrollController();
  bool _showAddOptions = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  void _initAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _controller.addListener(() {
      setState(() {
        _drawerOffset = _controller.value * _maxSlide;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    double fractionDragged = details.primaryDelta! / _maxSlide;
    _controller.value += fractionDragged;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggleDrawer() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  void _toggleAddOptions() {
    setState(() {
      _showAddOptions = !_showAddOptions;
      if (_showAddOptions) {
        _currentIndex = 1;
      } else {
        _currentIndex = 0;
      }
    });
  }

  void _hideAddOptions() {
    setState(() {
      _showAddOptions = false;
      _currentIndex = 0;
    });
  }

  Widget _buildDrawer() {
    return Transform.translate(
      offset: Offset(_drawerOffset - _maxSlide, 0),
      child: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.user(PhosphorIconsStyle.regular)),
              title: const Text(
                'Maqsud Safin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(PhosphorIcons.gearSix(PhosphorIconsStyle.fill)),
              title: const Text(
                'Tənzimləmələr',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            const ListTile(
                leading: Icon(EneftyIcons.logout_outline),
                title: Text(
                  'Çıxıs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM y', 'az').format(now);
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: GestureDetector(
        onTap: _toggleDrawer,
        child: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Center(
            child: TwoBarsIcon(),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          _scrollToCurrentDate();
        },
        child: Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Switch(
          activeColor: Colors.black,
          inactiveThumbColor: Colors.black,
          trackColor: MaterialStateProperty.all(Colors.white),
          activeTrackColor: Colors.white,
          value: widget.themeModeNotifier.value == ThemeMode.dark,
          onChanged: (value) {
            widget.themeModeNotifier.value =
            value ? ThemeMode.dark : ThemeMode.light;
          },
        ),
      ],
    );
  }

  List<DateTime> _generateDateList() {
    DateTime now = DateTime.now();
    DateTime targetDate = DateTime(now.year, now.month + 6, now.day);
    DateTime startDate = DateTime(now.year, now.month - 1, now.day);

    List<DateTime> dateList = [];
    for (DateTime date = startDate;
    date.isBefore(targetDate);
    date = date.add(const Duration(days: 1))) {
      dateList.add(date);
    }
    return dateList;
  }

  void _scrollToCurrentDate() {
    DateTime now = DateTime.now();
    List<DateTime> dateList = _generateDateList();
    int currentIndex = dateList.indexOf(DateTime(now.year, now.month, now.day));

    if (currentIndex != -1) {
      _scrollController.animateTo(
        currentIndex * 65.0, // Assuming each item has a width of 60
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateList = _generateDateList();
    DateTime now = DateTime.now();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _hideAddOptions();
        },
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: Stack(
          children: [
            _buildDrawer(),
            Transform.translate(
              offset: Offset(_drawerOffset, 0),
              child: Scaffold(
                appBar: _buildAppBar(),
                body: Column(
                  children: [
                    SizedBox(
                      height: 65,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: dateList.length,
                        itemBuilder: (context, index) {
                          DateTime date = dateList[index];
                          String day = DateFormat('d', 'az').format(date);
                          String month = DateFormat('MMMM', 'az').format(date);
                          month = (month[0].toUpperCase() == "I"
                              ? "İ"
                              : month[0].toUpperCase()) +
                              month.substring(1);
                          String weekday = DateFormat('EEE', 'az').format(date);
                          bool isToday = date.year == now.year &&
                              date.month == now.month &&
                              date.day == now.day;
                          return Container(
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: isToday ? Colors.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(month,
                                    style: TextStyle(
                                        color: isToday
                                            ? Colors.white
                                            : getTextColor(context),
                                        fontWeight: FontWeight.bold)),
                                Text(day,
                                    style: TextStyle(
                                        color: isToday
                                            ? Colors.white
                                            : getTextColor(context),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                Text(weekday,
                                    style: TextStyle(
                                        color: isToday
                                            ? Colors.white
                                            : getTextColor(context),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Add other widgets below the ListView here
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          'Advanced Java',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 34, // TODO: if text is too long, decrease the font size
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        margin: const EdgeInsets.only(right: 30),
                                        child: const Text(
                                          "19:00 - 21:00\n"
                                              "Day 1 of 30",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "Stream API",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "This is a long description of the plan that is being created. "
                                          "It can be multiple lines long and should be displayed in a readable way.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: BottomNavigationBar(
                                    currentIndex: _currentIndex,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    selectedItemColor: Colors.blue, // Color for the selected item
                                    unselectedItemColor: Colors.grey, // Color for unselected items
                                    onTap: (int index) {
                                      setState(() {
                                        if (_currentIndex == index) {
                                          _showAddOptions = !_showAddOptions;
                                        } else {
                                          _currentIndex = index;
                                          _showAddOptions = false;
                                        }
                                      });
                                      if (index == 1) {
                                        _toggleAddOptions();
                                      } else {
                                        _hideAddOptions();
                                      }
                                    },
                                    items: const [
                                      BottomNavigationBarItem(
                                        icon: Icon(EneftyIcons.home_2_bold),
                                        label: 'Home',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Icon(EneftyIcons.add_square_bold),
                                        label: 'Add',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Icon(EneftyIcons.note_4_bold),
                                        label: 'Plans',
                                      ),
                                    ],
                                  ),
                                ),
                                if (_showAddOptions)
                                  Positioned(
                                    bottom: 70, // Adjust this value to control the position
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => CreatePage(headerText: "Task")),
                                            );
                                          },
                                          child: Text('New Task'),
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => CreatePage(headerText: "Plan")),
                                            );
                                          },
                                          child: Text('New Plan'),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}