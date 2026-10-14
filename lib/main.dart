import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const PortfolioApp());

const kPrimary = Color(0xFF4F46E5);
const kAccent = Color(0xFF9333EA);
const kBg = Color(0xFFF5F6FA);
const kGradient = LinearGradient(
  colors: [kPrimary, kAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

/* ===================== SHARED WIDGETS ===================== */

class ProfileAvatar extends StatelessWidget {
  final double radius;
  const ProfileAvatar({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: kPrimary,
        child: ClipOval(
          child: Image.asset(
            'assets/photo.png', // put your photo at assets/photo.png
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.person, size: radius, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Fade + slide-up entrance animation.
class FadeSlide extends StatelessWidget {
  final int index;
  final Widget child;
  const FadeSlide({super.key, this.index = 0, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + index * 120),
      curve: Curves.easeOutCubic,
      builder: (_, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 30 * (1 - v)), child: c),
      ),
      child: child,
    );
  }
}

/* ===================== PAGE 1 - LOGIN ===================== */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _rollCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _rollCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_rollCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('Please enter Roll No. and Password'),
        ),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimary),
      suffixIcon: suffix,
      filled: true,
      fillColor: kBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: kGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeSlide(
                child: Column(
                  children: [
                    const ProfileAvatar(radius: 56),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_rounded, size: 34, color: Colors.white),
                        SizedBox(width: 10),
                        Text('My Portfolio',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Manaswini Thatipally',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.85))),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 12)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Login to view your e-portfolio',
                              style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 22),
                          TextField(
                            controller: _rollCtrl,
                            decoration: _decoration('Roll No.', Icons.badge_rounded),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: _decoration(
                              'Password',
                              Icons.lock_rounded,
                              suffix: IconButton(
                                icon: Icon(_obscure
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: kPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _login,
                              child: const Text('Login',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== PAGE 2 - DASHBOARD ===================== */

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  static const _titles = [
    'Academic Details',
    'Course Certifications',
    'Extra-Curricular Activities',
    'Achievements',
  ];

  final _pages = const [
    AcademicTab(),
    CertificationsTab(),
    ExtraCurricularTab(),
    AchievementsTab(),
  ];

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.logout_rounded, color: kPrimary, size: 32),
        title: const Text('Logout'),
        content: const Text('Do you want to go back to the Login page?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kPrimary),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).padding.top + 16, 20, 22),
            decoration: const BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: const Row(
              children: [
                ProfileAvatar(radius: 30),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manaswini Thatipally',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 4),
                      Text('B.Tech CSE  •  BVRIT Hyderabad',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(_titles[_index],
                    key: ValueKey(_index),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(child: IndexedStack(index: _index, children: _pages)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: kPrimary.withValues(alpha: 0.15),
        selectedIndex: _index,
        onDestinationSelected: (i) {
          if (i == 4) {
            _logout(); // 5th button = Logout
          } else {
            setState(() => _index = i);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.table_chart_outlined),
              selectedIcon: Icon(Icons.table_chart, color: kPrimary),
              label: 'Academic'),
          NavigationDestination(
              icon: Icon(Icons.workspace_premium_outlined),
              selectedIcon: Icon(Icons.workspace_premium, color: kPrimary),
              label: 'Certs'),
          NavigationDestination(
              icon: Icon(Icons.local_activity_outlined),
              selectedIcon: Icon(Icons.local_activity, color: kPrimary),
              label: 'Activities'),
          NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events, color: kPrimary),
              label: 'Achieve'),
          NavigationDestination(
              icon: Icon(Icons.logout_rounded), label: 'Logout'),
        ],
      ),
    );
  }
}

/* ---------- Tab 1: Academic Details (Table) ---------- */

class AcademicTab extends StatelessWidget {
  const AcademicTab({super.key});

  Widget _stat(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: kAccent),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: kPrimary)),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: fill in your 10th school
    const rows = [
      ['10th', 'Your School Name', '2022'],
      ['12th (MPC) - 98%', 'Alphores Junior College', '2022 - 2024'],
      ['B.Tech CSE 1st Yr', 'BVRIT Hyderabad College of Engineering for Women', '2024 - 2025'],
      ['B.Tech CSE 2nd Yr (CGPA 9.43)', 'BVRIT Hyderabad College of Engineering for Women', '2025 - 2026'],
    ];
    const head = TextStyle(fontWeight: FontWeight.bold, color: kPrimary);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FadeSlide(
          child: Row(
            children: [
              _stat('9.43', 'CGPA', Icons.grade_rounded),
              const SizedBox(width: 12),
              _stat('98%', 'Intermediate', Icons.menu_book_rounded),
              const SizedBox(width: 12),
              _stat('650+', 'DSA Solved', Icons.code_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FadeSlide(
          index: 1,
          child: Card(
            elevation: 2,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStatePropertyAll(kPrimary.withValues(alpha: 0.08)),
                dataRowMinHeight: 56,
                dataRowMaxHeight: 72,
                columnSpacing: 28,
                columns: const [
                  DataColumn(label: Text('Course', style: head)),
                  DataColumn(label: Text('Institution', style: head)),
                  DataColumn(label: Text('Year', style: head)),
                ],
                rows: rows
                    .map((r) => DataRow(cells: [
                          DataCell(ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 140),
                              child: Text(r[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)))),
                          DataCell(ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(r[1]))),
                          DataCell(Text(r[2])),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------- Tab 2: Course Certifications (Cards) ---------- */

class CertificationsTab extends StatelessWidget {
  const CertificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    const certs = [
      (name: 'Google Gen AI Exchange Program', platform: 'Google Cloud & Hack2Skill', year: '2025', icon: Icons.cloud_rounded, color: Color(0xFF0EA5E9)),
      (name: 'Anokhee Mentorship Program', platform: 'Amadeus', year: '2025', icon: Icons.groups_rounded, color: Color(0xFF9333EA)),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: certs.length,
      itemBuilder: (context, i) {
        final c = certs[i];
        return FadeSlide(
          index: i,
          child: Card(
            elevation: 2,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(c.icon, color: c.color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(c.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.apartment_rounded, size: 16),
                        label: Text(c.platform),
                        backgroundColor: kBg,
                        side: BorderSide.none,
                      ),
                      Chip(
                        avatar: const Icon(Icons.calendar_today_rounded, size: 14),
                        label: Text(c.year),
                        backgroundColor: kBg,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: kPrimary),
                      icon: const Icon(Icons.verified_rounded, size: 18),
                      label: const Text('Certificate'),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          icon: Icon(c.icon, color: c.color, size: 36),
                          title: Text(c.name, textAlign: TextAlign.center),
                          content: Text(
                              'Issued by ${c.platform} (${c.year})',
                              textAlign: TextAlign.center),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Close')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ---------- Tab 3: Extra-Curricular (ListView with icons) ---------- */

class ExtraCurricularTab extends StatelessWidget {
  const ExtraCurricularTab({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (icon: Icons.groups_rounded, title: 'Anokhee by Amadeus', sub: 'Mentee - software engineering & interview prep', color: Color(0xFF9333EA)),
      (icon: Icons.code_rounded, title: 'Competitive Programming', sub: '650+ DSA problems on LeetCode & Codeforces', color: Color(0xFF4F46E5)),
      (icon: Icons.emoji_events_rounded, title: 'Hackathons', sub: 'Smart India Hackathon - Internal Finalist', color: Color(0xFFF59E0B)),
      (icon: Icons.psychology_rounded, title: 'Google Gen AI Exchange', sub: 'Google Cloud & Hack2Skill program', color: Color(0xFF10B981)),
      (icon: Icons.build_rounded, title: 'Project Building', sub: 'TraceBack, Trawell, Smart SIP Investor', color: Color(0xFFEC4899)),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        return FadeSlide(
          index: i,
          child: Card(
            elevation: 1.5,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: it.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(it.icon, color: it.color),
              ),
              title: Text(it.title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(it.sub),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ),
        );
      },
    );
  }
}

/* ---------- Tab 4: Achievements (auto-playing animated slideshow) ---------- */

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  final _controller = PageController(viewportFraction: 0.84);
  Timer? _timer;
  int _current = 0;

  // To use real photos, replace the Icon with Image.asset('assets/ach1.jpg')
  static const _slides = [
    (icon: Icons.emoji_events_rounded, title: 'Smart India Hackathon', sub: 'Internal Finalist', a: Color(0xFFF59E0B), b: Color(0xFFEF4444)),
    (icon: Icons.code_rounded, title: '650+ DSA Problems', sub: 'LeetCode & Codeforces', a: Color(0xFF4F46E5), b: Color(0xFF06B6D4)),
    (icon: Icons.cloud_rounded, title: 'Google Gen AI Exchange', sub: 'Google Cloud & Hack2Skill', a: Color(0xFF10B981), b: Color(0xFF0EA5E9)),
    (icon: Icons.school_rounded, title: 'CGPA 9.43 / 10', sub: 'B.Tech CSE, BVRIT Hyderabad', a: Color(0xFF9333EA), b: Color(0xFFEC4899)),
    (icon: Icons.groups_rounded, title: 'Anokhee by Amadeus', sub: 'Mentorship Program', a: Color(0xFF14B8A6), b: Color(0xFF6366F1)),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_controller.hasClients) return;
      final next = (_current + 1) % _slides.length;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final s = _slides[i];
              final active = i == _current;
              return AnimatedScale(
                scale: active ? 1.0 : 0.88,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [s.a, s.b],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: s.a.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        bottom: -30,
                        child: Icon(s.icon,
                            size: 200,
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              child: Icon(s.icon, size: 64, color: Colors.white),
                            ),
                            const SizedBox(height: 22),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(s.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            Text(s.sub,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white70)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == _current ? 26 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _current ? kPrimary : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}