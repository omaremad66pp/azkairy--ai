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
  }

  @override
  void initState() {
    super.initState();
    loadQuranData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصحف الشريف الكامل (أوفلاين)'), backgroundColor: const Color(0xFF161926), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9D8BFF)))
          : _errorMsg.isNotEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_errorMsg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent))))
              : ListView.builder(
                  itemCount: _surahs.length,
                  itemBuilder: (context, index) {
                    final surah = _surahs[index];
                    final int surahNum = surah['number'] ?? (index + 1);
                    final String surahName = surah['name'] ?? 'سورة جديدة';
                    final List ayahsList = surah['ayahs'] ?? [];

                    return Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        trailing: CircleAvatar(
                          backgroundColor: const Color(0xFF5D48B7),
                          child: Text('$surahNum', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        title: Text(surahName, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('عدد الآيات الحقيقية: ${ayahsList.length}', textAlign: TextAlign.right),
                        leading: const Icon(Icons.chrome_reader_mode, color: Color(0xFF9D8BFF)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RealSurahViewer(
                                name: surahName,
                                ayahs: ayahsList,
                                fontSize: widget.fontSize,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class RealSurahViewer extends StatelessWidget {
  final String name;
  final List ayahs;
  final double fontSize;

  const RealSurahViewer({Key? key, required this.name, required this.ayahs, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سورة $name'), backgroundColor: const Color(0xFF161926)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (name != "التوبة" && name != "سورة التوبة")
              const Text(
                "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 10,
                    children: List.generate(ayahs.length, (index) {
                      final String text = ayahs[index]['text'] ?? '';
                      return Text(
                        '$text ﴿${index + 1}﴾ ',
                        style: TextStyle(fontSize: fontSize, height: 1.8),
                        textAlign: TextAlign.justify,
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AzkarTab extends StatefulWidget {
  const AzkarTab({Key? key}) : super(key: key);
  @override
  State<AzkarTab> createState() => _AzkarTabState();
}

class _AzkarTabState extends State<AzkarTab> {
  int _counter = 0;
  final List<String> _azkar = [
    "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لا شريك له.",
    "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.",
    "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلقتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ."
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF161926),
          bottom: const TabBar(
            tabs: [Tab(text: 'المسبحة الذكية'), Tab(text: 'قائمة الأذكار')],
            indicatorColor: Color(0xFF9D8BFF),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('أستغفر الله العظيم وأتوب إليه', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () { setState(() => _counter++); HapticFeedback.vibrate(); },
                  child: Container(
                    width: 160, height: 160,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF5D48B7)),
                    child: Center(child: Text('$_counter', style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                TextButton(onPressed: () => setState(() => _counter = 0), child: const Text('تصفير المسبحة', style: TextStyle(color: Colors.redAccent)))
              ],
            ),
            ListView.builder(
              itemCount: _azkar.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Theme.of(context).cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(_azkar[index], textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, height: 1.4)),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class AlarmTab extends StatefulWidget {
  final bool isSmartAlarmEnabled;
  const AlarmTab({Key? key, required this.isSmartAlarmEnabled}) : super(key: key);
  @override
  State<AlarmTab> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "ai", "msg": "مرحباً بك في وحدة الذكاء الاصطناعي الأوفلاين. اسألني عن الصلاة، فضل الذكر، أو إذا كنت تشعر بالضيق الصدري."}
  ];

  void _sendMessage() {
    String query = _chatController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "msg": _chatController.text});
      String response = "تذكر دائماً أن بذكر الله تطمئن القلوب، جرب صياغة سؤالك بشكل آخر كالبحث عن (صلاة، ضيق، ذكر).";
      
      if (query.contains("صلاة") || query.contains("صلي")) {
        response = "الصلاة هي عماد الدين، وأقرب ما يكون العبد من ربه وهو ساجد؛ فحافظ عليها في وقتها لتنعم بالراحة الكلية.";
      } else if (query.contains("ضيق") || query.contains("حزين") || query.contains("تعبان")) {
        response = "إذا ضاق صدرك عليك بالقرآن وكثرة السجود والاستغفار؛ قال تعالى: 'وَلَقَدْ نَعْلَمُ أَنَّكَ يَضِيقُ صَدْرُكَ بِمَا يَقُولُونَ * فَسَبِّحْ بِحَمْدِ رَبِّكَ وَكُن مِّنَ السَّاجِدِينَ'.";
      } else if (query.contains("ذكر") || query.contains("أذكار") || query.contains("استغفار")) {
        response = "أفضل الذكر هو 'لا إله إلا الله'، وكثرة الاستغفار تفتح المغاليق وتجلب الرزق والبركة في يومك.";
      }
      
      _messages.add({"role": "ai", "msg": response});
    });
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مساعد أذكاري AI الشامل'), backgroundColor: const Color(0xFF161926), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                bool isUser = _messages[i]["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF5D48B7) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_messages[i]["msg"]!, style: TextStyle(color: isUser ? Colors.white : null), textAlign: TextAlign.right),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.send, color: Color(0xFF9D8BFF)), onPressed: _sendMessage),
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك هنا (مثال: أشعر بضيق)...',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final bool isSmartAlarmEnabled;
  final Function(bool) onAlarmSettingChanged;

  const SettingsTab({
    Key? key,
    required this.onThemeChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.isSmartAlarmEnabled,
    required this.onAlarmSettingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الإعدادات الشاملة'), backgroundColor: const Color(0xFF161926), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            title: const Text('المظهر الداكن (Dark Mode)'),
            value: Theme.of(context).brightness == Brightness.dark,
            activeColor: const Color(0xFF9D8BFF),
            onChanged: (v) => onThemeChanged(v),
          ),
          SwitchListTile(
            title: const Text('تشغيل منبه الفجر الرياضي الذكي'),
            subtitle: const Text('يجبرك على حل مسألة حسابية للاستيقاظ ونفي النوم'),
            value: isSmartAlarmEnabled,
            activeColor: const Color(0xFF9D8BFF),
            onChanged: (v) => onAlarmSettingChanged(v),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${fontSize.toInt()} px', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('تغيير حجم خط القرآن وتكبير السطور'),
              ],
            ),
          ),
          Slider(
            min: 16.0, max: 36.0,
            value: fontSize,
            activeColor: const Color(0
