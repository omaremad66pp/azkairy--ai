import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AzkariAIApp());
}

class AzkariAIApp extends StatefulWidget {
  const AzkariAIApp({Key? key}) : super(key: key);

  @override
  State<AzkariAIApp> createState() => _AzkariAIAppState();
}

class _AzkariAIAppState extends State<AzkariAIApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  double _fontSize = 22.0;
  bool _isSmartAlarmEnabled = true;

  void toggleTheme(bool isDark) {
    setState(() { _themeMode = isDark ? ThemeMode.dark : ThemeMode.light; });
  }

  void updateFontSize(double size) {
    setState(() { _fontSize = size; });
  }

  void toggleAlarmSetting(bool value) {
    setState(() { _isSmartAlarmEnabled = value; });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أذكاري AI الأسطوري',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        primaryColor: const Color(0xFF5D48B7),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111E),
        primaryColor: const Color(0xFF5D48B7),
        cardColor: const Color(0xFF1B1E2E),
      ),
      home: MainLayoutScreen(
        onThemeChanged: toggleTheme,
        fontSize: _fontSize,
        onFontSizeChanged: updateFontSize,
        isSmartAlarmEnabled: _isSmartAlarmEnabled,
        onAlarmSettingChanged: toggleAlarmSetting,
      ),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final bool isSmartAlarmEnabled;
  final Function(bool) onAlarmSettingChanged;

  const MainLayoutScreen({
    Key? key,
    required this.onThemeChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.isSmartAlarmEnabled,
    required this.onAlarmSettingChanged,
  }) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 3; 
  late List<Widget> _screens;

  @override
  Widget build(BuildContext context) {
    _screens = [
      SettingsTab(
        onThemeChanged: widget.onThemeChanged,
        fontSize: widget.fontSize,
        onFontSizeChanged: widget.onFontSizeChanged,
        isSmartAlarmEnabled: widget.isSmartAlarmEnabled,
        onAlarmSettingChanged: widget.onAlarmSettingChanged,
      ),
      AlarmTab(isSmartAlarmEnabled: widget.isSmartAlarmEnabled),
      const AzkarTab(),
      QuranTab(fontSize: widget.fontSize),
      const PrayerTab(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161926),
        selectedItemColor: const Color(0xFF9D8BFF),
        unselectedItemColor: Colors.white38,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'مساعد AI'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism_outlined), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'القرآن'),
          BottomNavigationBarItem(icon: Icon(Icons.mosque_outlined), label: 'الصلوات'),
        ],
      ),
    );
  }
}

class PrayerTab extends StatefulWidget {
  const PrayerTab({Key? key}) : super(key: key);
  @override
  State<PrayerTab> createState() => _PrayerTabState();
}

class _PrayerTabState extends State<PrayerTab> {
  double _compassAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة والقبلة'), backgroundColor: const Color(0xFF161926), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('بوصلة اتجاه القبلة التفاعلية الذكية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('حرك البوصلة بإصبعك لتحديد اتجاه الكعبة الشريفة محلياً', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 15),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() { _compassAngle += details.delta.dx * 0.02; });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF9D8BFF), width: 4),
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  Transform.rotate(
                    angle: _compassAngle,
                    child: const Icon(Icons.navigation, size: 100, color: Color(0xFF9D8BFF)),
                  ),
                  const Positioned(top: 15, child: Text('🕋 مكة', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildPrayerRow('الفجر', '4:05 ص', Icons.wb_twilight),
                  _buildPrayerRow('الظهر', '12:57 م', Icons.wb_sunny),
                  _buildPrayerRow('العصر', '4:33 م', Icons.filter_drama),
                  _buildPrayerRow('المغرب', '8:00 م', Icons.wb_cloudy),
                  _buildPrayerRow('العشاء', '9:34 م', Icons.nightlight_round),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Text(time, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0xFF9D8BFF)),
        ],
      ),
    );
  }
}

class QuranTab extends StatefulWidget {
  final double fontSize;
  const QuranTab({Key? key, required this.fontSize}) : super(key: key);

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  List _surahs = [];
  bool _isLoading = true;
  String _errorMsg = '';

  Future<void> loadQuranData() async {
    try {
      final String response = await rootBundle.loadString('assets/quran.json');
      final data = await json.decode(response);
      setState(() {
        _surahs = data['surahs'] ?? data['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'تأكد من إعداد ملف pubspec.yaml والمسار بشكل صحيح.';
        _isLoading = false;
      });
    }
