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
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أذكاري AI',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        primaryColor: const Color(0xFF111322),
        cardColor: Colors.white,
        hintColor: const Color(0xFFB3924B),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070913),
        primaryColor: const Color(0xFFB3924B),
        cardColor: const Color(0xFF0F1221),
        hintColor: const Color(0xFFB3924B),
      ),
      home: const WelcomeSplashNavigator(),
    );
  }
}

// نافذة الترحيب بالصلاة على النبي عند فتح التطبيق
class WelcomeSplashNavigator extends StatefulWidget {
  const WelcomeSplashNavigator({Key? key}) : super(key: key);

  @override
  State<WelcomeSplashNavigator> createState() => _WelcomeSplashNavigatorState();
}

class _WelcomeSplashNavigatorState extends State<WelcomeSplashNavigator> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070913), Color(0xFF141931)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, size: 100, color: Color(0xFFB3924B)),
              SizedBox(height: 20),
              Text(
                'أذكاري AI',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
              ),
              SizedBox(height: 15),
              Text(
                'ﷺ صَلَّىٰ اللَّهُ عَلَيْهِ وَسَلَّمَ ﷺ',
                style: TextStyle(fontSize: 20, color: Color(0xFFB3924B), fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB3924B))),
            ],
          ),
        ),
      ),
    );
  }
}

// الشاشة الرئيسية التي تربط الخمسة أقسام بالأسفل
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _tabIndex = 4;

  final List<Widget> _appTabs = [
    const SettingsPanelTab(),
    const AISmartOfflineTab(),
    const QuranFullReaderTab(),
    const AzkarCategoriesTab(),
    const PrayerTimingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _appTabs[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F1221),
        selectedItemColor: const Color(0xFFB3924B),
        unselectedItemColor: Colors.white54,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'الإعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'الذكاء الاصطناعي'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'المكتبة'),
          BottomNavigationBarItem(icon: Icon(Icons.brightness_5), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }
}

// 1. شاشة الصلاة الرئيسية مع الإشعار الثابت والبوصلة والمنبه الذكي
class PrayerTimingsTab extends StatefulWidget {
  const PrayerTimingsTab({Key? key}) : super(key: key);
  @override
  State<PrayerTimingsTab> createState() => _PrayerTimingsTabState();
}

class _PrayerTimingsTabState extends State<PrayerTimingsTab> {
  int _userPoints = 250;
  String _selectedSheikh = 'الشيخ مشاري العفاسي';
  final Map<String, bool> _prayerChecklist = {
    "الفجر": true, "الظهر": false, "العصر": false, "المغرب": false, "العشاء": false
  };

  void _openSheikhSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1221),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: ['الشيخ مشاري العفاسي', 'الشيخ عبد الباسط عبد الصمد', 'الشيخ ماهر المعيقلي', 'الشيخ مصطفى إسماعيل'].map((sheikh) {
            return ListTile(
              title: Text(sheikh, style: const TextStyle(color: Colors.white)),
              trailing: _selectedSheikh == sheikh ? const Icon(Icons.check, color: Color(0xFFB3924B)) : null,
              onTap: () {
                setState(() => _selectedSheikh = sheikh);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _triggerSmartAlarmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F1221),
        title: const Text('🚨 منبه الفجر الذكي - لن يتوقف الأذان!', textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('سؤال 1 من 3:\nما هي السورة التي تسمى بقلب القرآن؟', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('سورة يس', style: TextStyle(color: Color(0xFFB3924B)))),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('سورة البقرة', style: TextStyle(color: Colors.white38))),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('سورة الكهف', style: TextStyle(color: Colors.white38))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكاري AI', style: TextStyle(color: Color(0xFFB3924B), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF070913),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // محاكاة لمركز الإشعارات الثابت العلوي للتطبيق
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF141931), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB3924B), width: 0.5)),
              child: const Row(
                children: [
                  Icon(Icons.notification_important, color: Color(0xFFB3924B)),
                  SizedBox(width: 10),
                  Text('إشعار ثابت: باقي 01:34:27 على صلاة المغرب', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // كارت واجهة الشاشة الرئيسية (مواقيت الصلاة والتاريخ والبوصلة)
            Card(
              color: const Color(0xFF0F1221),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('القاهرة، مصر', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 5),
                    const Text('24 ذو القعدة 1445 هـ | 2 يونيو 2024 م', style: TextStyle(fontSize: 14, color: Color(0xFFB3924B))),
                    const Divider(height: 25, color: Colors.white12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('حان وقت أذكار الصباح', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber)),
                            Text('لكي يطمئن قلبك لليوم ✨', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF141931)),
                          child: const Icon(Icons.explore, color: Color(0xFFB3924B), size: 40),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // أوقات الصلاة التفصيلية وثنائية ثلث الليل ومواقيت الشروق
            const Align(alignment: Alignment.centerRight, child: Text('مواقيت الصلاة والسنن النبوية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            _buildPrayerRow('الفجر', '4:20 ص', true),
            _buildPrayerRow('الشروق (تنبيه مخصوص)', '5:45 ص', false),
            _buildPrayerRow('الظهر', '12:30 م', true),
            _buildPrayerRow('العصر', '3:54 م', true),
            _buildPrayerRow('المغرب', '7:15 م', true),
            _buildPrayerRow('العشاء', '8:45 م', true),
            _buildPrayerRow('ثلث الليل الأخير', '1:15 ص', false),
            const SizedBox(height: 15),
            // تتبع الصلاة وصيام السنة والجوائز
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF0F1221), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🏆 نقاط الالتزام: $_userPoints', style: const TextStyle(color: Color(0xFFB3924B), fontWeight: FontWeight.bold)),
                      const Text('🎯 تتبع الصلوات وصيام السُّنّة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _prayerChecklist.keys.map((prayer) {
                      return Column(
                        children: [
                          Text(prayer, style: const TextStyle(fontSize: 11)),
                          Checkbox(
                            value: _prayerChecklist[prayer],
                            activeColor: const Color(0xFFB3924B),
                            onChanged: (val) => setState(() {
                              _prayerChecklist[prayer] = val!;
                              _userPoints += val ? 20 : -20;
                            }),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // زر تخصيص الشيوخ والمنبه الذكي للفجر
            ListTile(
              tileColor: const Color(0xFF0F1221),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.record_voice_over, color: Color(0xFFB3924B)),
              title: const Text('صوت الشيخ للأذان والإشعارات'),
              subtitle: Text(_selectedSheikh, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: const Icon(Icons.arrow_drop_down, color: Color(0xFFB3924B)),
              onTap: _openSheikhSelector,
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.redAccent.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 0.5)),
              child: ListTile(
                leading: const Icon(Icons.alarm_on, color: Colors.redAccent),
                title: const Text('منبه الفجر الرياضي الذكي (تحدي 3 أسئلة)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                trailing: const Icon(Icons.bolt, color: Colors.amber),
                onTap: _triggerSmartAlarmDialog,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time, bool isMain) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0F1221), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(isMain ? Icons.star_border : Icons.wb_twilight, size: 18, color: const Color(0xFFB3924B)),
          Text(name, style: TextStyle(fontWeight: isMain ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          Text(time, style: const TextStyle(color: Color(0xFFB3924B), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 2. شاشة الأذكار الشاملة بالقائمة الذكية والترجمة الانجليزية والمسبحة
class AzkarCategoriesTab extends StatefulWidget {
  const AzkarCategoriesTab({Key? key}) : super(key: key);
  @override
  State<AzkarCategoriesTab> createState() => _AzkarCategoriesTabState();
}

class _AzkarCategoriesTabState extends State<AzkarCategoriesTab> {
  int _counter = 0;
  String _searchWord = "";
  final List<Map<String, String>> _itemsList = [
    {"ar": "أذكار الصباح والمساء", "en": "Morning and Evening Remembrance", "cat": "الرئيسية"},
    {"ar": "أذكار السفر (الطيارة)", "en": "Travel Supplications", "cat": "السفر"},
    {"ar": "أذكار الملبس والطعام والشراب", "en": "Clothing, Food & Drink", "cat": "الحياة"},
    {"ar": "أذكار الصلاة والمنزل", "en": "Prayer and Home Remembrance", "cat": "العبادة"},
    {"ar": "أذكار الأوقات الصعبة والنسيان والامتحانات", "en": "Hard Times & Exams Supplications", "cat": "الدراسة"},
    {"ar": "أذكار الحج والعمرة والزواج والمرض", "en": "Hajj, Marriage & Illness Azkar", "cat": "المناسبات"},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF070913),
          title: const TabBar(
            indicatorColor: Color(0xFFB3924B),
            labelColor: Color(0xFFB3924B),
            tabs: [Tab(text: 'حصن المسلم والذكر'), Tab(text: 'المسبحة الذهب')],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchWord = v),
                    textAlign: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: '🔍 ابحث عن أي ذكر (طعام، سفر، نجاح)...',
                      filled: true, fillColor: const Color(0xFF0F1221),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _itemsList.length,
                    itemBuilder: (context, i) {
                      if (_searchWord.isNotEmpty && !_itemsList[i]["ar"]!.contains(_searchWord)) return const SizedBox();
                      return Card(
                        color: const Color(0xFF0F1221),
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(_itemsList[i]["ar"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(_itemsList[i]["en"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          trailing: const Icon(Icons.done_all, color: Color(0xFFB3924B), size: 18),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 تم الحفظ في قائمة المفضلة وقرائتها بنجاح')));
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('💥 سُبْحَانَ اللَّهِ وَبِحَمْدِهِ 💥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB3924B))),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () { setState(() => _counter++); HapticFeedback.lightImpact(); },
                  child: Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF0F1221), border: Border.all(color: const Color(0xFFB3924B), width: 3)),
                    child: Center(child: Text('$_counter', style: const TextStyle(fontSize: 54, color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(onPressed: () => setState(() => _counter = 0), icon: const Icon(Icons.refresh, color: Colors.redAccent), label: const Text('إعادة تصفير العداد', style: TextStyle(color: Colors.redAccent)))
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 3. شاشة القرآن الكريم الكامل مع محرك البحث للآيات والسور
class QuranFullReaderTab extends StatefulWidget {
  const QuranFullReaderTab({Key? key}) : super(key: key);
  @override
  State<QuranFullReaderTab> createState() => _QuranFullReaderTabState();
}

class _QuranFullReaderTabState extends State<QuranFullReaderTab> {
  String _queryText = "";
  final List<String> _surahNames = ["الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصحف الشريف الكامل'), backgroundColor: const Color(0xFF070913), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (v) => setState(() => _queryText = v),
              textAlign: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: '🔍 ابحث عن اسم السورة أو آية قرآنية كريمة...',
                fi
