import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

void main() {
  runApp(const MyApp());
}

// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mikiyas Zelalem Portfolio',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: Colors.grey[900]!,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// Portfolio Home Page
class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentSection = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;
    final double sectionHeight = maxScroll / 4; // Updated for 5 sections

    setState(() {
      _currentSection = (currentScroll / sectionHeight).floor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSideNav(context),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntroSection(),
                    const SizedBox(height: 100),
                    _buildAboutSection(),
                    const SizedBox(height: 100),
                    _buildTimelineSection(),
                    const SizedBox(height: 100),
                    _buildServicesSection(),
                    const SizedBox(height: 100),
                    _buildContactSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Side Navigation
  Widget _buildSideNav(BuildContext context) {
    return Container(
      width: 80,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.person, 'About', 1),
          _buildNavItem(Icons.timeline, 'Timeline', 2),
          _buildNavItem(Icons.work, 'Services', 3),
          _buildNavItem(Icons.mail, 'Contact', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentSection == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () {
          _scrollController.animateTo(
            index * (_scrollController.position.maxScrollExtent / 4),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: Tooltip(
          message: label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isActive ? Colors.blue.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Introduction Section
  Widget _buildIntroSection() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WELCOME TO MY PORTFOLIO',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hi, I\'m Mikiyas Zelalem',
            style: GoogleFonts.poppins(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'SEO Specialist',
                textStyle: GoogleFonts.poppins(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  height: 1.2,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Flutter Developer',
                textStyle: GoogleFonts.poppins(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    height: 1.2),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Affiliate Marketing Expert',
                textStyle: GoogleFonts.poppins(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    height: 1.2),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 3,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
          const SizedBox(height: 24),
          Text(
            'For over 5 years, I\'ve been working in tech and digital marketing. My goal is simple: I want to help you use technology and online marketing to grow your business and reach more people.',
            style: GoogleFonts.poppins(
                fontSize: 20, color: Colors.grey[300], height: 1.5),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _launchURL('https://mikiyaszelalem.com/contact/'),
            icon: const Icon(Icons.download),
            label: const Text('Download CV'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // About Section
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ABOUT ME',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Passionate about Digital Innovation',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'I love building mobile apps that people enjoy using, writing blog posts that are helpful and easy to read, and creating marketing strategies that actually work. My expertise spans Flutter app development, website development, affiliate marketing, and content creation.',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.grey[300],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        _buildSkillsSection(),
      ],
    );
  }

  // Skills Section
  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Skills',
          style: GoogleFonts.poppins(
              fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 24),
        _buildSkillBar('Flutter Development', 0.9),
        _buildSkillBar('SEO Optimization', 0.85),
        _buildSkillBar('Affiliate Marketing', 0.8),
        _buildSkillBar('UI/UX Design', 0.75),
        _buildSkillBar('Content Creation', 0.85),
      ],
    );
  }

  Widget _buildSkillBar(String skill, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill, style: GoogleFonts.poppins(fontSize: 16)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }

  // Services Section
  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MY SERVICES',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'What I Offer',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 40),
        _buildServiceItem(Icons.mobile_friendly, 'Flutter App Development',
            'Specializing in Flutter for cross-platform applications'),
        _buildServiceItem(Icons.web, 'Website Development',
            'Full-stack development with modern frameworks'),
        _buildServiceItem(Icons.trending_up, 'Affiliate Marketing',
            'Strategies to boost sales and drive conversions'),
        _buildServiceItem(Icons.edit, 'Content Creation',
            'Engaging and SEO-optimized blog content'),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 48, color: Colors.blue),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Contact Section
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GET IN TOUCH',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Ready to Work Together?',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Let\'s create something amazing that drives your business forward!',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.grey[300],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        _buildContactItem(Icons.email, 'me@mikiyaszelalem.com'),
        _buildContactItem(Icons.phone, '+251962489790'),
        _buildContactItem(Icons.web, 'mikiyaszelalem.com'),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () => _launchURL('https://mikiyaszelalem.com/contact/'),
          icon: const Icon(Icons.send),
          label: const Text('Send Message'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Text(text, style: GoogleFonts.poppins(fontSize: 18)),
        ],
      ),
    );
  }

  // Social Links
  Widget _buildSocialLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(FontAwesomeIcons.linkedin,
            'https://www.linkedin.com/in/mikiyaszelalem/'),
        _buildSocialIcon(
            FontAwesomeIcons.twitter, 'https://x.com/mikiyaszelalem0/'),
        _buildSocialIcon(FontAwesomeIcons.pinterest,
            'https://www.pinterest.com/mikiyaszelalem0/'),
        _buildSocialIcon(FontAwesomeIcons.quora,
            'https://www.quora.com/profile/Mikiyas-Zelalem-8'),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: FaIcon(icon),
        onPressed: () => _launchURL(url),
        color: Colors.blue,
        iconSize: 30,
      ),
    );
  }

  // URL Launcher
  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Timeline Section
  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MY CAREER JOURNEY',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'A Timeline of Professional Growth',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 40),
        _buildTimelineTile(
            '2020', 'Started my career as a junior web developer'),
        _buildTimelineTile(
            '2021', 'Transitioned to mobile app development with Flutter'),
        _buildTimelineTile('2022',
            'Launched my first successful affiliate marketing campaign'),
        _buildTimelineTile('2023',
            'Started my tech blog and grew it to 100k monthly visitors'),
        _buildTimelineTile('2024',
            'Expanded services to include full-stack development and digital marketing'),
      ],
    );
  }

  Widget _buildTimelineTile(String year, String description) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: year == '2018',
      isLast: year == '2023',
      indicatorStyle: const IndicatorStyle(
        width: 20,
        color: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
      beforeLineStyle: const LineStyle(color: Colors.blue),
    );
  }
}
