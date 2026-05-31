import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CyberShieldApp());
}

class CyberShieldApp extends StatelessWidget {
  const CyberShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberShield AI',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  ThemeData _buildTheme() {
    const Color primary = Color(0xFF00FF88);       // Neon green
    const Color danger = Color(0xFFFF2D55);         // Alert red
    const Color warning = Color(0xFFFFB300);        // Warning amber
    const Color surface = Color(0xFF0A0E1A);        // Deep navy black
    const Color surfaceVariant = Color(0xFF111827); // Card dark
    const Color onSurface = Color(0xFFE2E8F0);      // Light text

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF00D4FF),
        error: danger,
        surface: surfaceVariant,
        onPrimary: Color(0xFF0A0E1A),
        onSecondary: Color(0xFF0A0E1A),
        onSurface: onSurface,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: onSurface),
          bodyMedium: TextStyle(color: Color(0xFF94A3B8)),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
    );
  }
}